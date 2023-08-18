from typing import BinaryIO, List
import requests
from datetime import datetime, timezone,time,timedelta
from dateutil.relativedelta import relativedelta
from dateutil import tz
import pytz
from dateutil import parser
import os
import psycopg2

def getGPWSCHeirarchy():

        # call the projectmodule mdms for each unique tenant which would return the array of unique villages( i.e tenantid) along with the respectie
        # zone circle division subdivision project 
        # https://realpython.com/python-requests/ helps on how make ajax calls. url put it in app.properties and read through configs
        
    try:
        mdms_url = os.getenv('API_URL')
        state_tenantid = os.getenv('TENANT_ID')
        mdms_requestData = {
            "RequestInfo": {
                "apiId": "mgramseva-common",
                "ver": 0.01,
                "ts": "",
                "action": "_search",
                "did": 1,
                "key": "",
                "msgId": ""
            },
            "MdmsCriteria": {
                "tenantId": state_tenantid,
                "moduleDetails": [
                    {
                        "moduleName": "tenant",
                        "masterDetails": [
                            {
                                "name": "tenants"
                            }
                        ]
                    }
                ]
            }
        }

        mdms_response = requests.post(mdms_url + 'egov-mdms-service/v1/_search', json=mdms_requestData,verify=False)

        mdms_responseData = mdms_response.json()
        tenantList = mdms_responseData['MdmsRes']['tenant']['tenants']
        print(len(tenantList))
        teanant_data_Map = {}
        for tenant in tenantList:
            if tenant.get('code') == state_tenantid or tenant.get('code') == (state_tenantid + '.testing'):
                continue
            if tenant.get('city') is not None and tenant.get('city').get('code') is not None:
                teanant_data_Map.update({tenant.get('city').get('code'): tenant.get('code')})

        url = 'https://mgramseva-dwss.punjab.gov.in/'
        print(url)
        requestData = {
            "requestHeader": {
                "ts": 1627193067,
                "version": "2.0.0",
                "msgId": "Unknown",
                "signature": "NON",
                "userInfo": {
                    "uuid": "admin"
                }
            },
            "criteria": {
                "tenantId": "pb",
                "getAncestry": True
            }
        }

        response = requests.post(url + 'ifix-department-entity/departmentEntity/v1/_search', json=requestData, verify=False)

        responseData = response.json()
        departmentHierarchyList = responseData.get('departmentEntity')
        dataList = []

        for data in departmentHierarchyList:
            if (len(data['children']) > 0):
                if (data.get('hierarchyLevel') == 0):
                    child = data['children'][0]
                else:
                    child = data
                zone = child.get('name')
                if (len(child['children']) > 0):
                    circle = child['children'][0].get('name')
                    if (len(child['children'][0]['children']) > 0):
                        division = child['children'][0]['children'][0].get('name')
                        if (len(child['children'][0]['children'][0]['children']) > 0):
                            subdivision = child['children'][0]['children'][0]['children'][0].get('name')
                            if (len(child['children'][0]['children'][0]['children'][0]['children']) > 0):
                                section = child['children'][0]['children'][0]['children'][0]['children'][0].get('name')
                                if (len(child['children'][0]['children'][0]['children'][0]['children'][0]['children']) > 0):
                                    tenantName = \
                                    child['children'][0]['children'][0]['children'][0]['children'][0]['children'][0].get(
                                        'name')
                                    tenantCode = \
                                    child['children'][0]['children'][0]['children'][0]['children'][0]['children'][0].get(
                                        'code')
                                    # tenantId = tenantName.replace(" ", "").lower()
                                    if teanant_data_Map.get(tenantCode) is not None:
                                        formatedTenantId = teanant_data_Map.get(tenantCode)
                                        print(formatedTenantId)
                                        obj1 = {"tenantId": formatedTenantId, "zone": zone, "circle": circle,
                                                "division": division, "subdivision": subdivision,
                                                "section": section, "projectcode": tenantCode}
                                        dataList.append(obj1)
        print("heirarchy collected")
        return (dataList)
    except Exception as exception:
                print("Exception occurred while connecting to the database")
                print(exception)
                

def getRateMasters(tenantId):
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
                    "msgId": ""
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
       

