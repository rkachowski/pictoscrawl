define ->
    class PluginHandler
        constructor: (@plugin_id) ->

        processMessage: (message) =>
            console.log message
            console.log "calling base PluginHandler processMessage - uhoh"

        setRouter: (router) =>
            router.addMessageCallback @plugin_id, @processMessage

            @router = router
            @setHuru router.huru

        setHuru: (huru) =>
            @huru = huru

        setCallback: (@callback) =>
