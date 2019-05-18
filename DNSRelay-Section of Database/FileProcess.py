#-*- coding:utf-8 -*-
from DNSPacket import DNSHeader,DNSQuestion,DNSMessage,DNSRR
from DNSSocket import Options
import mysql.connector
import struct
import socket
import time

class DNS_DB:
    def __init__(self,user = Options.databaseUserName ,password = Options.databasePassword ,
                 host = Options.databaseHost ,port = Options.databasePort ,database = Options.database):
        '''
        初始化数据库连接信息
        '''
        self._user = user
        self._password =  password
        self._host     =  host
        self._port     =  port
        self._database =  database
        self._connect  =  None
        self._cursor   =  None
        # print('-Create database sample successfully')

    def _connect_db(self):    
        '''
        建立连接
        '''   
        try:
            self._connect = mysql.connector.connect(user=self._user,
                                                    password=self._password,
                                                    host=self._host,
                                                    port=self._port,
                                                    database=self._database)
            self._cursor  = self._connect.cursor()
        except Exception as err:
            print("connect error = %s"%err)
        # print('-Connect to {} successfully'.format(self._database))
    
    def _close_db(self):
        '''
        关闭连接,防止泄露
        '''
        try:
            self._cursor.close()
            self._connect.close()
        except Exception as err:
            print("close error = %s"%err)
        # print('-Close connect successfully')
    
    def getDomainIpMap(self,QNAME,QTYPE,QCLASS):
        '''
        根据域名、TYPE、CLASS查询数据库中对应的值
        返回一个列表类型的查询结果和布尔类型的值
        返回值的格式为：[(name1, type1, class1, ttl1, data1,timestamp1),(name2, type2, class2, ttl2, data2,timestamp2),]
        '''
        condition=('SELECT * FROM dnsrr WHERE NAME=%s and TYPE=%s and CLASS=%s')
        parameter=(QNAME, QTYPE, QCLASS)
        self._cursor.execute(condition,parameter)
        answer_list = self._cursor.fetchall()   # 列表类型，每个结果是一个元组  eg. [(name1, type1, class1, ttl1, data1,timestamp1),]
        
        if answer_list:    #查询得到结果，但没有检测是否过期
            current_time =int(time.time())
            for item in answer_list:       #检验TTL
                if current_time-item[5]>item[3]:    #记录过期
                    condition=('DELETE FROM dnsrr WHERE NAME=%s and TYPE=%s and CLASS=%s')
                    parameter=(QNAME, QTYPE, QCLASS)
                    self._cursor.execute(condition,parameter)  #删除过期
                    self._connect.commit()
                    print('过期已删除',QNAME)
                    return None,False     
                else:                               #记录有效
                    return answer_list,True
        else:
            if QTYPE =='A':
                temp_answer, flag = self.getDomainIpMap(QNAME, 'CNAME', QCLASS)
                answer_list = []
                findResult = False
                if flag:
                    for item in temp_answer:
                        answer, isSelected = self.getDomainIpMap(item[4], 'A', QCLASS)
                        if isSelected:
                            answer_list.append(item)
                            answer_list.extend(answer)
                            findResult = True
                    if findResult:
                        return answer_list, True
            return None,False
        
    def _insert_db(self,records):
        '''
        将列表类型的RRs信息，存入数据库
        能处理远端服务器发送的多条资源记录；
        '''
        if records:
            condition=('INSERT INTO dnsrr (NAME,TYPE,CLASS,TTL,RDATA,TIMESTAMP) VALUES(%s,%s,%s,%s,%s,%s)')
            for item in records:
                try:
                    self._cursor.execute(condition, item)
                    self._connect.commit()
                except Exception as error:
                    print("insert error = %s"%error)
                # self._cursor.executemany(condition,[record for record in records])      
                # self._connect.commit()
                # print('-Insert success')
                # print(error)
                # print('-Insert failed')
        else:
            pass

def _get_records(message):
    '''
    若数据库查询失败
    从远端服务器返回的响应包（已拆好）中提取所需RRs信息
    返回列表类型的资源记录
    仅支持type_list的4种类型，其他的丢弃
    eg.  [ ('flits','A','IN',86400,'130.37.16.112'),
           ('flits','A','IN',86400,'192.31.231.165') ] 
    '''

    RR_count = message.RRNum
    records = []
    type_list = ['A','CNAME','MX','NS']
    current_time=int(time.time())
    for i in range(0,RR_count):
        if message.RRs[i].TYPE in type_list:
            records.append( (
                        str(message.RRs[i].NAME),
                        str(message.RRs[i].TYPE),
                        str(message.RRs[i].CLASS),
                            message.RRs[i].TTL,
                        str(message.RRs[i].RDATA),
                        current_time

            ) )
        
        else:
            # print('-Nonidentifiable type has been discarded')
            records = []
            break
    return records
 

