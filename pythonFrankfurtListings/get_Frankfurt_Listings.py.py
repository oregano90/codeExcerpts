# -*- coding: utf-8 -*-
"""
Created on Tue Oct 18 17:00:35 2016

@author: Gero Steigerwald
"""

import csv 
import requests
import time
from pandas.tseries.offsets import BDay
import pandas as pd
import re
import pandas_datareader.data as web    
import datetime


#daily FFM
Xetra_URL_1 = "http://www.deutsche-boerse-cash-market.com/blob/1424940/172c8d65af4cb25e58cb96132ed5ba8a/data/allTradableInstruments.csv"

res = requests.get(Xetra_URL_1) # download csv from URL
res.status_code == requests.codes.ok    # check if dowload was successfull

try:
    res.raise_for_status()
except Exception as exc:
    print('There was a problem: %s' % (exc))    # if download was not successfull raise this message
    
saveFile = open('DeutscheBoerseAllInstr-%s.csv' % (time.strftime("%Y%m%d")), 'wb')  # save whole downloaded file
for chunk in res.iter_content(100000):
        saveFile.write(chunk)
        
df_ins=pd.DataFrame.from_csv('DeutscheBoerseAllInstr-%s.csv' % (time.strftime("%Y%m%d")), header=4,sep=';')  # read in file as dataframe
df_ins.columns = [x.strip() for x in df_ins.columns.tolist()]         # remove leading and trailing white spaces from column names

df_ins=df_ins.reset_index()      # reset index to not loose the date

df_ins=df_ins[df_ins['MIC Code']=='XETR']              # only keep stocks that are traded on XETRA
df_ins=df_ins[df_ins['Instrument Type']=='Equity']     # and specified as equity

df_ins=df_ins[['Instrument','ISIN','WKN','Mnemonic','MIC Code','Date Last Update','Instrument Group Description','Closing Price Previous Business Day','Market Segment','Primary Market MIC Code','Settlement Currency']]

df_ins=df_ins.set_index(["Instrument Group Description"],drop=True)    # now set the new index to the group description to be able to easily drop some entries in the next step
df_ins=df_ins.drop(["EQUITIES FFM2","BSE - EQUITIES","BSE - REITS","BSE - COMPENSATORY INSTRUMENTS","BSE - UNLEVERAGED ETP","FONDS FFM2","EXCHANGE TRADED FUNDS - AKTIV","NEWEX","FFM-ETF-CURRENCY USD","FFM-ETF-CURRENCY-CNY","FFM - ETR RENTEN - CURRENCY USD","FFM-ETF-CURRENCY GBP","FFM-ETF-CURRENCY CHF/SEK"])
df_ins=df_ins[['Instrument','ISIN','WKN','Mnemonic','MIC Code','Date Last Update','Closing Price Previous Business Day','Market Segment','Primary Market MIC Code','Settlement Currency']] # rearrange

df_ins = df_ins.sort_values(by=['Instrument'])
df_ins=df_ins.reset_index()      # reset index to not loose the date

df_ins['Closing Price Previous Business Day']=pd.to_numeric(df_ins['Closing Price Previous Business Day'], errors='coerce')   # transform closing price to numeric format

for col in df_ins.select_dtypes(include=['object']).columns.tolist():         # remove leading and trailing as well as multiple whitespaces for all columns with strings
    try:    # try because it could not be filtered for string only columns
        df_ins[col] = df_ins[col].map(lambda x: " ".join(x.split()))  # remove multiple whitespaces
        df_ins[col] = df_ins[col].map(lambda x: x.strip())    # remove leading and trailing whitespaces
    except Exception:   # pass exception, as the exception is only raised for non-string-columns
        pass
    
 

