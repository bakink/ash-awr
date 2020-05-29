-- Shared Pool
select
    event,
    time_waited "time_waited(s)",
    case when time_waited = 0 then 
        0
    else
        round(time_waited*100 / sum(time_waited) Over(), 2)
    end "percentage"
from
    (
        select event, sum(time_waited) time_waited
        from v$active_session_history
        where sql_id = 'SQL_ID'
        group by event
    )
order by
    time_waited desc;


-- AWR
select
    event,
    time_waited "time_waited(s)",
    case when time_waited = 0 then 
        0
    else
        round(time_waited*100 / sum(time_waited) Over(), 2)
    end "percentage"
from
    (
        select event, sum(time_waited) time_waited
        from dba_hist_active_sess_history
        where sql_id = 'SQL_ID'
        group by event
    )
order by
    time_waited desc;
