// header for nix-shell with bash5 and deno
const { Console, FileSystem } = await import("")


// required tools (that arent built/imported)
    // FileSystem.append
    // recursivelyEveryKeyValue(obj)
    // set(obj, keyList, value)
    // get(obj, keyList)
    // generateEventFileNames([ {name:name, placement: [0,0,0], path: "filepath" } ])
    // getParentShell
    // getPidOfThisProcess

// logic work
    // on init
        // create folder structure
        // establish all the shell files like .bashrc
        // make protected commands
        // add last step of every event to be setting the path to always have protected commands and commands
    // on generate deno hook
        // figure out placement in hook list
        // create a path using the name and placement
        // use the compiler commands to create a compile_deno_hook
            // embed the whole deno program into the file
            // have the file execute it using nix
    // on establish_extension
        // the extension folder when establish_extension is called
        // link things into the commands folder
        // get the on_start folder
        // source the on_start

async function getShellCompilers() {
    // TODO: look for interface.js instead
    const standardShellApi = [
        "create_deno_hook",
        "on_start_folder",
        "establish",
        "set_var",
    ]
    const output = {}
    // ensure that $HOME/settings/shells/ exists
    await FileSystem.createFolder(`${Console.home}/settings/shells/`)
    for (const eachPath of FileSystem.listFolders(`${Console.home}/settings/shells/`)) {
        const api = {}
        for (const eachTool of standardShellApi) {
            const toolPath = `${eachPath}/interface/${eachTool}`
            const toolInfo = await FileSystem.info(toolPath)
            if (toolInfo.exists) {
                await FileSystem.addPermission({owner: { canExecute: true }})
                api[eachTool] = (...args)=>Console.run(toolPath, ...args, Console.run.Stdout(Console.run.returnAsString))
            }
        }
        // if it has the full api
        if (Object.keys(api).length == standardShellApi.length) {
            const shellName = await FileSystem.basename(eachPath)
            // add it to the output
            output[shellName] = api
            // run the establish function
            // (should create/overwrite the .bashrc with something that iterates over shells/bash/events/rc)
            await output[shellName].establish()
        } else {
            // TODO: error 
        }
    }
}
const compilers = getShellCompilers()


const compileOutputPath = `/tmp/shell_manager/${getPidOfThisProcess()}`
export const ShellManger = {
    async appendToPath(string) {
        const path = Console.env.PATH
        // write to tmp/shell_manager/${this_pid_number}
        const compiler = compilers[getParentShell()]
        if (path.length > 0) {
            const compiledResult = await compiler.set_var("PATH", `${path}:${string}`)
            FileSystem.append(compileOutputPath, compiledResult)
        } else {
            const compiledResult = await await compiler.set_var("PATH", `${string}`)
            FileSystem.append(compileOutputPath, compiledResult)
        }
    },
    async injectToPath(string) {
        const path = Console.env.PATH
        // write to tmp/shell_manager/${this_pid_number}
        const compiler = compilers[getParentShell()]
        if (path.length > 0) {
            const compiledResult = await compiler.set_var("PATH", `${string}:${path}`)
            FileSystem.append(compileOutputPath, compiledResult)
        } else {
            const compiledResult = await await compiler.set_var("PATH", `${string}`)
            FileSystem.append(compileOutputPath, compiledResult)
        }
    },
    async exportVar(varName, value) {
        const compiledResult = await await compiler.set_var(varName, `${value}`)
        FileSystem.append(compileOutputPath, compiledResult)
    },
}


if (Deno.args[0] == "establish_extension") {
    const extensionInfo = yaml.read(Deno.args[1])
    // 
    // evaluate all the "$thing" keys
    // 
    for (const [keyList, value] of Object.entries(recursivelyEveryKeyValue(extensionInfo))) {
        let newValue = undefined
        if (typeof value == 'string') {
            newValue = await Console.run("bash", "-c", value, Console.run.Stdout(Console.run.returnAsString))
        } else if (value instanceof Array) {
            newValue = []
            for (const eachValue of value) {
                newValue.push(await Console.run("bash", "-c", eachValue, Console.run.Stdout(Console.run.returnAsString)))
            }
        }
        if (newValue !== undefined) {
            const mostNested = keyList.pop()
            const parent = get(extensionInfo, keyList)
            // remove the "$thing" version
            delete parent[last]
            const mostNestedWithoutDollarSign = mostNested.replace(/^\$/,"")
            // add the "thing" version
            set(extensionInfo, [...keyList, mostNestedWithoutDollarSign], newValue)
        }
    }

    // create folder structure
        // $HOME/
        //     settings/
        //         commands/
        //         shell_manager/
        //             default_shell
        //             protected_commands/
        //             hash_checks/
        //             extensions/
        //                 extension1/
        //                     0.0.1/
        //                         hooks/
        //                             generic/
        //                             hardcoded/
        //                         executables/
        //                             hello_world
        //         shells/
        //             zsh/
        //             fish/
        //             nu/
        //             bash/
        //                 interface/
        //                     create_deno_hook filename deno_content
        //                     on_start_folder [return string "rc"]
        //                     establish [create the .bashrc and other stuff]
        //                     set_var varname value
        //                 interface.js // alternative for faster compilation times
        //                 events/
        //                     profile/
        //                     rc/
        //                     login/
        //                     logout/
    
    // 
    // override the existing .profile/.bashrc/.bash_profile etc
    // 
        // 

    // 
    // path
    // 
        // inject
        // append
    
    // 
    // commands
    // 
        //
}