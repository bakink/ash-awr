--https://gavinsoorma.com/2012/11/ash-and-awr-performance-tuning-scripts/
--Which Database Objects Experienced the Most Number of Waits in the Past One Hour
select * from 
(
  select dba_objects.object_name,
 dba_objects.object_type,
active_session_history.event,
 sum(active_session_history.wait_time +
  active_session_history.time_waited) ttl_wait_time
from v$active_session_history active_session_history,
    dba_objects
 where 
active_session_history.sample_time between sysdate - 1/24 and sysdate
and active_session_history.current_obj# = dba_objects.object_id
 group by dba_objects.object_name, dba_objects.object_type, active_session_history.event
 order by 4 desc)
where rownum < 6;

--SQL with the highest I/O in the past one day
select * from 
(
SELECT /*+LEADING(x h) USE_NL(h)*/ 
       h.sql_id
,      SUM(10) ash_secs
FROM   dba_hist_snapshot x
,      dba_hist_active_sess_history h
WHERE   x.begin_interval_time > sysdate -1
AND    h.SNAP_id = X.SNAP_id
AND    h.dbid = x.dbid
AND    h.instance_number = x.instance_number
AND    h.event in  ('db file sequential read','db file scattered read')
GROUP BY h.sql_id
ORDER BY ash_secs desc )
where rownum

--Top CPU consuming queries since past one day
select * from (
select 
	SQL_ID, 
	sum(CPU_TIME_DELTA), 
	sum(DISK_READS_DELTA),
	count(*)
from 
	DBA_HIST_SQLSTAT a, dba_hist_snapshot s
where
 s.snap_id = a.snap_id
 and s.begin_interval_time > sysdate -1
	group by 
	SQL_ID
order by 
	sum(CPU_TIME_DELTA) desc)
where rownum
