--cte to add ad_id to the account table
WITH
  accountsCTE AS (
  SELECT
    *,
    CASE
      WHEN REGEXP_EXTRACT(come_from_url_c, r'ad_id[=%3D]([^%]+)') IS NOT NULL 
      THEN REGEXP_REPLACE(REGEXP_EXTRACT(come_from_url_c, r'ad_id[=%3D]([^%&]+)'),'3D','')
      ELSE REGEXP_REPLACE(REGEXP_EXTRACT(come_from_url_c, r'utm_id[=%3D]([^%&]+)'),'3D','')
    END AS ad_id --Extracting ad_id from come_from_url_c url
  FROM
    `digital_tasks.account`
  WHERE
    EXTRACT(date
    FROM
      date_entered) BETWEEN "2022-08-01"
    AND "2022-10-31" ) --Limiting resultset to dates between 2022-08-01 AND 2022-10-31 

  --Calculating average cost per registration for last quarter (from Aug 2022 – Oct 2022) 

    SELECT
      campaign_name,
      round(sum(spend),2) campaign_spend,
      count(*) total_registrations,
      round(sum(spend) / count(*),2) avg_cost_per_registration
    FROM
      accountsCTE acc
    JOIN
      `digital_tasks.fb_ads` ads
    ON
      acc.ad_id = ads.ad_id
    GROUP BY 
      campaign_name,acc.ad_id
    ORDER BY
      avg_cost_per_registration