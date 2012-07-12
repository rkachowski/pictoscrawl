define ["cs!app/plugin/plugin_handler"], (PluginHandler) ->
    class UsersHandler extends PluginHandler
        constructor: ->
            super "users"

        processMessage: (message) =>
            @callback? message

        joinedHandler:(joinedHandler)=>
            @router.addMessageCallback "joined",joinedHandler

        leftHandler:(leftHandler)=>
            @router.addMessageCallback "left", leftHandler

