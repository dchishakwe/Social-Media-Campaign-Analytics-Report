
--Joining Accounts and Account_Transactions tables
WITH
  accountsCTE AS (
  SELECT
    acc.id,
    acc.date_entered,
     COALESCE(acct.deposits,0) deposits,
    CASE
      WHEN REGEXP_EXTRACT(come_from_url_c, r'ad_id[=%]([^%]+)') IS NOT NULL 
      THEN upper(REGEXP_REPLACE(REGEXP_EXTRACT(come_from_url_c, r'ad_id[=%3D]([^%&]+)'),'253D',''))
      WHEN (come_from_url_c LIKE "%Facebook%" ) and (come_from_url_c LIKE "%merdekabonanza%")
      THEN "23850956487710409"
      ELSE upper(REGEXP_REPLACE(REGEXP_EXTRACT(come_from_url_c, r'utm_id[=%3D]([^%&]+)'),'253D',''))
    END AS ad_id --Adding ad_id for later use joing to FB_ADS table
  FROM
    `digital_tasks.account` acc
  LEFT OUTER JOIN
    `digital_tasks.account_transactions` acct
  ON
    acc.id = acct.id
  
  WHERE
    EXTRACT(date
    FROM
      date_entered) >= "2022-01-01" ) 

--Joining cte and FB_ADS table to establish relationship between campaign costs and deposits    
SELECT
  FORMAT_DATETIME("%Y-%m",EXTRACT(date
    FROM
      date_period)) year_month,
  campaign_name,
  round(sum(spend),0) cost,
  round(sum(deposits),0) deposit,
  CASE WHEN sum(spend)>0
  THEN round(((sum(deposits)-sum(spend))/sum(spend))* 100,1) 
  ELSE 0
  END AS ROI
 
FROM
  accountsCTE acc
JOIN
 `digital_tasks.fb_ads` ads
ON
  REGEXP_REPLACE(acc.ad_id,'3D','') = ads.ad_id
  or REGEXP_REPLACE(acc.ad_id,'3D','') = ads.adset_id
GROUP BY
  campaign_name, year_month
ORDER BY
  year_month,ROI desc
  --date_period