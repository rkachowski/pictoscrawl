define ["cs!app/views/picto_view"], (PictoView)->
    add_test_users: ->
        for i in [1..25]
            PictoView.addUser "username #{i}"
            
    add_test_chat: ->
        for i in [1..25]
            PictoView.addChat "username", " #{i} a message here"


