#!/bin/bash
# file: scenarios/1_generate_data.sh

# Generate a variety of queries on the moma_sql.artists.sql table

for in in {1..1000}
do
    type=$((1 + RANDOM % 3))
    host=$((1 + RANDOM % 3))
    randdate=$((1850 + RANDOM % (1+2010-1850)))

    case "$type" in 

        1) 
            ysqlsh -h "127.0.0.$host" -d moma_sql -qc"select name, nationality, birth_year from artists_sql limit 10" -o /tmp/1
            ;;

        2)
            ysqlsh -h "127.0.0.$host" -d moma_sql -qc"select name, nationality from artists_sql where birth_year>$randdate limit 10" -o /tmp/2
            ;;

        3)
            ysqlsh -h "127.0.0.$host" -d moma_sql -qc"select title, artist from artwork_sql where artworkdate='$randdate' limit 10" -o /tmp/2
            ;;

        4)
            ysqlsh -h "127.0.0.$host" -d moma_sql -qc"select title, artist from artwork_sql where classification='Photograph' limit 10" -o /tmp/2
            ;;

        5)
            ysqlsh -h "127.0.0.$host" -d moma_sql -qc"select artwork_sql.title, artwork_sql.artist, artists_sql.birth_year from artists_sql,artwork_sql where artists.birth_year>$randdate and artwork_sql.constituentid=cast(artists_sql.artist_id as text) limit 100" -o /tmp/2
            ;;

        *)
            ysqlsh -h "127.0.0.$host" -d moma_sql -qc"select count(artist_id), nationality from artists_sql group by nationality order by count desc limit 10" -o /tmp/3
            ;;
    esac
done
