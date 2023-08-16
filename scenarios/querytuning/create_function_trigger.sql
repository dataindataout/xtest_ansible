create table if not exists artists_sql_audit (artist_id int, updated varchar(20));

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