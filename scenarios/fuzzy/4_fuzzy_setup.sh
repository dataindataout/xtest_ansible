#!/bin/bash
# file: scenarios/4_fuzzy_setup.sh

# The fuzzystrmatch extension is pre-packaged with YugabyteDB. Issue the following statement to enable it.

ysqlsh -h 127.0.0.1 -ec "create extension if not exists fuzzystrmatch"