from typing import BinaryIO, List
import requests
from datetime import datetime
from dateutil import parser
import time
import os
import psycopg2

def getGPWSCHeirarchy(authToken):

        # call the projectmodule mdms for each unique tenant which would return the array of unique villages( i.e tenantid) along with the respectie
        # zone circle division subdivision project 
        # https://realpython.com/python-requests/ helps on how make ajax calls. url put it in app.properties and read through configs
        
        try:
            
                
            url = os.getenv('API_URL')
            requestData = {
                "RequestInfo": {
                    "apiId": "mgramseva-common",
                    "ver": 0.01,
                    "ts": "",
                    "action": "_search",
                    "did": 1,
                    "key": "",
                    "msgId": "",
                    "authToken":authToken
                 },
                "MdmsCriteria": {
                    "tenantId": "pb",
                    "moduleDetails": [
                        {
                            "moduleName": "tenant",
                            "masterDetails": [
                                {
                                    "name": "projectmodule"
                                }
                            ]
                        }
                    ]
                }
            }
            
            response = requests.post(url+'egov-mdms-service/v1/_search', json=requestData)
            
            responseData = response.json()
            projectModuleList = responseData['MdmsRes']['tenant']['projectmodule']
            dataList = []
           
            for zoneData in projectModuleList:
                circle = zoneData['circle']
                for circleData in circle:
                    division = circleData['division']
                    for divisionData in division:
                        subDivision = divisionData['subdivision']
                        for subdivisionData in subDivision:
                            section = subdivisionData['section']
                            for sectionData in section:
                                project = sectionData['project']
                                for projectData in project:
                                    tenantId = projectData['name'].replace(" ", "").lower()
                                    formatedTenantId= "pb."+tenantId;
                                    obj1 = {
                                                "tenantId":formatedTenantId,
                                                "zone":zoneData['name'],
                                                "circle":circleData['name'],
                                                "division":divisionData['name'],
                                                "subdivision":subdivisionData['name'],
                                                "section":sectionData['name'],
                                                "projectcode":projectData['code']
                                           }
                                    
                                    dataList.append(obj1)
            print("heirarchy collected")
            #return [{"tenantId":"pb.lodhipur", "projectcode":"1234","zone":"zone1","circle":"Circle1","division":"Dvisiion1","subdivision":"SD1", "section":"sec1"}]
            return dataList
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)

