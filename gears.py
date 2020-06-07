import time
import redis

conn = redis.Redis()

with open('/home/guy/redisclients/rghibernate/target/rghibernate-0.0.1-SNAPSHOT-jar-with-dependencies.jar', 'rb') as f:
    data = f.read()
    start = time.time()
    res = conn.execute_command('rg.jexecute', 'com.redislabs.WriteBehind', data)
    end = time.time()
    print(res)
    print('took : %s' % (end - start))                                           