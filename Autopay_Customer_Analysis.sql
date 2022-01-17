-------Activation_Channel_Analysis- Customers who have opted for Autopay-----------------------------------------------------

WITH MODULE AS
(
SELECT 
a1.BRAND,a1.changedate,
a1.year,a1.CALENDARMONTHNAME MONTH_NAME,a1.CALENDARYEARMONTH,
a1.pLAN_CODE,a1.PLAN,MRC,
PAYMENT_TYPE,
CASE WHEN pay IN (8,9) THEN 'No_Cash' ELSE PayCategory END AS Pay_Flag
,a1.Activation_Channel_02 AS Channel_02,a1.Activation_Channel_03 AS Channel_03,a1.Activation_Channel_04 AS Channel_04,
 a1.store_code,a1.ACTIVATION_CHANNEL_CODE
,a1.CHANNEL_NEW2,a1.CHANNEL_New3,a1.TSR_ASM_DBM,STORE_MANAGER,a1.Store_Province, 
a1.Store_Region,a3.city AS Store_City,
CASE 
     WHEN a1.Store_Province IN('Ontario') AND store_city IN('Kanata','Ottawa') 
     AND Channel LIKE '%Walmar%' THEN 'Ottawa'
     WHEN a1.Store_Province IN('Ontario') OR A1.Store_Province IS NULL THEN 'East'
     WHEN a1.Store_Province IN('Alberta', 'BritishColumbia') THEN 'West'
END AS East_West
FROM Customers AS a1 
LEFT JOIN
    (SEL DISTINCT SERVICEnumber FROM Service_flag
     WHERE Trunc(EFF_END_DTTM) GT Current_Date
     ) AS A2 ON A1.SERVICENUMBER = A2.SERVICE_ID 
LEFT JOIN Store a3 ON a1.STORE_CODE = a3.store_code
WHERE A1.CHANGEDATE >= '2021-01-01'
) 
SEL BRAND,
CALENDARYEAR,MONTH_NAME,CALENDARYEARMONTH,RATE_PLAN_CODE,RATE_PLAN,MRC,
PAYMENT_TYPE,TAB_FLAG
,Channel_02,Channel_03, Channel_04,
 store_code,ACTIVATION_CHANNEL_CODE
,CHANNEL_NEW2,CHANNEL_New3,TSR_ASM_DBM,STORE_MANAGER,STORE_PROVINCE,Store_Region,
Store_City,East_West,AUTOPAY
,Sum(Activation) AS GA
,Sum(Total_pay) AS GA_pay
 FROM MODULE
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
-------------------------------------------------------------------------------------------------------------------