def getConsumerCreated(tenantId):
        # query the postgresql db to get the total count of total connection in the given tenant till date  
        print("consumer created count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
             
            CONSUMER_CREATED_COUNT_QUERY = "select count(*) from eg_ws_connection where status = 'Active' and tenantid = '"+tenantId+"'"
            cursor.execute(CONSUMER_CREATED_COUNT_QUERY)
            result = cursor.fetchone()
            print(result[0])
            return result[0]
         
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
        
        finally:
            if connection:
                cursor.close()
                connection.close()

def getRateMasters(tenantId, authToken):
        # make mdms call to get the rate unique rate masters i.e billig slab . count the unique billing slabs and return the number
        print("Rate master count returned")
        try:
            
                
            url = os.getenv('API_URL')
        
            requestData = {
                "RequestInfo": {
                    "apiId": "mgramseva-common",
                    "ver": 0.01,
                    "ts": "",
                    "action": "_search",
                    "did": 1,
                    "key": "",
                    "msgId": "",
                    "authToken":authToken
                 },
                "MdmsCriteria": {
                    "tenantId": tenantId,
                    "moduleDetails": [
                        {
                            "moduleName": "ws-services-calculation",
                            "masterDetails": [
                                {
                                    "name": "WCBillingSlab"
                                }
                            ]
                        }
                    ]
                }
            }

            response = requests.post(url+'egov-mdms-service/v1/_search', json=requestData)
        
            responseData = response.json()
            wcBillingSlabList = responseData['MdmsRes']['ws-services-calculation']['WCBillingSlab']
          
            return len(wcBillingSlabList)
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
  
def getLastDemandDate(tenantId):
    # make db call to get the last demand generated date for the given tenant
        print("last demand date returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()  
            
            LAST_DEMAND_DATE = "select createdtime from egbs_demand_v1 where tenantid = '"+tenantId+"'"+" order by createdtime desc LIMIT 1"
            
            cursor.execute(LAST_DEMAND_DATE)
            result = cursor.fetchone()
                      
            formatedDate = datetime.fromtimestamp(result[0]/1000.0)
            print(formatedDate)
            
            return formatedDate
            
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception) 
        
        finally:
            if connection:
                cursor.close()
                connection.close()
        
def getCollectionsMade(tenantId):
        # make db call with query to get the collections made in the current date in the given tenant
        #should be till date not current date. 
        print("collections made returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()
          
            COLLECTION_MADE_TILL_THE_CURRENT_DATE_QUERY = "select sum(amountpaid) from egcl_paymentdetail where businessservice = 'WS' and tenantid = '"+tenantId+"'"
              
            cursor.execute(COLLECTION_MADE_TILL_THE_CURRENT_DATE_QUERY)
            result = cursor.fetchone()
            print(result[0])
            return result[0]
        
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
        
        finally:
            if connection:
                cursor.close()
                connection.close()
        
def getCollectionsMadeOnline(tenantId):
        # make db call with query to get the collections made in the current date of type online in the given tenant, as of now no data exists but write the query
        #should be till date not current date. 
       
        print("collections made online returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            COLLECTION_MADE_TILL_THE_CURRENT_DATE_ONLINE_QUERY = "select sum(pd.amountpaid) from egcl_payment p join egcl_paymentdetail pd on p.id = pd.paymentid where pd.businessservice = 'WS' and p.tenantid = '"+tenantId+"'" + " and p.paymentmode = 'ONLINE' "
        
            cursor.execute(COLLECTION_MADE_TILL_THE_CURRENT_DATE_ONLINE_QUERY)
            result = cursor.fetchone()
            print(result[0])
            return result[0]
            
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
        
        finally:
            if connection:
                cursor.close()
                connection.close()

def getLastCollectionDate(tenantId):
        # make db call to get the last collection date for the given tenant    
        print("lat collection date returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            LAST_COLLECTION_DATE_QUERY = "select createdtime from egcl_paymentdetail where businessservice = 'WS' and tenantid = '"+tenantId+"'" + " order by createdtime desc limit 1" 
            
            cursor.execute(LAST_COLLECTION_DATE_QUERY)
            result = cursor.fetchone()
            
            formatedDate = datetime.fromtimestamp(result[0]/1000.0)
            
            print(formatedDate)
            return formatedDate
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
            
        finally:
            if connection:
                cursor.close()
                connection.close()

def getExpenseBillEntered(tenantId):
        # make db call to get the total no of expenses entered  in the give tenant on the current date
        #total till date not current date

        print("expense bill entered returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            TOTAL_NO_EXPENSES_TILL_DATE = "select count(*) from eg_echallan where tenantid = '"+tenantId+"'"
            
            cursor.execute(TOTAL_NO_EXPENSES_TILL_DATE)
            result = cursor.fetchone()
            print(result[0])
            return result[0]
        
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
        
        finally:
            if connection:
                cursor.close()
                connection.close()
        
def getLastExpTransactionDate(tenantId):
        # make db call to get the latest expense bill entered date in that given tenant
        print("expense transaction date")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            LAT_EXP_BILL_DATE = "select createdtime from eg_echallan where tenantid = '"+tenantId+"'" +" order by createdtime desc limit 1"
        
            cursor.execute(LAT_EXP_BILL_DATE)
            result = cursor.fetchone()
            formatedDate = datetime.fromtimestamp(result[0]/1000.0)
            print(formatedDate)
            return formatedDate
        
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
        
        finally:
            if connection:
                cursor.close()
                connection.close()


def getNoOfBillsPaid(tenantId):
        # make db call to get total no of expenses bills marked as paid till current date.
        print("No of bill paid")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            TOTAL_EXPENSES_BILL_MARKED_PAID = "select count(*) from eg_echallan where tenantid = '"+tenantId+"'"+" and applicationstatus = 'PAID' "
            
            cursor.execute(TOTAL_EXPENSES_BILL_MARKED_PAID)
            result = cursor.fetchone()
            print(result[0])
            return result[0]
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
            
        finally:
            if connection:
                cursor.close()
                connection.close()
                
def getTotalDemandRaised(tenantId):
        # make db call to get the total no of demand raised till date for ws   
        print("lat collection date returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            TOTAL_DEMANDS = "select count(*) from egbs_demand_v1 where businessservice = 'WS' and status = 'ACTIVE' and tenantid = '"+tenantId+"'" 
            
            cursor.execute(TOTAL_DEMANDS)
            result = cursor.fetchone()
            print(result[0])
            return result[0]
            
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
            
        finally:
            if connection:
                cursor.close()
                connection.close()

def createEntryForRollout(tenant, consumersCreated,countOfRateMaster, lastDemandGenratedDate,collectionsMade,collectionsMadeOnline,lastCollectionDate, expenseBillTillDate, lastExpTrnsDate, noOfBillpaid, noOfDemandRaised):
    # create entry into new table in postgres db with the table name roll_outdashboard . enter all field into the db and additional createdtime additional column
    
    print("inserting data into db")
    try:
        connection = getConnection()
        cursor = connection.cursor()
        
        createdTime = int(round(time.time() * 1000))
      
        postgres_insert_query = "INSERT INTO roll_out_dashboard (tenantid, projectcode, zone, circle, division, subdivision, section, consumer_created_count, billing_slab_count, last_demand_gen_date, collection_till_date, collection_till_date_online, last_collection_date, expense_count, last_expense_txn_date, paid_status_expense_bill_count, demands_till_date_count, createdtime) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        record_to_insert = (tenant['tenantId'], tenant['projectcode'], tenant['zone'], tenant['circle'], tenant['division'], tenant['subdivision'], tenant['section'], consumersCreated,countOfRateMaster, lastDemandGenratedDate,collectionsMade,collectionsMadeOnline,lastCollectionDate, expenseBillTillDate, lastExpTrnsDate, noOfBillpaid, noOfDemandRaised, createdTime)
        cursor.execute(postgres_insert_query, record_to_insert)
       
        connection.commit()
        return
    
    except (Exception, psycopg2.Error) as error:
            print("Exception occurred while connecting to the database")
            print(exception)
   
    finally:
            if connection:
                cursor.close()
                connection.close() 

def process():
    print("continue is the process")
    
    
    authToken = accessToken()
    
    try:
        connection = getConnection()
        cursor = connection.cursor()
        
        print("cursor: ",cursor)
       
        DROPPING_TABLE_QUERY = " drop table if exists roll_out_dashboard "
        cursor.execute(DROPPING_TABLE_QUERY)
        
        connection.commit()
        
        createTableQuery = createTable()
        cursor.execute(createTableQuery)
        
        connection.commit()
        
        print("table dropped")
    except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)
            
    finally:
        if connection:
            cursor.close()
            connection.close()
    
    tenants = getGPWSCHeirarchy(authToken)
    for tenant in tenants:
        print(tenant)
        consumersCreated = getConsumerCreated(tenant['tenantId'])
        countOfRateMaster = getRateMasters(tenant['tenantId'], authToken)
        lastDemandGenratedDate = getLastDemandDate(tenant['tenantId'])
        collectionsMade = getCollectionsMade(tenant['tenantId'])
        collectionsMadeOnline = getCollectionsMadeOnline(tenant['tenantId'])
        lastCollectionDate = getLastCollectionDate(tenant['tenantId'])
        expenseBillTillDate = getExpenseBillEntered(tenant['tenantId'])
        lastExpTrnsDate = getLastExpTransactionDate(tenant['tenantId'])
        noOfBillpaid= getNoOfBillsPaid(tenant['tenantId'])
        noOfDemandRaised= getTotalDemandRaised(tenant['tenantId'])
        createEntryForRollout(tenant, consumersCreated,countOfRateMaster, lastDemandGenratedDate,collectionsMade,collectionsMadeOnline,lastCollectionDate, expenseBillTillDate, lastExpTrnsDate, noOfBillpaid, noOfDemandRaised)
    print("End of rollout dashboard")
    return 

        
def getConnection():
    
    dbHost = os.getenv('DB_HOST')
    dbSchema =  os.getenv('DB_SCHEMA')
    dbUser =  os.getenv('DB_USER')
    dbPassword =  os.getenv('DB_PWD')
    dbPort =  os.getenv('DB_PORT')
    
    connection = psycopg2.connect(user=dbUser,
                            password=dbPassword,
                            host=dbHost,
                            port=dbPort,
                            database=dbSchema)
   
    return connection
    
def getCurrentDate():
    currentDate = datetime.today().strftime('%Y-%m-%d')
    currentDateInMillis = str(parser.parse(currentDate).timestamp() * 1000)
    
    return currentDateInMillis
    
def accessToken():
 
    
    try:
        query = {'username': os.getenv('TOKEN_USERNAME'),'password': os.getenv('TOKEN_PASSWORD'),'userType':'EMPLOYEE',"scope":"read","grant_type":"password"}
        query['tenantId']=os.getenv('TOKEN_TENANTID')
   
        response = requests.post( os.getenv('TOKEN_URL')+'user/oauth/token', data=query, headers={
        "Connection":"keep-alive","content-type":"application/x-www-form-urlencoded","Authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo="})
        
        jsondata = response.json()
        return jsondata.get('access_token')
    except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception)    
    
def createTable():
    
    CREATE_TABLE_QUERY = """create table roll_out_dashboard(
        id SERIAL primary key, 	
        tenantid varchar(250) NOT NULL,
        projectcode varchar(66),
        zone varchar(250),
        circle varchar(250),
        division varchar(250),
        subdivision varchar(250),
        section varchar(250),
        consumer_created_count NUMERIC(10),
        billing_slab_count NUMERIC(10),
        last_demand_gen_date DATE,
        collection_till_date NUMERIC(12, 2),
        collection_till_date_online NUMERIC(12,2),
        last_collection_date DATE,
        expense_count BIGINT,
        last_expense_txn_date Date,
        paid_status_expense_bill_count NUMERIC(10),
        demands_till_date_count NUMERIC(10),
        createdtime BIGINT NOT NULL
        )"""
    
    return CREATE_TABLE_QUERY
    
if __name__ == '__main__':
    process()