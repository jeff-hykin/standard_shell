// header for nix-shell with bash5 and deno
const { Console, FileSystem } = await import("")


// required tools (that arent built/imported)
    // recursivelyEveryKeyValue(obj)
    // set(obj, keyList, value)
    // get(obj, keyList)
    // generateEventFileNames([ {name:name, placement: [0,0,0], path: "filepath" } ])
    // compileGenericScript(obj)
        // var
        // execute
        // check
        // exists
        // file_exists
        // folder_exists
    // parseEventNamesIntoOrder(folder_path)
    // iterativelyReturnEventFilepaths


async function getShellCompilers() {
    const standardShellApi = [
        "on_start_folder",
        "establish",
        "execute",
        "get_var",
        "set_var",
        "file_exists",
        "folder_exists",
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
        //                     on_start_folder
        //                     establish
        //                     execute
        //                     get_var
        //                     set_var
        //                     file_exists
        //                     folder_exists
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