#### add a new column that indicates different types of stocks ####
#### use regex to filter for the strings ####
    instLi = df_ins["Instrument"].tolist()   
    instGr = df_ins["Instrument Group Description"].tolist()   
    
    stockTypeLi =[]
    
    for ins in instLi:
        searchObj1 = re.search( r'[\s(\./]ADRS?([)\d\./]|$)', ins, re.M|re.I)
        searchObj2 = re.search( r'[(\./]ADRS?([)\s\d\./]|$)', ins, re.M|re.I)
        searchObj3 = re.search( r' ADRS?( |$)', ins, re.M|re.I)
        if searchObj1 or searchObj2 or searchObj3:
            stockTypeLi.append('ADR') 
            print(ins)
        else:
            stockTypeLi.append('')
    
    for idx, ins in enumerate(instLi):
        searchObj1 = re.search( r'[\s(\./]NEU([)\d\./]|$)', ins, re.M|re.I)
        searchObj2 = re.search( r'[(\./]NEU([)\s\d\./]|$)', ins, re.M|re.I)
        searchObj3 = re.search( r' NEUE( |$)', ins, re.M|re.I)
        if searchObj1 or searchObj2 or searchObj3:
            if stockTypeLi[idx]!="":
                stockTypeLi[idx]=stockTypeLi[idx]+'+'+'NEW' 
            else:
                stockTypeLi[idx]='NEW' 
            print(ins)
    
    for idx, ins in enumerate(instLi):
        searchObj1 = re.search( r'[\s(\./]VZO?([)\d\./]|$)', ins, re.M|re.I)
        searchObj2 = re.search( r'[(\./]VZO?([)\s\d\./]|$)', ins, re.M|re.I)
        searchObj3 = re.search( r' VZO?( |$)', ins, re.M|re.I)
        if searchObj1 or searchObj2 or searchObj3:
            if stockTypeLi[idx]!="":
                stockTypeLi[idx]=stockTypeLi[idx]+'+'+'PREF' 
            else:
                stockTypeLi[idx]='PREF' 
            print(ins)
            
    for idx, ins in enumerate(instLi):
        searchObj1 = re.search( r'[\s(\./]Z.UMT([)\d\./]|$)', ins, re.M|re.I)
        searchObj2 = re.search( r'[(\./]Z.UMT([)\s\d\./]|$)', ins, re.M|re.I)
        searchObj3 = re.search( r' Z.UMT( |$)', ins, re.M|re.I)
        if searchObj1 or searchObj2 or searchObj3:
            if stockTypeLi[idx]!="":
                stockTypeLi[idx]=stockTypeLi[idx]+'+'+'FOR_EXCH' 
            else:
                stockTypeLi[idx]='FOR_EXCH' 
            print(ins)

InstTypeLi = []     # is instrument a stock, ETF, or some other instrument type?
MembOfInd = []      # is the stock a member of an index?
Region = []         # what is the region the company belongs to?
for idx, ins in enumerate(instGr):      # create columns with types of instruments and region
    if ins=='EXCHANGE TRADED COMMODITIES':
        InstTypeLi.append('ETC')
        MembOfInd.append('')
        Region.append('')
    elif ins=='EXCHANGE TRADED FUNDS - PASSIV':
        InstTypeLi.append('ETF_STX')    # stocks ETFs
        MembOfInd.append('')
        Region.append('')
    elif ins=='EXCHANGE TRADED FUNDS - RENTEN':
        InstTypeLi.append('ETF_BND')    # bond ETFs
        MembOfInd.append('')
        Region.append('')
    elif ins=='EXCHANGE TRADED NOTES':
        InstTypeLi.append('ETN')    # Exchange Traded Notes
        MembOfInd.append('')
        Region.append('')
    elif ins=='DAX' or ins=='SDAX' or ins=='MDAX' or ins=='TECDAX' or ins=='STOXX 600 REST':    # does the COMPANY belong to an index?
        InstTypeLi.append('S')
        MembOfInd.append(ins)
        Region.append('DEUTSCHLAND')
    else:
        InstTypeLi.append('S')  # left with regions only
        MembOfInd.append('')
        Region.append(ins)

