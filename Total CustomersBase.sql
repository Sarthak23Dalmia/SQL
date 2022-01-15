-----Customers with multiple accounts and different payment types
with Pilot AS
(
SELECT company, customerid,t2.CREATE_DT
,CASE WHEN  GETDATE - t2.CREATE_DT  < 366 THEN 'New Account' ELSE '1Year+ Account' END AS New_Existing_Acc
, Serve_Id,Pay
,Sum(account_flag) Over (PARTITION BY customerid) AS Total_line
,Sum(CASE WHEN payment_type = 'Card' THEN account_flag ELSE 0 end) 
Over (PARTITION BY customerid) AS Card_pay
,Sum(CASE WHEN payment_type = 'Cash' THEN active_flag ELSE 0 end)
Over (PARTITION BY customerid) AS Cash_pay
,CASE WHEN Total_line = 1 THEN 'Single Line Acc' ELSE 'Multi Acc' END AS Single_Multi,
CASE WHEN Total_line = 1 THEN '1 line'
     WHEN total_line = 2 THEN '2 lines'
     WHEN total_line = 3 THEN '3 lines'
     WHEN total_line = 4 THEN '4 lines'
     WHEN total_line >=5 THEN ' 5+ lines'
END AS line_grp,
CASE WHEN Card_pay = Total_line THEN 'Card_only' 
      WHEN Cash_pay = Total_line THEN 'Cash_only'
      ELSE 'Hybrid'
END AS Account_type
,CASE WHEN Total_line = 1 THEN 'Single_Line_Acc'
      WHEN Card_pay = Total_line THEN 'Card_only' 
      WHEN  Cash_pay= Total_line THEN 'Cash_only'
      ELSE 'Hybrid'
END AS Account_type_2
,account_flag
FROM account_Base t1
LEFT JOIN Customer_current t2 ON t1.customerid = t2.customerid
)

----------------------------------Lines Per account------------------------------------

Select account_type,line_grp,New_Existing_Acc,total_line,
Count(DISTINCT customerid ), Count(DISTINCT customerid) * total_line AS total_account
FROM Pilot
GROUP BY 1,2,3,4

-------------------------------------total customneraccounts----------------------------
SELECT company,New_Existing_Acc,Single_Multi,Total_line,line_grp,ACCOUNT_TYPE,Account_type_2
,Sum(active_flag) Sub_Ct
,Count(DISTINCT customerid) cx_Ct
FROM Pilot
GROUP BY 1,2,3,4,5,6,7
;
