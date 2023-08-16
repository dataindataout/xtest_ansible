#!/bin/bash
# file: scenarios/8_show_errors.sh

# Demonstration of pg_stat_monitor functionality to display details for various log levels (ERROR, WARN, LOG)
# Helpful in debugging issues

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select pg_stat_statements_reset()"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"select pg_stat_monitor_reset()"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select 1/0"
ysqlsh -h "127.0.0.1" -d moma_sql -d moma_sql -ec"select * from table_that_does_not_exist"
ysqlsh -h "127.0.0.1" -d moma_sql -d moma_sql -ec"select get_example_function_that_does_not_exist"

ysqlsh -h "127.0.0.1" -d moma_sql -d moma_sql -ec"select artist_id from artists_sql limit 10"
ysqlsh -h "127.0.0.1" -d moma_sql -d moma_sql -ec"select constituentid from artwork_sql limit 10"
ysqlsh -h "127.0.0.1" -d moma_sql -d moma_sql -ec"select title, artist from artwork_sql where classification='Photograph' limit 10"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select query, queryid from pg_stat_statements where query like '%artist%'"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"select query, decode_error_level(elevel) AS error_type, sqlcode, message from pg_stat_monitor"
