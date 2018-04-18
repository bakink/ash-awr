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

--Returns most active SQL in the past minute
select sql_id, count(*),
round(count(*)
/sum(count(*)) over (), 2) pctload
from v$active_session_history
where sample_time > sysdate -
1/24/60
and session_type <> ‘BACKGROUND’
group by sql_id
order by count(*) desc;

--ASH: Top IO SQL
select ash.sql_id, count(*)
from v$active_session_history ash,
v$event_name evt
where ash.sample_time > sysdate –
1/24/60
and ash.session_state = ‘WAITING’
and ash.event_id = evt.event_id
and evt.wait_class = ‘User I/O’
group by sql_id
order by count(*) desc;

-----------------------------------------
--
-- Top 10 CPU consumers in last 5 minutes
--
-----------------------------------------
SQL> select * from
(
select session_id, session_serial#, count(*)
from v$active_session_history
where session_state= 'ON CPU' and
 sample_time > sysdate - interval '5' minute
group by session_id, session_serial#
order by count(*) desc
)
where rownum <= 10;
--------------------------------------------
--
-- Top 10 waiting sessions in last 5 minutes
--
--------------------------------------------
SQL> select * from
(
select session_id, session_serial#,count(*)
from v$active_session_history
where session_state='WAITING'  and
 sample_time >  sysdate - interval '5' minute
group by session_id, session_serial#
order by count(*) desc
)
where rownum <= 10;
