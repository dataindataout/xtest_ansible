#!/bin/bash
# file: scenarios/10_trigram_setup.sh

# As an alternate method to fuzzy matching, we can use the trigram extension. 
# The trigram method breaks a string into groups of letters.

# Here is a further definition taken from the PostgreSQL documentation site.
# pg_trgm ignores non-word characters (non-alphanumerics) when extracting trigrams from a string. 
# Each word is considered to have two spaces prefixed and one space suffixed when determining the 
# set of trigrams contained in the string. For example, the set of trigrams in the 
# string “cat” is “ c”, “ ca”, “cat”, and “at”.

# The pg_trgm extension is also pre-packaged with YugabyteDB. Issue the following statement to enable it.

ysqlsh -h 127.0.0.1 -ec "create extension if not exists pg_trgm"