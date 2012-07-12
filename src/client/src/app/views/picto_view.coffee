define ["jquery", "cs!app/views/view_components", "cs!app/views/drawing_view"], ($, ViewComponents, DrawingView) ->
    chatCallback = loginCallback = (event) -> console.log "default callback"

    bindChat = ->
        $("#chat-message-submit").on "click", sendChatMessage
        $("#chat-message").keydown (event) ->
            if event.which is 13
                sendChatMessage()
                    
    bindLoginView = ->
        $("#login-button").on "click", sendLogin
        $("#login-box").keydown (event) ->
            if event.which is 13
                sendLogin()

    sendLogin = ->
        name = $("#login-box").val()
        $("#login-box").val ""
        loginCallback? name

    addUser= (username) ->
        if username.indexOf("#") != -1
            username = username.split("#")[1]

        $("#userbox").append "<div class='user' id='userbox-#{username}'><span class='name'>#{username}</span></div>"

    addChat= (user, message) ->
        if user.indexOf("#") != -1
            user = user.split("#")[1]
        $("#chatbox").append "<div class='chat'><span class='chatname'>#{user}</span><span class='chat-message'>#{message}</span></div>"

    addGameView = ->
        $("#container").empty()
        $("#container").append ViewComponents.gameView
        DrawingView.addView()
        bindChat()

    addLoginView = ->
        $("#container").empty()
        $("#container").append ViewComponents.loginView
        bindLoginView()

    removeUser = (username) ->
        if username.indexOf("#") != -1
            username = username.split("#")[1]

        user = $("#userbox-#{username}")
        console.log user
        user.remove()

    setChatCallback = (callback) ->
        chatCallback = callback

    setLoginCallback = (callback) ->
        loginCallback = callback

    sendChatMessage = ->
        message = $("#chat-message").val()
        $("#chat-message").val("")

        chatCallback? message

    #module exports
    setChatCallback:setChatCallback
    addUser:addUser
    addChat:addChat
    addGameView:addGameView
    addLoginView:addLoginView
    setLoginCallback:setLoginCallback
    removeUser:removeUser

