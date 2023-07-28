#!/opt/homebrew/bin/bash
# file: scenarios/snapshot/2_restore_snapshot.sh

# Move the complete snapshot, schema, and metadata to external location

# Environment variables

ONE_SERVER='127.0.0.1'
CATALOG_SERVERS='127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100'
DB_NAME='fuzzydb'

# Drop database

echo "The next step is to drop the database so we can test a restore.\n"
echo "Please open a ysqlsh prompt and drop the fuzzydb database manually.\n"

read -p "Have you dropped the fuzzydb database? (yes/no) " yn

case $yn in 
	yes ) echo ok, we will proceed;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

# Here, we get the location of the backup. 
# In the real world, a cloud bucket would get passed on the command line when the script is called,
# but this is a demo environment, and the presenter will be talking through these steps.

echo "This script needs to know where your backup files are. An example would be /tmp/backup_2023-07-18_1744\n"

read -p "Enter the directory location of your backup files (schema, metadata, tablet snapshots): " backup_location

echo "Restoring from $backup_location\n"

# Restore the schema

echo "Restoring the schema"

ysqlsh -h $ONE_SERVER --echo-all --file=$backup_location/$DB_NAME.sql

# Import the snapshot

echo "Restoring the metadata"

yb-admin -master_addresses $CATALOG_SERVERS import_snapshot $backup_location/$DB_NAME.snapshot $DB_NAME | grep "\t" | tee mapping.out

# For optimization, change 1_create to just grab leader snapshots using yb-admin list tablets to determine leadership

# Copy snapshot files into the database directory 
# this would be easier if the mapping output from import_snapshot was denormalized

readarray -t table_list < <(yb-admin --master_addresses $CATALOG_SERVERS list_tables include_table_id | grep $DB_NAME | egrep -v 'pg_|sql_' | awk -F ' ' '{print $2}')
declare -p table_list 1> /dev/null

readarray -t mapping < <(cat mapping.out)
declare -p mapping 1> /dev/null

for a in "${table_list[@]}"
do
    readarray -t tablets < <(yb-admin --master_addresses $CATALOG_SERVERS list_tablets tableid.$a | grep -v Tablet | awk -F ' ' '{print $1}')
    declare -p tablets 1> /dev/null

    for t in "${tablets[@]}"
    do

        # loop through the array created from mapping.out and get old/new table and tablet IDs
        for i in "${mapping[@]}"
        do
            if [[ $i == *"$a"* ]]; then
                oldTableID=$(echo $i | awk '{print $2}')
                newTableID=$(echo $i | awk '{print $3}')
            elif [[ $i == *"$t"* ]]; then
                oldTabletID=$(echo $i | awk '{print $3}')
                newTabletID=$(echo $i | awk '{print $4}')
            fi
        done

        # copy the tablet snapshots into place (replacing the current *.snapshot files with backed up snapshot files)
        for j in {1..3}
        do                
                cp -r $backup_location/data$j/yb-data/tserver/data/rocksdb/table-$oldTableID/tablet-$oldTabletID.snapshots/* /tmp/data$j/yb-data/tserver/data/rocksdb/table-$newTableID/tablet-$newTabletID.snapshots/
        done

    done

done

# Restore the data from the snapshot files copied into the directories above

echo "Here is a list of available snapshots:"

yb-admin --master_addresses $CATALOG_SERVERS list_snapshots

read -p "Enter the new ID of the snapshot you would like to restore: " snapshot_id

# rename the snapshots that were placed in the data directory snapshots with the new snapshot ID
# this needs error handling
old_snapshot_id=$(cat mapping.out | grep $snapshot_id | awk '{print $2}')
find /tmp/data*/yb-data/tserver/data/rocksdb/table*/tablet*snapshots/* -type d -exec rename "s/$old_snapshot_id/$snapshot_id/" '{}' \+

echo "Restoring snapshot $snapshot_id\n"

yb-admin --master_addresses $CATALOG_SERVERS restore_snapshot $snapshot_id

echo "Restore complete"
