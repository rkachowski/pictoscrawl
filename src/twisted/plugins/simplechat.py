from huru import CommandPlugin, Response

class SimpleChatPlugin(CommandPlugin):
    def do_say(self, req, cnx):
        """ say stuff to everyone """
        userid = cnx.userid
        message = Response("sez",userid,*req.args)
        cns.write_room(message)
        return Response()

#######
SIMPLECHAT= SimpleChatPlugin()
