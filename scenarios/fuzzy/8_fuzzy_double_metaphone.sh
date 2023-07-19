#!/bin/bash
# file: scenarios/8_fuzzy_double_metaphone.sh

# The metaphone and improved double metaphone algorithms also simplify a string to a phonetic sound pattern. 
# Since this method is focused on consonant sounds, I don’t need to approximate vowel sounds very closely.

# The result set is again decreased and also includes the target name. 
# Note the differences in this result set from the previous ones.
#  We are now getting spellings of the “J” sound that start with “G.”

ysqlsh -h 127.0.0.1 -ec "select dmetaphone('Jon Verdoo')"

ysqlsh -h 127.0.0.1 -ec "select name, dmetaphone(name) from artists where dmetaphone(name) = dmetaphone('Jon Verdoo')"