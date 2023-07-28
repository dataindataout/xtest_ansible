#!/opt/homebrew/bin/bash
# file: scenarios/snapshot/1_create_snapshot.sh

# Take a consistent snapshot of the data and schema on multiple nodes

# Environment variables

ONE_SERVER='127.0.0.1'
CATALOG_SERVERS='127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100'
DB_NAME='fuzzydb'

# Get the current schema version from the catalog

preversion=$(ysqlsh -h $ONE_SERVER -AXqtc "SELECT yb_catalog_version()")

# Create a snapshot
echo "Snapshot started"

snapshot_id=$(yb-admin -master_addresses $CATALOG_SERVERS create_database_snapshot ysql.$DB_NAME | awk -F ' ' '{ print $4 }')
echo "Snapshot ID:" $snapshot_id

# Ensure snapshot has completed

snapshot_status=0; 
while [ "$snapshot_status" != 'COMPLETE' ]; do 
  snapshot_status=$(yb-admin --master-addresses $CATALOG_SERVERS list_snapshots | grep $snapshot_id | awk -F ' ' '{ print $2 }');
done

echo "Snapshot completed"

# Create a backup of the schema

echo "Backing up schema"

ysql_dump -h $ONE_SERVER --include-yb-metadata --serializable-deferrable --create --schema-only --dbname $DB_NAME --file $DB_NAME.sql

# Verify the schema has not changed during this process

postversion=$(ysqlsh -h $ONE_SERVER -AXqtc "SELECT yb_catalog_version()")

if [ $preversion != $postversion ] 
then
    echo "The schema definition changed during this backup. Please re-run the process for a consistent backup."
fi

# Create snapshot metadata file

yb-admin --master_addresses $CATALOG_SERVERS export_snapshot $snapshot_id $DB_NAME.snapshot

echo "Backup of data, schema, and metadata complete; ready for next step."

# set backup location

backup_location="/tmp/backup_$(date '+%Y-%m-%d_%H%M')"
mkdir $backup_location

# create an array for table IDs in this database

echo "Reading table IDs into array"

readarray -t table_list < <(yb-admin --master_addresses $CATALOG_SERVERS list_tables include_table_id | grep $DB_NAME | egrep -v 'pg_|sql_' | awk -F ' ' '{print $2}')
declare -p table_list

# copy the schema file to an external location
# in practice, this would be an upload to a cloud bucket

echo "Copying schema file to external location"

cp $DB_NAME.sql $backup_location/$DB_NAME.sql

# copy the metadata file to an external location

echo "Copying metadata file to external location"

cp $DB_NAME.snapshot $backup_location/$DB_NAME.snapshot

# copy the snapshot files for each node to an external location
# in practice, you would connect to each node to do this
# but this test environment is running on a single machine

echo "Copying tablet snapshots to external location"

for i in "${table_list[@]}"
do
  for j in {1..3}
  do
    mkdir -p $backup_location/data$j/yb-data/tserver/data/rocksdb/table-$i/
    cp -R /tmp/data$j/yb-data/tserver/data/rocksdb/table-$i/tablet-*.snapshots \
	    $backup_location/data$j/yb-data/tserver/data/rocksdb/table-$i/
  done
done

echo "Completed backup process successfully"
echo "Your backup is in $backup_location"