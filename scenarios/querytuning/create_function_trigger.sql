create table if not exists artists_sql_audit (artist_id int, updated varchar(20));

create or replace function get_art_artist(artist_id integer) returns text as
$$
begin 
    return (select artwork_sql.artist from artists_sql,artwork_sql where artists_sql.artist_id=$1 and artwork_sql.constituentid=cast(artists_sql.artist_id as text) limit 1);
end; 
$$
language 'plpgsql';

create or replace function audit_insert_artist_trigger_fxn() 
  returns trigger as 
$$ 
begin 
    insert into artists_sql_audit (artist_id, updated) 
         values(NEW.artist_id,current_date); 
return NEW; 
end; 
$$ 
language 'plpgsql';


create trigger artist_insert_trigger
  after insert
  on artists_sql
  for each row
  execute procedure audit_insert_artist_trigger_fxn();