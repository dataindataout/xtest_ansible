#!/bin/bash
# file: scenarios/7_log_triggers.sh

# Set up pg_stat_statements and pg_stat_monitor to log functions called in triggers
# Assumes artists_sql table has been set up as in the tasks/moma.yml playbook


randid=$((50000001 + RANDOM % (1+500000021-50000001)))

ysqlsh -h "127.0.0.1" -d moma_sql -f scenarios/querytuning/create_function_trigger.sql

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select pg_stat_statements_reset()"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"insert into artists_sql (artist_id, name) values ($randid, 'Valerie')"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select query from pg_stat_statements where query like '%insert into artists%'"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"select bucket_start_time, query from pg_stat_monitor where query like '%insert into artists%'"
