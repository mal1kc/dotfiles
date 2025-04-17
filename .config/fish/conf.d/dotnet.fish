if not test -n "$dotnet_conf_initialized"
    if test -f "$XDG_DATA_HOME/dotnet/dotnet"
        set -f dotnet_loc "$XDG_DATA_HOME/dotnet"
        if ! test -L "$HOME/.dotnet"
            ln -s "$dotnet_loc" "$HOME/.dotnet"
        end
    else if test -x "$HOME/.dotnet/dotnet"
        set -f dotnet_loc "$HOME/.dotnet"
    end
    if test -n "$dotnet_loc"
        export DOTNET_ROOT="$dotnet_loc"
        export DOTNET_CLI_HOME="$dotnet_loc"
        export PATH="$PATH:$dotnet_loc/:$dotnet_loc/.dotnet/tools"
        export DOTNET_CLI_TELEMETRY_OPTOUT=1

        complete -f -c dotnet -a "(dotnet complete (commandline -cp))"
    end
    export OMNISHARPHOME="$XDG_CONFIG_HOME"/omnisharp
    set -x dotnet_conf_initialized true
end
