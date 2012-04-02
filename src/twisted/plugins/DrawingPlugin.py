from huru import CommandPlugin, Response
from twisted.python import log

class DrawingPlugin(CommandPlugin):
    def do_drawing(self, req, cnx):
        """ relay drawings to everyone"""

        if len(req.args) > 3:
            return Response()

        #todo: only relay if we are currently drawing
        #todo: store current message
        #todo: only accept drawing messages from current drawer

        message = Response("drawing",req.args[-2],req.args[-1])
        cnx.write_room(message)
        return Response()

#######
DRAWING= DrawingPlugin()
