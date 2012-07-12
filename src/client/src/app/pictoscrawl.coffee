define ["cs!app/constants",
        "cs!app/dev_shit",
        "cs!app/huru",
        "cs!app/message_router",
        "cs!app/plugin/room_handler",
        "cs!app/plugin/world_handler",
        "cs!app/plugin/chat_handler",
        "cs!app/plugin/login_handler",
        "cs!app/plugin/users_handler",
        "cs!app/views/picto_view",
        "cs!app/event_emitter",
        "cs!app/controller/drawing_controller"], (Constants, Dev, HuzuRelay, Router, RoomHandler, WorldHandler, ChatHandler, LoginHandler,UsersHandler, PictoView,Ev, DCont) ->
    class Pictoscrawl
        @setup: =>
            @huru = new HuzuRelay Constants.wsUri
            @huru.addLoggingCallbacks()

            @router = new Router @huru

            @setupViews()
            @setupRouterCallbacks()

            @huru.init()

        @setupViews: =>
            PictoView.addLoginView()

            PictoView.setLoginCallback (name) ->
                Ev.fire "login", name

            PictoView.setChatCallback (chat) ->
                Ev.fire "chat", chat

            Ev.on "add_game_view", () ->
                PictoView.addGameView()

            DCont.init @router, @huru

        @setupRouterCallbacks:() =>
            loginh = new LoginHandler
            @router.addHandler loginh

            chath = new ChatHandler
            @router.addHandler chath

            whand = new WorldHandler
            @router.addHandler whand
            
            uhand = new UsersHandler
            @router.addHandler uhand

            rhand = new RoomHandler
            @router.addHandler rhand

            loginh.loginCallback ->
                Ev.fire "add_game_view"
            
            Ev.on "chat", (chat) ->
                chath.say(chat)

            Ev.on "login", (name) ->
                loginh.login(name)

            Ev.on "add_game_view", () ->
                whand.joinWorld "picto"

            Ev.on "joined_world", ()->
                rhand.joinRoom "main"

            chath.setChatCallback PictoView.addChat
            
            uhand.setCallback (users) ->
                for user in users
                    PictoView.addUser user

            uhand.joinedHandler (users) ->
                for user in users
                    PictoView.addUser user

            uhand.leftHandler (users) ->
                for user in users
                    PictoView.removeUser user

            whand.setCallback ->
                Ev.fire "joined_world"

