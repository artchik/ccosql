create or replace view ccosql_tool_capabilities as
select
       cap_tool.pcmid as tool_id, tool_names.NAME as tool, cap.cmid as cap_id, cap_names.NAME as capability
from
	CMOBJPROPS17 cap
	join cmobjnames cap_names on cap_names.CMID = cap.cmid and cap_names.LOCALEID = ccosql_get_locale('en')
	join cmobjects cap_tool on cap_tool.cmid = cap.cmid
	join cmobjnames tool_names on tool_names.CMID = cap_tool.pcmid and tool_names.LOCALEID = custom_get_locale()

where
	tool_names.NAME not like 'http:%' and
	tool_names.NAME not in ('/', 'Capability', 'Configuration', 'Styles');