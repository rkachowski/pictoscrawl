define ["cs!app/plugin/plugin_handler"], (PluginHandler) ->
    class RoomHandler extends PluginHandler
        constructor: ->
            super "room"

        processMessage: (message) =>
            success = message[0]

            switch success
                when "in"
                    console.log "in room #{message[1]}"
                    @current_room = message[1]
                when "NO"
                    @current_room = "NO_ROOM"

        joinRoom: (room) =>
            @huru.send ["join", room]
