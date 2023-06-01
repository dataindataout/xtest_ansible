#!/bin/bash
# file: scenarios/5_fuzzy_levenshtein.sh

# The Levenshtein score between two strings is the number of transformations 
# needed to change the first string to the second string. 
# For example, the Levenshtein score for baz>bat is 1. For baz>batter, it is 4.

# As you can see below, we get a list of first names having a transformation count 
# (Levenshtein distance) of 0, 1, or 2. First names are being split out using the 
# substring function above. This vastly increases the number of results, but it 
# also helps find the name if I’ve incorrectly guessed the spelling.

ysqlsh -h 127.0.0.1 -ec "WITH q AS (
  SELECT 'Jean' AS qsn
)
SELECT
  levenshtein(lower(substring(name from '[^ ]+'::text)),lower(qsn)) AS leven,
  artists.name
FROM artists, q
WHERE levenshtein(lower(substring(name from '[^ ]+'::text)),lower(qsn)) < 3
ORDER BY leven"