for idx, stockType in enumerate(stockTypeLi):       # in the end all other stocks are standard stocks
    if stockTypeLi[idx]=="" and InstTypeLi[idx]=="S":
        stockTypeLi[idx]='ST' 


            
df_ins['Stock Type'] = pd.Series(stockTypeLi, index=df_ins.index)
df_ins['Instrument Type'] = pd.Series(InstTypeLi, index=df_ins.index)
df_ins['Region'] = pd.Series(Region, index=df_ins.index)
df_ins['Index Member Of Company'] = pd.Series(MembOfInd, index=df_ins.index)
    
    
    
#df_ins.drop(["Instrument Type","Instrument Sub Type"], axis=1, inplace=True)

df_ins.to_csv('DeutscheBoerseReduced-%s.csv' % (time.strftime("%Y%m%d")))


### download prices from yahoo ###

tickerLi = df_ins["Mnemonic"].tolist() 
df_found = df_ins[['Date Last Update','Instrument','ISIN','WKN','Mnemonic']]  # create a dataframe that stores whether the ticker was found or not. Temporarily fill it with more data and later save it to a database table.
df_found['Source'] = 'NA'
notFoundTickerIdx = []


# historic adjusted

#start = datetime.date(1990, 1, 1)
#end = datetime.date.today()
#df_adjPr = pd.DataFrame(columns={'Date','Adj Close','Ticker'})
#for idx,ticker in enumerate(tickerLi):
#    print(str(idx))#print(str(idx) + ' ' + ticker)
#    try:
#        df_temp = web.DataReader(ticker + '.F', 'yahoo', start, end)
#        df_temp['Ticker'] = ticker
#        df_temp = df_temp.reset_index()
#        df_temp = df_temp[['Date','Adj Close','Ticker']]
#        
#        df_found.loc[idx,"Source"] = "YH"
#    
#        df_adjPr = pd.concat([df_adjPr, df_temp], ignore_index=True)
#    except Exception:       #tickers that are not found
#        notFoundTickerIdx.append(idx)
#        print('#####################')
#        print(ticker)
#        print('#####################')

# df_adjPr.to_csv('AdjustedPrices-%s.csv' % (time.strftime("%Y%m%d")))
        

## going forward
        
end = datetime.date.today()
start = end - BDay(1)
df_adjPr = pd.DataFrame(columns={'Date','Adj Close','Ticker'})
for idx,ticker in enumerate(tickerLi):
    print(str(idx))     #print(str(idx) + ' ' + ticker)
    try:
        df_temp = web.DataReader(ticker + '.F', 'yahoo', start, start)
        df_temp['Ticker'] = ticker
        df_temp = df_temp.reset_index()
        df_temp = df_temp[['Date','Adj Close','Ticker']]
        
        df_found.loc[idx,"Source"] = "YH"
    
        df_adjPr = pd.concat([df_adjPr, df_temp], ignore_index=True)
    except Exception:       #tickers that are not found
        notFoundTickerIdx.append(idx)
        print('#####################')
        print(ticker)
        print('#####################')
        
        
        









#XetraListingsStr=res.text
#XetraListingsStr=XetraListingsStr.replace(";",",")

#
#http://www.deutsche-boerse-cash-market.com/blob/1331170/3df5a5d3afd979bdda7a3917a0d7a42d/data/xffm2_instruments.zip
#
#daily NASDAQ
#http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nasdaq&render=download
#http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nyse&render=download
#FTP: ftp.nasdaqtrader.com
#
#
#monthly LSE
#http://www.lseg.com/sites/default/files/content/documents/ETFs%20%26%20ETPs%20Monthly%20Trading%20Data%20by%20Security%20September%202016.xlsx
#
#weekly LSE
#http://www.lseg.com/sites/default/files/content/documents/10.10.16%20ETFs%20%26%20ETPs.xls
#
#map tickers to ISINs
#https://www.openfigi.com/api