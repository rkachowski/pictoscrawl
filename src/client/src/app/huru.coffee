define ["cs!app/constants"], (Constants) ->
    class HuzuRelay
        constructor:(@url) ->
            @callbacks =
                open:[]
                close:[]
                message:[]
                error:[]

        init: =>
            @socket = new WebSocket @url
            @socket.onclose = @closeHandler
            @socket.onerror = @errorHandler
            @socket.onmessage = @messageHandler
            @socket.onopen = @openHandler

        send: (message) =>
            if message instanceof Array
                sep = Constants.huruMessageSeparator
                message = sep + message.join sep

            @socket.send "#{message}\r\n"

        openHandler: (data) =>
            for cb in @callbacks.open
                cb data

        messageHandler: (data) =>
            for cb in @callbacks.message
                cb data
            
        errorHandler: (data) =>
            for cb in @callbacks.error
                cb data

        closeHandler: (data) =>
            for cb in @callbacks.close
                cb data

        addOpenCallback: (cb) =>
            @callbacks.open.push cb
            
        addErrorCallback: (cb) =>
            @callbacks.error.push cb

        addCloseCallback: (cb) =>
            @callbacks.close.push cb

        addMessageCallback: (cb) =>
            @callbacks.message.push cb

        addLoggingCallbacks: =>
            for key, callbacks of @callbacks
                callbacks.push (data) ->
                    message = data.data
                    if message?
                        console.log("got message: #{message}") unless message == "\r\n"