def getRatingCount(tenantId):
        # make db call to get the total no of ratings   
        print("no of ratings")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            TOTAL_RATINGS = "select count(*) from eg_ws_feedback where tenantid = '"+tenantId+"'" 
            
            cursor.execute(TOTAL_RATINGS)
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
                
def getLastRatingDate(tenantId):
        # make db call to get the last rating date entered date in that given tenant
        print("last rating date geiven")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            LAST_RATING_DATE = "select createdtime from eg_ws_feedback where tenantid = '"+tenantId+"'" +" order by createdtime desc limit 1"
        
            cursor.execute(LAST_RATING_DATE)
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
                
def getActiveUsersCount(tenantId):
        # make db call to get the total no of active users(EMPLOYEE)   
        print("no of active users")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            NO_OF_ACTIVE_USERS = "select count(distinct ur.user_id) from eg_user u inner join eg_userrole_v1 ur on u.id = ur.user_id where u.active = 't' and u.type='EMPLOYEE' and ur.role_tenantid = '"+tenantId+"'" 
            
            cursor.execute(NO_OF_ACTIVE_USERS)
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
           
def getTotalAdvanceCreated(tenantId):
        # query the postgresql db to get the total count of total advance in the given tenant till date  
        print("advance sum returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
             
            ADVANCE_COUNT_QUERY = "select sum(dd.taxamount) from egbs_demanddetail_v1 dd inner join egbs_demand_v1 d on dd.demandid = d.id where d.status = 'ACTIVE' and dd.taxheadcode='WS_ADVANCE_CARRYFORWARD' and dd.tenantid = '"+tenantId+"'"
            cursor.execute(ADVANCE_COUNT_QUERY)
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
                
                
def getTotalPenaltyCreated(tenantId):
        # query the postgresql db to get the total count of total penalty in the given tenant till date  
        print("penalty sum returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
             
            PENALTY_COUNT_QUERY = "select sum(dd.taxamount) from egbs_demanddetail_v1 dd inner join egbs_demand_v1 d on dd.demandid = d.id where d.status = 'ACTIVE' and dd.taxheadcode='WS_TIME_PENALTY' and dd.tenantid = '"+tenantId+"'"
            cursor.execute(PENALTY_COUNT_QUERY)
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
                
def getTotalConsumersCreatedForLastSevenDays(tenantId):
        # query the postgresql db to get the total count of total consumers created for last 7 days  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            
            now = datetime.now()
            lastSevenDays = (now - timedelta(days=7)).replace(hour=0,minute=0,second=0, microsecond=0)
            epochnow = now.strftime('%s') + '000'
            epochlast7days = lastSevenDays.strftime('%s') + '000'
            
            CONSUMER_COUNT_QUERY_7_DAYS = "select count(*) from eg_ws_connection where status = 'Active' and createdtime between '"+epochlast7days+"'"+" and '"+epochnow+"'"+" and tenantid = '"+tenantId+"'"
            cursor.execute(CONSUMER_COUNT_QUERY_7_DAYS)
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
                
def getTotalConsumersCreatedForLastFifteenDays(tenantId):
        # query the postgresql db to get the total count of total consumers created for last 15 days  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            
            now = datetime.now()
            lastFifteenDays = (now - timedelta(days=15)).replace(hour=0,minute=0,second=0, microsecond=0)
            epochnow = now.strftime('%s') + '000'
            epochlast15days = lastFifteenDays.strftime('%s') + '000'
            
            CONSUMER_COUNT_QUERY_15_DAYS = "select count(*) from eg_ws_connection where status = 'Active' and createdtime between '"+epochlast15days+"'"+" and '"+epochnow+"'"+" and tenantid = '"+tenantId+"'"
            cursor.execute(CONSUMER_COUNT_QUERY_15_DAYS)
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
                
def getTotalConsumersCreatedForLastOneMonth(tenantId):
        # query the postgresql db to get the total count of total consumers created for last one month  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            today = datetime.now().year
            lastonemonth = (datetime.now() - relativedelta(months=1)).month
            start_date = datetime(today, lastonemonth, 1)
            end_date = datetime(today, lastonemonth + 1, 1) + timedelta(days=-1)
            enddate = end_date.combine(end_date,time.max)
            epochnow = start_date.strftime('%s') + '000'
            epochlastonemonth = enddate.strftime('%s') + '000'
            
            CONSUMER_COUNT_QUERY_1_MONTH = "select count(*) from eg_ws_connection where status = 'Active' and createdtime between '"+epochnow+"'"+" and '"+epochlastonemonth+"'"+" and tenantid = '"+tenantId+"'"
            cursor.execute(CONSUMER_COUNT_QUERY_1_MONTH)
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
                
def getTotalConsumersCreatedForLastQuarterOne(tenantId):
        # query the postgresql db to get the total count of total consumers created for last quarter 1  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            
            year = datetime.now().year
            start_date = datetime(year, 4, 1)
            end_date = datetime(year, 6, 30)
            end = datetime.combine(end_date,time.max)
            epochnow = start_date.strftime('%s') + '000'
            lastepoch = end.strftime('%s') + '000'
            
            CONSUMER_COUNT_QUERY_QUARTER_1 = "select count(*) from eg_ws_connection where status = 'Active' and createdtime between '"+epochnow+"'"+" and '"+lastepoch+"'"+" and tenantid = '"+tenantId+"'"
            print(CONSUMER_COUNT_QUERY_QUARTER_1)
            cursor.execute(CONSUMER_COUNT_QUERY_QUARTER_1)
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
                
def getTotalConsumersCreatedForLastQuarterTwo(tenantId):
        # query the postgresql db to get the total count of total consumers created for last quarter 2  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            
            year = datetime.now().year
            start_date = datetime(year, 7, 1)
            end_date = datetime(year, 9, 30)
            end = datetime.combine(end_date,time.max)
            epochnow = start_date.strftime('%s') + '000'
            lastepoch = end.strftime('%s') + '000'
            
            CONSUMER_COUNT_QUERY_QUARTER_2 = "select count(*) from eg_ws_connection where status = 'Active' and createdtime between '"+epochnow+"'"+" and '"+lastepoch+"'"+" and tenantid = '"+tenantId+"'"
            print(CONSUMER_COUNT_QUERY_QUARTER_2)
            cursor.execute(CONSUMER_COUNT_QUERY_QUARTER_2)
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
                
                
def getTotalConsumersCreatedForLastQuarterThree(tenantId):
        # query the postgresql db to get the total count of total consumers created for last quarter 3  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            
            year = datetime.now().year
            start_date = datetime(year, 10, 1)
            end_date = datetime(year, 12, 31)
            end = datetime.combine(end_date,time.max)
            epochnow = start_date.strftime('%s') + '000'
            lastepoch = end.strftime('%s') + '000'
            
            CONSUMER_COUNT_QUERY_QUARTER_3 = "select count(*) from eg_ws_connection where status = 'Active' and createdtime between '"+epochnow+"'"+" and '"+lastepoch+"'"+" and tenantid = '"+tenantId+"'"
            print(CONSUMER_COUNT_QUERY_QUARTER_3)
            cursor.execute(CONSUMER_COUNT_QUERY_QUARTER_3)
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
                
                
def getTotalConsumersCreatedForLastQuarterFour(tenantId):
        # query the postgresql db to get the total count of total consumers created for last quarter 4  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            
            year = datetime.now().year
            start_date = datetime(year, 1, 1)
            end_date = datetime(year, 3, 31)
            end = datetime.combine(end_date,time.max)
            epochnow = start_date.strftime('%s') + '000'
            lastepoch = end.strftime('%s') + '000'
            
            CONSUMER_COUNT_QUERY_QUARTER_4 = "select count(*) from eg_ws_connection where status = 'Active' and createdtime between '"+epochnow+"'"+" and '"+lastepoch+"'"+" and tenantid = '"+tenantId+"'"
            print(CONSUMER_COUNT_QUERY_QUARTER_4)
            cursor.execute(CONSUMER_COUNT_QUERY_QUARTER_4)
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

def getLastDemandDate(tenantId):
    # make db call to get the last demand generated date for the given tenant
        print("last demand date returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            
            LAST_DEMAND_DATE = "select max(to_timestamp(taxperiodto/1000)::date) from eg_ws_connection conn left outer join egbs_demand_v1 dmd on dmd.consumercode=conn.connectionno and dmd.status='ACTIVE'                                                                                                                                            left outer join egbs_demanddetail_v1 dtl on dtl.demandid=dmd.id and taxheadcode='10101' where dtl.id is not null and conn.status='Active'and businessservice='WS' and (EXTRACT(epoch FROM (to_timestamp(taxperiodto/1000))-to_timestamp(taxperiodfrom/1000)))::int/86400<=31 and dmd.tenantid = '"+tenantId+"'"
            cursor.execute(LAST_DEMAND_DATE)
            result = cursor.fetchone()
            
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
        print("last demand date returned")
        try:
            connection = getConnection()
            cursor = connection.cursor()
            
            
            LAST_DEMAND_COUNT = "select count(distinct dmd.consumercode) from eg_ws_connection conn left outer join egbs_demand_v1 dmd on dmd.consumercode=conn.connectionno and dmd.status='ACTIVE'                                                                                                                                            left outer join egbs_demanddetail_v1 dtl on dtl.demandid=dmd.id and taxheadcode='10101' where conn.status='Active'and businessservice='WS' and (EXTRACT(epoch FROM (to_timestamp(taxperiodto/1000))-to_timestamp(taxperiodfrom/1000)))::int/86400<=31 and dmd.tenantid = '"+tenantId+"'"
            cursor.execute(LAST_DEMAND_COUNT)
            result = cursor.fetchone()
            
            return result[0]
            
        except Exception as exception:
            print("Exception occurred while connecting to the database")
            print(exception) 
        
        finally:
            if connection:
                cursor.close()
                connection.close()
                
                          
def getTotalConsumersCount(tenantId):
        # query the postgresql db to get the total count of total consumers created  
        print("consumer count returned")
        try:                          
            connection = getConnection()
            cursor = connection.cursor()
            
            CONSUMER_TOTAL_COUNT_QUERY = "select count(*) from eg_ws_connection where status = 'Active' and tenantid = '"+tenantId+"'"
            cursor.execute(CONSUMER_TOTAL_COUNT_QUERY)
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
                
                
def createEntryForRollout(tenant,countOfRateMaster,collectionsMade,collectionsMadeOnline,lastCollectionDate, expenseBillTillDate, lastExpTrnsDate, noOfBillpaid, noOfRatings, lastRatingDate, activeUsersCount,totalAdvance,totalPenalty,consumerCountlastSevenDays,consumerCountlastFifteenDays,consumerCountlastOneMonth,consumerCountquarterOne,
        consumerCountquarterTwo,consumerCountquarterThree,consumerCountquarterFour,lastDemandGenratedDate,noOfDemandRaised,totalConsumerCount):
    # create entry into new table in postgres db with the table name roll_outdashboard . enter all field into the db and additional createdtime additional column
    
    print("inserting data into db")
    try:
        connection = getConnection()
        cursor = connection.cursor()
        
        #createdTime = int(round(time.time() * 1000)) // time in currenttimemillis format   
        
        tzInfo = pytz.timezone('Asia/Kolkata')
        createdTime = datetime.now(tz=tzInfo)
        print("createdtime -->", createdTime)
        
        postgres_insert_query = "INSERT INTO roll_out_dashboard (tenantid, projectcode, zone, circle, division, subdivision, section,billing_slab_count, collection_till_date, collection_till_date_online, last_collection_date, expense_count,last_expense_txn_date,paid_status_expense_bill_count,ratings_count,last_rating_date,active_users_count,total_advance,total_penalty,consumer_count_last_seven_days,consumer_count_last_fifteen_days,consumer_count_last_one_month,consumer_count_quarter_one,consumer_count_quarter_two,consumer_count_quarter_three,consumer_count_quarter_four,last_demand_gen_date,last_demand_gen_count,total_consumer_count, createdtime) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        record_to_insert = (tenant['tenantId'], tenant['projectcode'], tenant['zone'], tenant['circle'], tenant['division'], tenant['subdivision'], tenant['section'],countOfRateMaster,collectionsMade,collectionsMadeOnline,lastCollectionDate, expenseBillTillDate, lastExpTrnsDate, noOfBillpaid, noOfRatings, lastRatingDate, activeUsersCount,totalAdvance, totalPenalty,consumerCountlastSevenDays,consumerCountlastFifteenDays,consumerCountlastOneMonth,consumerCountquarterOne,consumerCountquarterTwo,consumerCountquarterThree,consumerCountquarterFour,lastDemandGenratedDate,noOfDemandRaised,totalConsumerCount, createdTime)
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
    
    tenants = getGPWSCHeirarchy()
    for tenant in tenants:
        print(tenant)
        countOfRateMaster = getRateMasters(tenant['tenantId'])
        lastDemandGenratedDate = getLastDemandDate(tenant['tenantId'])
        collectionsMade = getCollectionsMade(tenant['tenantId'])
        collectionsMadeOnline = getCollectionsMadeOnline(tenant['tenantId'])
        lastCollectionDate = getLastCollectionDate(tenant['tenantId'])
        expenseBillTillDate = getExpenseBillEntered(tenant['tenantId'])
        lastExpTrnsDate = getLastExpTransactionDate(tenant['tenantId'])
        noOfBillpaid= getNoOfBillsPaid(tenant['tenantId'])
        noOfDemandRaised= getTotalDemandRaised(tenant['tenantId'])
        noOfRatings = getRatingCount(tenant['tenantId'])
        lastRatingDate= getLastRatingDate(tenant['tenantId'])
        activeUsersCount= getActiveUsersCount(tenant['tenantId'])
        totalAdvance= getTotalAdvanceCreated(tenant['tenantId'])
        totalPenalty= getTotalPenaltyCreated(tenant['tenantId'])
        consumerCountlastSevenDays= getTotalConsumersCreatedForLastSevenDays(tenant['tenantId'])
        consumerCountlastFifteenDays= getTotalConsumersCreatedForLastFifteenDays(tenant['tenantId'])
        consumerCountlastOneMonth= getTotalConsumersCreatedForLastOneMonth(tenant['tenantId'])
        consumerCountquarterOne= getTotalConsumersCreatedForLastQuarterOne(tenant['tenantId'])
        consumerCountquarterTwo= getTotalConsumersCreatedForLastQuarterTwo(tenant['tenantId'])
        consumerCountquarterThree= getTotalConsumersCreatedForLastQuarterThree(tenant['tenantId'])
        consumerCountquarterFour= getTotalConsumersCreatedForLastQuarterFour(tenant['tenantId'])
        totalConsumerCount= getTotalConsumersCount(tenant['tenantId'])
        createEntryForRollout(tenant,countOfRateMaster,collectionsMade,collectionsMadeOnline,lastCollectionDate, expenseBillTillDate, lastExpTrnsDate, noOfBillpaid, noOfRatings, lastRatingDate, activeUsersCount,totalAdvance, totalPenalty,consumerCountlastSevenDays,consumerCountlastFifteenDays,consumerCountlastOneMonth,consumerCountquarterOne,
        consumerCountquarterTwo,consumerCountquarterThree,consumerCountquarterFour,lastDemandGenratedDate,noOfDemandRaised,totalConsumerCount)
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
        billing_slab_count NUMERIC(10),
        collection_till_date NUMERIC(12, 2),
        collection_till_date_online NUMERIC(12,2),
        last_collection_date DATE,
        expense_count BIGINT,
        last_expense_txn_date Date,
        paid_status_expense_bill_count NUMERIC(10),
        ratings_count NUMERIC(10),
        last_rating_date DATE,
        active_users_count NUMERIC(10),
        total_advance NUMERIC(10),
        total_penalty NUMERIC(10),
        consumer_count_last_seven_days NUMERIC(10),
        consumer_count_last_fifteen_days NUMERIC(10),
        consumer_count_last_one_month NUMERIC(10),
        consumer_count_quarter_one NUMERIC(10),
        consumer_count_quarter_two NUMERIC(10),
        consumer_count_quarter_three NUMERIC(10),
        consumer_count_quarter_four NUMERIC(10),
        last_demand_gen_date DATE,
        last_demand_gen_count NUMERIC(10),
        total_consumer_count NUMERIC(10),
        createdtime TIMESTAMP NOT NULL
        )"""
    
    return CREATE_TABLE_QUERY
    
if __name__ == '__main__':
    process()
