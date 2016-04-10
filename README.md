# Cognos Capabilities Oracle SQL Query (CCOSQL)

CCOSQL is a solution, at the center of which is a master view (ccosql_group_role_capability) that allows you to examine the currently set capabilites per Cognos role or group to simplify security audit. This view utilizes a number of other views and functions that are parts of this package.


Views
----
ccosql_group_role_capability 
- master view

ccosql_users_groups 
- connects users to groups and roles; used by master view

ccosql_tool_capabilities 
- connects various capabilites to tools (e.g. SQL queries to Report Student)


Functions
----
ccosql_blob2clob2 
- converts blob to clob; used by the master view

ccosql_get_locale 
- obtains the group, role, tool and capability names in the desired language; used by ccosql_users_groups and ccosql_tool_capabilities



## Version
1.0.0

<a href='https://ko-fi.com/A636G5' target='_blank'><img height='32' style='border:0px;height:32px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>


## Compatibility
Cognos 10.1.1
Oracle 11G and up


## Installation

1. Compile all of the functions
2. Compile all of the views



## Use

Let's say we want to see what capabilities the role Authors has:


```sh
select * from ccosql_group_role_capability  where group_role_name = 'Authors'
```

Here's a sample output:

![alt tag](https://lh3.googleusercontent.com/-jLts8PUGEs0/Vwp_G80z3xI/AAAAAAAAQSo/cH7ojbKB64g/s0/mstsc_2016-04-10_12-27-57.png)


Let's examine the fields:

GROUP_ID - this is the group or role id

GROUP_ROLE_NAME - group or role name

OBJECT_TYPE - can either by Role or Group. In this case Authors is a Role.

TOOL - Tools (cognos calls these capabilities also) such as Cognos Viewer, Report Studio, Query Studio, etc.

CAPABILITY - capabilities they have permissions to (each tool has a predefined set of capabilities; see ccosql_tool_capabilities)

PERMISSION - what permission to this capability do they have. This page has a good definition of the capabilities: 
http://kb.mit.edu/confluence/display/mitcontrib/Sharing+Cognos+Reports+Listed+in+My+Folders

PERMISSION_TYPE - if there's no explicit permission set on the capability, it is automatically inherited from the permissions set on the tool. If the permission *is* set on capabilities, these permissions override the general tool permissions

CAP_ID - capability id


## Limitations

Cognos allows you to not only "attach" groups and roles to tools and capabilities, but you can actually control the security on the user level. In other words, you could add a user to the Query Studio with an execute permission as an "exception" to a role. **This solution does not show these users**. It will only show roles and groups.



License
----

Creative Commons Attribution-ShareAlike CC BY-SA License
http://creativecommons.org/licenses/by-sa/4.0/