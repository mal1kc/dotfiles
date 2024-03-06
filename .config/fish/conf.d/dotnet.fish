if test -x "$HOME/.dotnet/dotnet"
    set DOTNET_ROOT "$HOME/.dotnet"
    set PATH "$PATH:$HOME/.dotnet/:$HOME/.dotnet/tools"
    set DOTNET_CLI_TELEMETRY_OPTOUT 1

    export DOTNET_ROOT=$DOTNET_ROOT
    export PATH=$PATH
    export DOTNET_CLI_TELEMETRY_OPTOUT=$DOTNET_CLI_TELEMETRY_OPTOUT

    complete -f -c dotnet -a "(dotnet complete (commandline -cp))"
end
