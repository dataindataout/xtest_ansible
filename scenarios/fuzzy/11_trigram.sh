#!/bin/bash
# file: scenarios/11_trigram.sh

# You can search for a string (e.g., name) even if you can’t remember how to spell it.

# This query results in exactly one name that contains similar groupings of letters, 
# and it’s our target name. There’s a bit of luck involved with the selected 
# string in this test, but you can expect a trigram search to significantly 
# reduce results compared to the fuzzy methods. In my testing of several different 
# strings, trigram results were no more than 2 rows for this dataset of ~15K names.

# The trigram method reduces the result list most accurately.

ysqlsh -h 127.0.0.1 -ec "select show_trgm('Jon Verdoo')"

ysqlsh -h 127.0.0.1 -ec "select show_trgm('Jean Verdoux')"

ysqlsh -h 127.0.0.1 -ec "select word_similarity('Jeanne Verdoux','Jon Verdoo')"

ysqlsh -h 127.0.0.1 -ec "select name from artists where similarity(name, 'Jon Verdoo') > 0.3"