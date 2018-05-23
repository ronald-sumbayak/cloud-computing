import MySQLdb
import os

db = MySQLdb.connect ('localhost', 'cloud', 'cloud', 'tekankata')
cursor = db.cursor ()
cursor.execute ('SELECT * FROM pembayaran WHERE verified = 1')
verified = cursor.fetchall ()

if len (verified) > 0:
    for p in verified:
        sql = 'UPDATE pembayaran SET verified = 2 WHERE username = "%s"' % p[1]
        cursor.execute (sql)
        db.commit ()
    for p in verified:
        os.system ('./create_new_node %s %s' % (p[0], p[1]))
db.close ()
