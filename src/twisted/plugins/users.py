from huru import CommandPlugin, Response

class RoomUsersPlugin(CommandPlugin):
    """List users within the room"""
    def after_join(self, rsp, req, cnx):
        users = cnx.room_users()
        #write users to new user
        cnx.write(Response("users",*users))

#######
USERS = RoomUsersPlugin()
