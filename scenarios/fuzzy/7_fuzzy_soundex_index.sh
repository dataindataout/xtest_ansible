#!/bin/bash
# file: scenarios/7_fuzzy_soundex_index.sh

# Adding an index on the soundex reduced the runtime for this query.

ysqlsh -h 127.0.0.1 -ec "create index name_soundex on artists (soundex(name))"

ysqlsh -h 127.0.0.1 -ec "select name, soundex(name) from artists where soundex(name)=soundex('Jon Verdoo')"