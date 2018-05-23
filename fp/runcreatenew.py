#import mysql.connector
import MySQLdb
import os
db = MySQLdb.connect("localhost","root","suk4suk44dm1n@lab","cloud" )
sql2="SELECT * FROM pembayaran where verified=1"
cursor = db.cursor()
cursor.execute(sql2)
data = cursor.fetchall()
if len(data)>0:
	for i in data:
		sql = "UPDATE pembayaran SET verified = 2 where username='"+i[1]+"'"
		cursor.execute(sql)
		db.commit()
	for i in data:
		eksekusi="./create_new_node "+str(i[0])+" 10.11.12."+str(i[0])+" "+str(i[1])
		#print eksekusi
		ls=os.system(eksekusi)
db.close()
#print data
#ls=os.system("./create_new_node 69 10.11.12.69 plx")
#print ls
