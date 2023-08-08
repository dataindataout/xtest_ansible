# xtest_ansible

This repo is meant to act as a local test and demo environment for open source databases.

Please note that while some of the snippets within may be useful in a production environment, this code is meant to be used for demos and experiments, and is not intended to be optimized for high load or scale.

Ansible is used to provision database clusters. Current available options are:

- YugabyteDB 3-node cluster (fuzzy) with two tables (artists and artwork) from the MoMA data set
- YugabyteDB 3-node x 2 xcluster (million) with a million-row generated table

An example command for provisioning a test cluster is:
`ansible-playbook -i inventory.yml tasks/fuzzy.yml`

After the cluster is running, various scenarios can be run. Current available scenarios are:

- Demo of fuzzy matching options in YugabyteDB
- Demo of snapshot and restore in YugabyteDB

Demos are usually run in order by the leading number on each file. This leaves room for the presenter to discuss with the audience what is happening during each step of the scenario. For example, for the fuzzy matching scenario, you would run the files in this order:

```
scenarios/1_wildcard.sh
scenarios/2_wildcard.sh
scenarios/3_wildcard.sh
...
```

Please feel free to open an issue if you have a scenario request.

## prerequisites

- a copy of yugabytedb (see <https://download.yugabyte.com> for one option)
- set the group_vars yb_executable_dir to point to your desired YugabyteDB version
- set your path to include the bin and postgres/bin folders within your desired YugabyteDB version
- use set_ips.sh to set local ips for 6 nodes via set_ips.sh (127.0.01 - 127.0.0.6)
- add public ssh key to ~/.ssh/authorized_users file and ssh-add it
- some of the scenarios assume you've upgraded your bash version to something modern (e.g., 5.2.15)
- download and install dsbulk: <https://github.com/yugabyte/dsbulk>
