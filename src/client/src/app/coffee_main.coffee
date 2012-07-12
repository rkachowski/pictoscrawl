modules = ["jquery","cs!app/dev_shit","cs!app/huru","cs!app/message_router",
    "cs!app/plugin/room_handler","cs!app/plugin/world_handler","cs!app/plugin/chat_handler",
   "cs!app/plugin/login_handler", "cs!app/plugin/users_handler", "cs!app/views/picto_view","cs!app/event_emitter","cs!app/controller/drawing_controller"]

define modules, ($, Dev, HuzuRelay, Router, RoomHandler, WorldHandler, ChatHandler, LoginHandler,UsersHandler, PictoView,Ev, DCont) ->
    rhand = whand = chand = loginh = null

    setup:->
        HuzuRelay.init()
        HuzuRelay.addLoggingCallbacks()

        Router.setHuru HuzuRelay

        loginh = new LoginHandler()
        loginh.setRouter Router
        loginh.loginCallback ->
            PictoView.addGameView()
            whand.joinWorld "picto"

        rhand = new RoomHandler()
        rhand.setRouter Router

        whand = new WorldHandler()
        whand.setRouter Router
        whand.setCallback -> rhand.joinRoom "main"
            
        chand = new ChatHandler()
        chand.setRouter Router
        chand.setChatCallback PictoView.addChat

        usersh = new UsersHandler()
        usersh.setCallback (users) ->
            for user in users
                PictoView.addUser user

        usersh.joinedHandler (users) ->
            console.log users
            for user in users
                PictoView.addUser user

        usersh.leftHandler (users) ->
            console.log users
            for user in users
                PictoView.removeUser user

        usersh.setRouter Router

        PictoView.addLoginView()
        PictoView.setLoginCallback (name) -> loginh.login(name)
        PictoView.setChatCallback (chat) -> chand.say(chat)

        DCont.init()
