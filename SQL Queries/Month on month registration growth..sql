SELECT

  FORMAT_DATETIME("%m",EXTRACT(date FROM date_entered)) month, --Extract month from date_entered 
  FORMAT_DATETIME("%Y",EXTRACT(date FROM date_entered)) year,  --Extract year from date_entered   
  COUNT(*) total_registrations                                 --Aggregating number of registrations

FROM
  digital_tasks.account

GROUP BY
   year
  ,month 
                                                               --Registrations grouped by month and year
ORDER BY
  year
  ,month;