#!/bin/bash
# file: scenarios/1_wildcard.sh

# A wildcard filter is a typical SQL method used to find a substring. This method is usually not performant.

ysqlsh -h 127.0.0.1 -ec "select name from artists where name like 'Jean%'"

# Creating a regular index doesn’t help for left-hand wildcards in YugabyteDB 
# in the same way it does in other DBMSs, due to underlying storage differences. 

# One optimization using GIN indexes is highlighted later.