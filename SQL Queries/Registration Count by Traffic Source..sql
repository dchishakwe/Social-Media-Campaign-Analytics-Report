SELECT
  REGEXP_REPLACE(REGEXP_REPLACE(UPPER(REGEXP_EXTRACT(come_from_url_c, r'utm_source[=%3D]([^%&]+)')),'3D',''),'25','') source, -- Extracting traffic sources from come_from_url_c column
  REGEXP_REPLACE(REGEXP_REPLACE(UPPER(REGEXP_EXTRACT(come_from_url_c, r'utm_medium[=%3D]([^%&]+)')),'3D',''),'25','') medium,
  COUNT(*) totals                                                                                                             --Aggregating registrations 
FROM
  `digital_tasks.account`
WHERE
  EXTRACT(date from date_entered) BETWEEN "2022-08-01" and  "2022-10-31"                                                      --Filtering for registrations between Aug 2022 and Oct 2022 
GROUP BY                                                                                                                      --Grouping registrations by source
  source, medium
ORDER BY
  totals DESC 