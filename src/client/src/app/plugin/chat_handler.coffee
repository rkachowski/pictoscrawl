define ["cs!app/plugin/plugin_handler"], (PluginHandler) ->
    class ChatHandler extends PluginHandler
        constructor: ->
            super "sez"

        processMessage: (message) =>
            @chatCallback? message[0], message[1]

        say: (message) =>
            @chatCallback? "you", message
            @huru.send ["say", message]

        setChatCallback:(@chatCallback) =>
