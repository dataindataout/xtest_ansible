#!/bin/bash
# file: scenarios/3_compare_pgstatstatements.sh

# Compare pg_stat_monitor output in previous scenario to pg_stat_statements output

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select query, calls from pg_stat_statements where query like 'select name, nationality, birth_year from artists_sql%'"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select bucket, bucket_start_time, query, calls from pg_stat_monitor where query like 'select name, nationality, birth_year from artists_sql%' order by bucket"
