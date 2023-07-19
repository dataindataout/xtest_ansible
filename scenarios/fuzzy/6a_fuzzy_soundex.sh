#!/bin/bash
# file: scenarios/6a_fuzzy_soundex.sh

# The Soundex algorithm simplifies a string to a phonetic sound pattern. 

ysqlsh -h 127.0.0.1 -ec "select soundex('cat')"
ysqlsh -h 127.0.0.1 -ec "select soundex('catatonic')"
ysqlsh -h 127.0.0.1 -ec "select soundex('kitten')"

ysqlsh -h 127.0.0.1 -ec "select soundex('Jon')"
ysqlsh -h 127.0.0.1 -ec "select soundex('Jeanne')"
ysqlsh -h 127.0.0.1 -ec "select soundex('Joan')"
ysqlsh -h 127.0.0.1 -ec "select soundex('Zhan')"