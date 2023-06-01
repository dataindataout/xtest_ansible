#!/bin/bash
# file: scenarios/6_fuzzy_soundex.sh

# The Soundex algorithm simplifies a string to a phonetic sound pattern. 
# I’ve chosen “Jon Verdoo” as the best phonetic spelling of the target artist’s name.

# The result set demonstrates how broadly the matching is with Soundex, and 
# this can really help if you don’t know how to spell a string. 
# Notice that the target name does appear on the list.

# Notice the run time to compare with after adding the index.

ysqlsh -h 127.0.0.1 -ec "select soundex('Jon Verdoo')"

ysqlsh -h 127.0.0.1 -ec "select name, soundex(name) from artists where soundex(name)=soundex('Jon Verdoo')"