define ["cs!app/plugin/plugin_handler"], (PluginHandler) ->
    class WorldHandler extends PluginHandler
        constructor: ->
            super "world"

        processMessage: (message) =>
            success = message[0]

            switch success
                when "in"
                    console.log "joined world #{message[1]}"
                    @current_world = message[1]
                    @callback?()
                when "NO"
                    console.log "failed to join world"

        joinWorld: (world) =>
            @huru.send ["world", world]
