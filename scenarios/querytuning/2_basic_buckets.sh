#!/bin/bash
# file: scenarios/2_basic_buckets.sh

# Show concept of time buckets

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select bucket, bucket_start_time, query, calls from pg_stat_monitor where relations in ('{public.artists_sql}','{public.artwork_sql}') order by bucket"
