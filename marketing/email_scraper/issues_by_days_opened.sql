SELECT
    DATE_DIFF(CURRENT_DATE(), DATE(created_at), DAY) as days_outstanding
    , count(1) count
  FROM
  `githubarchive.day.201*` gd
WHERE JSON_EXTRACT_SCALAR(payload, "$.action") = 'opened'
GROUP BY days_outstanding
order by days_outstanding asc
