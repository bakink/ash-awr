--http://dualtable.ru/how-to-know-top-sql-from-last-hour
SELECT activity_pct percent, db_time, h.sql_id, sq.SQL_TEXT
  FROM (SELECT round(100 * ratio_to_report(count(*)) OVER(), 1) AS activity_pct,
               count(*) AS db_time,
               sql_id
          FROM v$active_session_history
          WHERE sample_time BETWEEN sysdate - 1/24 AND sysdate
           AND sql_id IS NOT NULL
         GROUP BY sql_id
         ORDER BY count(*) DESC) h ,
         v$sql sq
         where h.sql_id=sq.sql_id(+)

-- top SQL of a session
  SELECT sql_id, COUNT (*)
    FROM gv$active_session_history
   WHERE inst_id = 2 AND session_id = 249 AND session_serial# = 24899
GROUP BY sql_id
ORDER BY 2 DESC
