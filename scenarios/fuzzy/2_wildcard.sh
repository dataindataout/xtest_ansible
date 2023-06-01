#!/bin/bash
# file: scenarios/2_wildcard.sh

# For a wildcard that is not left-hand, the timing is about the same.

ysqlsh -h 127.0.0.1 -ec "select name from artists where name like '%ean%'"