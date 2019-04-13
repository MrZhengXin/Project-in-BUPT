#-*- coding:utf-8 -*-

from DNSSocket import Options
import mysql.connector

class DNS_DB:
    def __init__(self,user = 'root',password = 'password',database = 'dnsrelay'):
        self._user = user
        self._password =  password
        self._database =  database
        self._connect  =  None
        self._cursor   =  None
        print('-Create database sample successfully')

    #建立连接
    def _connect_db(self):       
        self._connect = mysql.connector.connect(user=self._user,password=self._password,database=self._database)
        self._cursor  = self._connect.cursor()
        print('-Connect to {} successfully'.format(self._database))
    
    #关闭数据库
    def _close_db(self):
        self._cursor.close()
        self._connect.close()
        print('-Close connect successfully')
    
    def getDomainIpMap(self,QNAME,QTYPE,QCLASS):
        self._connect_db()
        condition=('SELECT RDATA FROM dnsrr WHERE NAME=%s and TYPE=%s and CLASS=%s')
        parameter=(QNAME,QTYPE,QCLASS)
        self._cursor.execute(condition,parameter)
        answer_tup = self._cursor.fetchall()                   #列表类型，每个结果是一个元组  eg. [('1 zephyr',),('2 top',)] 
        answer_list=[list(item) for item in answer_tup]        #列表中的元组转换为列表       eg. [['1 zephyr'], ['2 top']] 
        format_answer=sum(answer_list,[])                      #去掉嵌套                   eg. ['1 zephyr', '2 top']
        if '0.0.0.0' in format_answer:
            print('-DominName does not exist')
            return format_answer,True
            
        elif  format_answer:
            return format_answer,True
            
        else:
            print('-Records not found.Sending query to remote server')
            return None,False
    
    # 若本地数据库查询失败，将远端服务器返回的响应包中提取所需信息，存入数据库
    # 目前能处理远端服务器发送的一个资源记录
    def _insert_tb(self,QNAME,QTYPE,QCLASS,TTL,RDATA):
        
        try:
            condition=('INSERT INTO dnsrr (NAME,TYPE,CLASS,TTL,RDATA) VALUES(%s,%s,%s,%s,%s)')
            parameter=(QNAME,QTYPE,QCLASS,TTL,RDATA)
            self._cursor.execute(condition,parameter)      
            self._connect.commit()
            print('-Insert success')
        except Exception as error:
            print(error)
            print('-Insert failed')
        finally:
            self._close_db()    
            
            




#数据库连接测试
def conn_test():
    db = DNS_DB()
    result = db.getDomainIpMap('cctv1.net','A','IN')      
    print(result)
    if  result[-1] == False :
        db._insert_tb('cctv1.net','A','IN',86400,'0.0.0.0')
    else:
        db._close_db()
    

conn_test()
'''
# 当前的资源记录表
            ('www.baidu.com','A','IN',86400,'111.13.100.91'),
		    ('www.123.com','A','IN',86400,'61.132.13.130'),
			('cctv1.net','A','IN',86400,'0.0.0.0') , 
            ('www','CNAME','IN',86400,'star.cs.vu.nl'),
            ('cs.vu.nl','SOA','IN',86400,'star boss(9257,7200,7200,241920,86400)'),
            ('cs.vu.nl','MX','IN',86400,'1 zephyr'),
            ('cs.vu.nl','MX','IN',86400,'2 top')          
'''
                
    

    
          



'''  
class IpMap:
    IpMap = getDomainIpMap(Options.filename)
''' 
'''
dns_relay = mysql.connector.connect(
        user = 'root',
        password = 'password',
        database = 'dnsrelay'
        )
cursor = dns_relay.cursor()



  
