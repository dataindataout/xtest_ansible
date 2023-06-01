#!/bin/bash
# file: scenarios/9_fuzzy_double_metaphone_index.sh

# An index decreases the amount of time spent on this query significantly.

# The indexed double metaphone method is the most performant, 
# especially for long strings that reduce the number of matches.

ysqlsh -h 127.0.0.1 -ec "create index name_dmp on artists (dmetaphone(name))"

ysqlsh -h 127.0.0.1 -ec "select name from artists where dmetaphone(name) = dmetaphone('Jon Verdoo')"