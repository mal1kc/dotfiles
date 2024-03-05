if test -x "$HOME/.dotnet/dotnet"
    set DOTNET_ROOT "$HOME/.dotnet"
    set PATH "$PATH:$HOME/.dotnet/:$HOME/.dotnet/tools"
    set DOTNET_CLI_TELEMETRY_OPTOUT 1
    complete -f -c dotnet -a "(dotnet complete (commandline -cp))"
end