def buildResponse(message,  result):
    '''
    
    构造回复包，message为原包，type为查询的type, result为查询的结果,不包含True
    返回：DNSMessage response
    '''
    # RR_list = result
    

    ID = message.header.ID
    # flag段
	#   |QR|  opcode   |AA|TC|RD|RA|   Z    |   RCODE   |
    QR = 1
    opCode= message.header.opCode
    AA = 0
    TC = message.header.TC
    RD = message.header.RD
    RA = message.header.RA
    Z  = 0
    
    QDCOUNT = message.questionNum
    NSCOUNT = 0
    ARCOUNT = 0
    
    #只有一个question
    question = message.questions[0]
    QNAME = question.QNAME
    QTYPE = question.QTYPE
    QCLASS= question.QCLASS
   
    # RRNAME = question.QNAME
    # RRTYPE = question.QTYPE
    # RRCLASS= question.QCLASS
    RRS    = []

    banned = False
    for item in result:
        if item[4] == '0.0.0.0':
            banned = True
            break
    if banned == True:
        RRnum = 0
        RCODE = 3
        ANCOUNT = 0
    else:
        RRnum = len(result)
        RCODE = 0
        ANCOUNT = RRnum
        for rr in result:
            record = DNSRR(rr[0], rr[1], rr[2], rr[3], 0, rr[4])
            RRS.append(record)
    # if '0.0.0.0' in result  :
    #     RRnum = 0
    #     RCODE = 3
    #     ANCOUNT = 0
    # else:
    #     RRnum  = len(result)
    #     RCODE = 0
    #     ANCOUNT = RRnum
    #     for rrs in RR_list:
    #         rr_list=DNSRR(RRNAME,RRTYPE,RRCLASS,86400,0,rrs)
    #         RRS.append(rr_list)

    question = DNSQuestion(QNAME,QTYPE,QCLASS)
    questions = []
    questions.append(question)
    header = DNSHeader(ID,QR,opCode,AA,TC,RD,RA,Z,RCODE,QDCOUNT,ANCOUNT,NSCOUNT,ARCOUNT)
    response = DNSMessage(header,questions,RRS)
    return response

#-----------以下均为测试用例------------  #          

# # 构造测试包 测试RRs的输出格式  
# def testMessage():
#     header = DNSHeader(2, 1, 0,0,0,1,1,0,0,1,5,0,0)
#     query = DNSQuestion("www.bing.com", 'A', 'IN')
#     RR1 = DNSRR('www.bing.com', 'CNAME', 'IN', 210, 42, 'a-0001.a-afdentry.net.trafficmanager.net')
#     RR2 = DNSRR('a-0001.a-afdentry.net.trafficmanager.net', 'CNAME', 'IN', 139, 23, 'cn.cn-0001.cn-msedge.net')
#     RR3 = DNSRR('NS-leixingjiance', 'NS', 'IN', 31, 2, 'cn-0001.cn-msedge.net')
#     RR4 = DNSRR('MX-leixingjiance', 'MX', 'IN', 34, 4, '0.0.0.0')
#     RRS = []
#     RRS.append(RR1)
#     RRS.append(RR2)
#     RRS.append(RR3)
#     RRS.append(RR4)
#     questions = []
#     questions.append(query)
#     message = DNSMessage(header, questions, RRS)
#     return message

# def test_buildQuerypacket():
#     header = DNSHeader(2, 1, 0,0,0,1,1,0,0,1,0,0,0)
#     query = DNSQuestion('cn-0001.cn-msedge.net', 'A', 'IN')
    
#     questions = []
#     questions.append(query)
#     message = DNSMessage(header, questions)
#     return message

# def test_buildResponse():
#     querypacket = test_buildQuerypacket()
#     db = DNS_DB()
#     db._connect_db()
#     # result  = db.getDomainIpMap('www.bing.com', 'A', 'IN')
#     # result_list = result[0]
#     result_list=('0.0.0.0')
#     db._close_db()
#     response = buildResponse(querypacket,result_list)
#     return response

# #response = test_buildResponse()


# def records_print_test():
#     mes   = testMessage()
#     count = mes.RRNum
#     print('RRSnum = ',count)
#     a = []
#     for i in range(0,count):
#         a.append(mes.RRs[i])
#     j=1
#     for b in a:
#         print('RRs[{}] = '.format(j),b.NAME,b.TYPE,b.CLASS,b.TTL,b.RDATA,'\n')
#         j+=1
# #records_print_test()

# # _get_records测试
# def _get_records_test():
#     mes = testMessage()
#     result = _get_records(mes)
#     if result:
#         print(result)
#         for item in result:
#             print(item)

#_get_records_test()


# 数据库连接,查询，
# 插入来自远端服务器响应包的RR测试
# 测试成功-- 4/24

# 新增'MX','NS'类型
# 测试成功-- 5/3
# def conn_test():
#     mes = testMessage()
#     db = DNS_DB()
#     result = db.getDomainIpMap('ASFASFDAe.net', 'MX', 'IN')      
#     print(result)
#     if  result[-1] == False :
#         records = _get_records(mes)
#         db._insert_db(records)
#     else:
#         db._close_db()

# conn_test()


            #当前的资源记录表
            # ('www.baidu.com','A','IN',86400,'111.13.100.91'),
		    # ('www.123.com','A','IN',86400,'61.132.13.130'),
			# ('cctv1.net','A','IN',86400,'0.0.0.0') , 
            # ('www','CNAME','IN',86400,'star.cs.vu.nl'),
            # ('cs.vu.nl','SOA','IN',86400,'star boss(9257,7200,7200,241920,86400)'),
            # ('cs.vu.nl','MX','IN',86400,'1 zephyr'),
            # ('cs.vu.nl','MX','IN',86400,'2 top')
            # 插入多行成功
            # ('flits','A','IN',86400,'130.37.16.112')
            # ('flits','A','IN',86400,'192.31.231.165')
            # ('flits','MX','IN',86400,'1 flits')
            # ('flits','MX','IN',86400,'2 zephyr')
            # ('flits','MX','IN',86400,'3 top')
            # （'laserjet','A','IN','0','130.37.62.23')
            

# 数据库连接,多个response插入测试
def conn_test():
    db = DNS_DB()
    db._connect_db()
    result = db.getDomainIpMap("www.baidu.com", 'CNAME', 'IN')
    print(result)
    db._close_db()
    
#     mes = testMessage()  
#     print(result)
#     if  result[-1] == False :
#         records = _get_records(mes)
#         db._insert_db(records)
                   
    
# conn_test()
    
          






  
