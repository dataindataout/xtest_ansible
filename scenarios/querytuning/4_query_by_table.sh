#!/bin/bash
# file: scenarios/4_query_by_table.sh

# Show all queries that access a particular table
# ref for searching in "relations" https://www.postgresql.org/docs/current/arrays.html#ARRAYS-SEARCHING

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select bucket, bucket_start_time, substr(query, 0, 50), relations, calls from pg_stat_monitor where 'public.artists_sql' = any (relations) order by bucket"
