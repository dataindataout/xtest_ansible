#!/bin/bash
# file: scenarios/12_metaphone_trigrams.sh

# We can combine the speed of the index on the double metaphone and the precision of the trigrams.

# This gives us a sorted list. Again, there is some luck involved with the test string, 
# but results are similar for various strings on this data. The target string shows up in the first result.

ysqlsh -h 127.0.0.1 -ec "WITH q AS (
  SELECT 'Jon Verdoo' AS qsn
)
SELECT
  similarity(lower(name),lower(qsn)) AS similarity_score,
  artists.name
FROM artists, q
WHERE dmetaphone(name) = dmetaphone(qsn)
ORDER BY similarity_score DESC"