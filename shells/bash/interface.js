const {FileSystem} = await import("")
const escapeArgument = (arg) =>`'${`${arg}`.replace(/'/g, `'"'"'`)}'`

export default {
    onStartFolder: "rc",
    establish() {
        // FIXME
        FileSystem.move(".profile"     ); FileSystem.write(".profile")
        FileSystem.move(".bashrc"      ); FileSystem.write(".bashrc")
        FileSystem.move(".bash_profile"); FileSystem.write(".bash_profile")
        FileSystem.move(".bash_login"  ); FileSystem.write(".bash_login")
        FileSystem.move(".bash_logout" ); FileSystem.write(".bash_logout")
    },
    createDenoHook(path, denoContent) {
        return FileSystem.write({
            path: path,
            data: `
                # run the code
                nix-shell --package bash5 --package deno --pure --run ${escapeArgument(`deno eval ${escapeArgument(denoContent)}`)}
                . "/tmp/shell_manager/$!" # source the compiled output from runnning the shell_manager_js file
            `,
        })
    },
    setVar(varName, value) {
        return `export ${varName}=${escapeArgument(value)}`
    }
}