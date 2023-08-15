#!/bin/bash
# file: scenarios/6_create_fdw.sh

# Create a fdw to merge results for all nodes
# (pg_stat_monitor data is stored locally to each node)

ysqlsh -h "127.0.0.1" -d moma_sql -ec"create extension postgres_fdw"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"create server node2 foreign data wrapper postgres_fdw options (host '127.0.0.2', dbname 'moma_sql', port '5433')"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"create server node3 foreign data wrapper postgres_fdw options (host '127.0.0.3', dbname 'moma_sql', port '5433')"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"\des+"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"create user mapping for yugabyte server node2 OPTIONS (user 'yugabyte', password '')"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"create user mapping for yugabyte server node3 OPTIONS (user 'yugabyte', password '')"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select * from pg_user_mappings"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"create schema from2"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"create schema from3"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"import foreign schema public limit to (pg_stat_monitor) from server node2 into from2"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"import foreign schema public limit to (pg_stat_monitor) from server node3 into from3"

ysqlsh -h "127.0.0.1" -d moma_sql -ec"select application_name, client_ip, substr(query, 0, 50), relations, calls from public.pg_stat_monitor where 'public.artists_sql' = any (relations) limit 10"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"select application_name, client_ip, substr(query, 0, 50), relations, calls from from2.pg_stat_monitor where 'public.artists_sql' = any (relations) limit 10"
ysqlsh -h "127.0.0.1" -d moma_sql -ec"select application_name, client_ip, substr(query, 0, 50), relations, calls from from3.pg_stat_monitor where 'public.artists_sql' = any (relations) limit 10"
