define ["cs!app/plugin/plugin_handler"], (PluginHandler) ->
    class Login extends PluginHandler
        constructor: ->
            super "OK"

        setRouter: (router) =>
            super router
            router.addMessageCallback "KO", @processLogout

        processMessage: (message) =>
            console.log "logged in as #{message}"
            @loginCallback?()

        processLogout: (reason) =>
            console.log "logged out! reason: #{reason}"
            @logoutCallback?()

        login: (username) =>
            @huru.send ["login", username]

        loginCallback: (@loginCallback) =>

        logoutCallback: (@logoutCallback) =>
