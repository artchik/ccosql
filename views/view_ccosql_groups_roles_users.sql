/*
	Creative Commons Attribution-ShareAlike CC BY-SA License
  	http://creativecommons.org/licenses/by-sa/4.0/

	Copyright (c) 2016 Artur Charukhchyan

	Adjusted from from http://stackoverflow.com/questions/28672009/content-store-information-on-secured-functions-and-features-of-cognos
	The query provided by Damienknight (http://stackoverflow.com/users/2150274/damienknight)

	Removed comments and some fields. Added call to function ccosql_get_locale

*/


create or replace view ccosql_users_groups as
select 
	decode(cmo.classid, 26, 'Role', 54, 'Group', 'Other') as object_type,
	cmo.cmid  group_id,
	cmon.name group_role_name,
	v_user.name username,
	v_user.cmid user_id
from 
	cmreford1 cmr
	right join cmobjects cmo on cmr.cmid = cmo.cmid                   
	left join cmobjnames cmon on cmo.cmid = cmon.cmid                 	 
	left join cmobjprops33 v_user on cmr.refcmid = v_user.cmid        
where 
	cmo.classid in (26, 54) 
	and cmon.mapdlocaleid = ccosql_get_locale('en') 
order by 
	cmon.name, v_user.name 
;