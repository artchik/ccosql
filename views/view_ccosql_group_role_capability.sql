/*
  Creative Commons Attribution-ShareAlike CC BY-SA License
  http://creativecommons.org/licenses/by-sa/4.0/

  Copyright (c) 2016 Artur Charukhchyan
*/

create or replace view ccosql_group_role_capability as
with
  policies_strs as
    (
      select
        cap_tool_perms.cmid as cap_tool_id,
        regexp_replace(
          regexp_replace(
            regexp_replace(
              ASCIISTR(dbms_lob.substr(REGEXP_REPLACE(custom_blob2clob(policies), '[[:cntrl:]]', null), 4000, 1)),
              '^.*cute', 'execute'
            ),

            '^[^a-z]+', ''
          ),

          '.*FFFD',
          ''
        ) as policies_str

      from
        cmpolicies cap_tool_perms
      where
        policies is not null
    ),

  permissions1 as
  (
    select
      cap_tool_id,
    trim(COLUMN_VALUE) as permission_str,
      regexp_replace(trim(COLUMN_VALUE), '^([a-zA-Z]+)::.*$', '\1') permission
    from
      policies_strs,
      xmltable((
        '"' ||
        regexp_replace(policies_str, '(read|write|execute|traverse|setPolicy)', '","\1') ||
        '"'
      ))

  ),
  
  permissions2 as (
  select
      cap_tool_id, permission_str,
    permission,
      regexp_replace(trim(COLUMN_VALUE), '^(\d+):.*$', '\1') group_role_str
    from
      permissions1,
      xmltable((
        '"' ||
        regexp_replace(permission_str, '::', '","') ||
        '"'
      ))

    where regexp_like(trim(COLUMN_VALUE), '^(\d+):.*$')
  )

select distinct

  ug.group_id,
  ug.group_role_name,
  ug.object_type,
  tp.tool,

  tp.capability as capability,
  permission,
  case when tp.cap_id = p.cap_tool_id then 'capability override' else 'tool inherited' end as permission_type,
  tp.cap_id

from
  permissions2 p
  left join ccosql_groups_roles_users ug on ug.group_id = to_number(group_role_str)
  join ccosql_tool_capabilities tp on tp.cap_id = p.cap_tool_id or
  (
    tp.tool_id = p.cap_tool_id and
    tp.cap_id not in (select t.cmid  from cmpolicies t where t.policies is not null)
  )

order by
  ug.group_role_name,
  tp.tool,
  capability,
  permission
;
