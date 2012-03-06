"""
   Twistd Application Config file
"""
from huru import Server
from twisted.application.service import Application
from twisted.application.internet import TCPServer

application = Application('huRU')
server = Server(["picto"]) 
SRV1 = TCPServer(8285, server)
SRV1.setServiceParent(application)
try: # if txws installed, websockets on 8280
    from txws import WebSocketFactory, WebSocketProtocol
    if "writeSequence" not in WebSocketProtocol.__dict__:
        def writeSequence(me, data):
            for datum in data:
                me.pending_frames.append(datum)
            me.sendFrames()
        WebSocketProtocol.writeSequence = writeSequence
    SRV2 = TCPServer(8280, WebSocketFactory(server))
    SRV2.setServiceParent(application)
except ImportError:
    pass # no txWS
