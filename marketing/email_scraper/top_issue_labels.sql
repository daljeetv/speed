
SELECT
    LOWER(JSON_EXTRACT_SCALAR(payload, '$.issue.labels[0].name')) as labels
  , count(1) count
FROM
  `githubarchive.day.201*` gd
WHERE 
  JSON_EXTRACT_SCALAR(payload, "$.action") = 'opened'
GROUP BY
  labels
ORDER BY count desc
