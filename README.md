# ash-awr
ash and awr scripts

"ON CPU" means that it is working, not waiting. To get a better understanding of the data, you might want to pull/reference the data in all 4 of the columns listed below.

SESSION_STATE. The state the session was in when Active Session History took the sample. It shows WAITING if the session was waiting for something; otherwise, it shows ON CPU to indicate that the session was doing productive work.

EVENT. If the session was in a WAITING state (in the SESSION_STATE column), this column will show the wait event the session was waiting for.

TIME_WAITED. If the session was in a WAITING state, this column will show how long it had been waiting when Active Session History took the sample.

WAIT_TIME. If the session is doing productive work—not in a WAITING state—this column will show how long the session waited for the last wait event.

As to why no data was pulled for that gap of time, you may want to look at the script which pulled the report. Without seeing the script I really can't say. It could be the script restricted the data from being pulled based on some criteria.
