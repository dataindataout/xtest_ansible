# xtest_ansible

This repo is meant to act as a local test and demo environment for open source databases.

Please note that while some of the snippets within may be useful in a production environment, this code is meant to be used for demos and experiments, and is not intended to be optimized for high load or scale.

## Local provisioning

Ansible is used to provision database clusters. Current available options are:

- YugabyteDB 3-node cluster (moma) with two tables (artists and artwork) from the MoMA data set
- YugabyteDB 3-node cluster (college-scorecard) with tables from the College Scorecard data set
- YugabyteDB 3-node x 2 xcluster (million) with a million-row generated table
- PostgreSQL single instance using a million-row generated table

An example command for provisioning a test cluster is:
`ansible-playbook -i inventory.yml tasks/moma.yml`

## Notes about the College Scorecard IPEDS dataset

IPEDS = Integrated Postsecondary Education Data System

See <https://collegescorecard.ed.gov/assets/InstitutionDataDocumentation.pdf> for the official College Scorecard documentation about the institutional data.

The automation scripts currently just load the data. Scenarios will be added to this dataset.

## Scenarios

After the cluster is running, various scenarios can be run. Current available scenarios are:

- Demo of fuzzy matching options in YugabyteDB
- Demo of snapshot and restore in YugabyteDB
- Demo of pg_stat_monitor in YugabyteDB

Demos are usually run in order by the leading number on each file. This leaves room for the presenter to discuss with the audience what is happening during each step of the scenario. For example, for the fuzzy matching scenario, you would run the files in this order:

```
scenarios/fuzzy/1_wildcard.sh
scenarios/fuzzy/2_wildcard.sh
scenarios/fuzzy/3_wildcard.sh
...
```

Please feel free to open an issue if you have a scenario request.

## Prerequisites

- a copy of yugabytedb (see <https://download.yugabyte.com> for one option)
- set the group_vars yb_executable_dir to point to your desired YugabyteDB version
- set your path to include the bin and postgres/bin folders within your desired YugabyteDB version
- use set_ips.sh to set local ips for 6 nodes via set_ips.sh (127.0.01 - 127.0.0.6)
- add public ssh key to ~/.ssh/authorized_users file and ssh-add it
- some of the scenarios assume you've upgraded your bash version to something modern (e.g., 5.2.15)
- download and install dsbulk: <https://github.com/yugabyte/dsbulk>

## Customization

If you need to change gflags for YugabyteDB, add the key/value in groups_vars/all and then in the template at tasks/yugabytedb/templates/[tserver.conf.j2|catalog.conf.j2].
