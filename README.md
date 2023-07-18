# prereqs

- a copy of yugabytedb
- set the group_vars yb_executable_dir to point to your desired YugabyteDB version
- set your path to include the bin and postgres/bin folders within your desired YugabyteDB version
- set local ips for 6 nodes via set_ips.sh (127.0.01 - 127.0.0.6)
- add public ssh key to ~/.ssh/authorized_users file and ssh-add it
- some of the scenarios assume you've upgraded your bash version to something modern (e.g., 5.2.15)

# run

- tasks/million.yml provides an xcluster setup with a table with a million rows
- tasks/fuzzy.yml provides a single cluster (3 nodes) with a table of artists to test fuzzy matching
