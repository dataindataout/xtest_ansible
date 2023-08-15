#!/bin/bash
# file: scenarios/5_show_application_ips.sh

# Show all queries that access a particular table
# ref for searching in "relations" https://www.postgresql.org/docs/current/arrays.html#ARRAYS-SEARCHING

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select application_name, client_ip, substr(query, 0, 50), relations, calls from pg_stat_monitor where 'public.artists_sql' = any (relations) limit 10"