SELECT table_name,(index_length/1048576) IndexGB
FROM information_schema.tables
order by IndexGB desc