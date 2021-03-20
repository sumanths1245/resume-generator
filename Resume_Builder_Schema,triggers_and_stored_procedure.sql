

create table personal_details(
	person_id serial not null primary key,
	First_name text not null,
	Last_name text not null,
	DOB timestamptz not null,
	email_address text not null,
	ph_no text  not null,
	extracircular_activities text,
	languages_known text
	user_id integer references auth_user(id) on delete cascade
	);


create table resume(
	resume_id serial not null primary key,
	resume_name text not null,
	person_id integer references personal_details(person_id) on delete cascade
	last_updated TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP
	);
	
create table address(
	address_id serial not null primary key,
	address_line1 text not null,
	address_line2 text,
	city text not null,
    state text not null,
	country text not null,
	zip_code text not null,
	resume_id integer references resume(resume_id) on delete cascade
	);
	
create table qualifications(
	qualification_id serial not null primary key,
	qualification text not null,
	year_of_passing text not null, 
	school_or_college text not null,
	Board_or_University text not null,
	CGPA_or_percentage numeric(5,2) not null,
	resume_id integer references resume(resume_id) on delete cascade
	);
	
create table skills(
	skill_id serial not null primary key,
	skill_name text,
	S_experience text,
	resume_id integer references resume(resume_id) on delete cascade
	);
	

	
create table certifications(
	certification_id serial not null primary key,
	certificate_id text,
	issued_by text,
	valid_period text,
	resume_id integer references resume(resume_id) on delete cascade
	);

create table internships(
	intership_id serial not null primary key,
	name_of_role text,
	period text,
	company_name text,
	I_description text,
	resume_id integer references resume(resume_id) on delete cascade
	);
	
create table projects(
	project_id serial not null primary key,
	project_name text,
	P_description text,
	resume_id integer references resume(resume_id) on delete cascade
	);

create table social_networks(
	social_network_id serial not null primary key,
	Network_Name text,
	link text,
	resume_id integer references resume(resume_id) on delete cascade
	);
	
create table audit_log(
	audit_log_id serial not null primary key,
	person_id integer not null,
	resume_id integer not null,
	action text not null,
	last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
	);


create or replace function resume_creation_log() returns trigger LANGUAGE PLPGSQL as
$$
BEGIN 
	insert into audit_log(person_id,resume_id,action,last_updated) values (NEW.person_id,NEW.resume_id,'add',now() );
	return NEW;
END;
$$

create trigger resume_audit 
after insert 
on resume 
for each row
execute procedure resume_creation_log()




create or replace function resume_updation_log() returns trigger LANGUAGE PLPGSQL as
$$
BEGIN 
	insert into audit_log(person_id,resume_id,action,last_updated) values (NEW.person_id,NEW.resume_id,'update',now() );
	return NEW;
END;
$$



create trigger resume_audit_update 
after update of last_updated
on resume
for each row
execute procedure resume_updation_log()










CREATE OR REPLACE FUNCTION ActiveResumes()

  RETURNS integer

AS $BODY$

DECLARE

   data RECORD;
   count integer;

BEGIN
	count = 0;
	
    FOR data IN

        SELECT resume_id, person_id from resume

    LOOP

        count = count+1;

    END LOOP;

 

    IF NOT FOUND THEN

        return 0;

    END IF;  

   

    return count;

END;

$BODY$ LANGUAGE plpgsql;



