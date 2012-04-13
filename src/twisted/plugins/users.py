from huru import CommandPlugin, Response
import redis
import datetime

class RoomUsersPlugin(CommandPlugin):
    """List users within the room"""
    def after_join(self, rsp, req, cnx):
        users = cnx.room_users()
        #write users to new user
        cnx.write(Response("users",*users))

        r_server = redis.StrictRedis(host="localhost",password="firebastard-redis")

        user_no = r_server.incr("pictoscrawl:total_users")
        key = "pictoscrawl:users:"+str(user_no)
        values = dict(name=cnx.userid, date=str(datetime.datetime.now()))
        r_server.hmset(key, values)

#######
USERS = RoomUsersPlugin()
