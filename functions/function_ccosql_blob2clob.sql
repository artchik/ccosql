/* 
	Converts BLOB to CLOB. 
	Copied from http://stackoverflow.com/questions/12849025/convert-blob-to-clob
	Created by Jon Heller (http://stackoverflow.com/users/409172/jon-heller)
*/

create or replace function ccosql_blob2clob2(p_blob blob) return clob is
      l_clob         clob;
      l_dest_offsset integer := 1;
      l_src_offsset  integer := 1;
      l_lang_context integer := dbms_lob.default_lang_ctx;
      l_warning      integer;

begin

  if p_blob is null then
     return null;
  end if;

  dbms_lob.createTemporary(lob_loc => l_clob
                          ,cache   => false);

  dbms_lob.converttoclob(dest_lob     => l_clob
                        ,src_blob     => p_blob
                        ,amount       => dbms_lob.lobmaxsize
                        ,dest_offset  => l_dest_offsset
                        ,src_offset   => l_src_offsset
                        ,blob_csid    => dbms_lob.default_csid
                        ,lang_context => l_lang_context
                        ,warning      => l_warning);

  return l_clob;

end;