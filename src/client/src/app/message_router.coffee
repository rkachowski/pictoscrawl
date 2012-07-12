define ["cs!app/constants"], (Constants)->
    class MessageRouter
        constructor: (@huru) ->
            @callbacks = []
            @handlers = []
            @huru.addMessageCallback @handleMessage

        handleMessage: (message) =>
            splits = message.data.split Constants.huruMessageSeparator

            if splits[0] == "\r\n"
                return

            components = (comp for comp in splits when comp != "")

            type = components?[0]

            if not type
                console.log "router got an unprocessable message: #{message}"
                return

            if @callbacks[type]?
                for cb in @callbacks[type]
                    cb components[1..]
            else
                console.log "router has no callbacks for messages of type #{type}"
                #emit event here detailing message stuff

        addMessageCallback: (type, callback) =>
            @callbacks[type] or= []

            message_callbacks = @callbacks[type]
            message_callbacks.push callback

        addHandler:(handler) =>
            handler.setRouter @
            @handlers.push handler

