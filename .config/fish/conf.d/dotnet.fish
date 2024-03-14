if test -x "$HOME/.dotnet/dotnet"
    export DOTNET_ROOT="$HOME/.dotnet"
    export PATH="$PATH:$HOME/.dotnet/:$HOME/.dotnet/tools"
    export DOTNET_CLI_TELEMETRY_OPTOUT=1

    complete -f -c dotnet -a "(dotnet complete (commandline -cp))"
end
