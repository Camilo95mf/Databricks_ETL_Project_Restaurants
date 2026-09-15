-- ingestion of menu items files using autoloader

CREATE OR REFRESH STREAMING TABLE menu_items_landing AS
SELECT 
    *,
    current_timestamp() AS ingestion_date,
    _metadata.file_name AS source_file
FROM STREAM(read_files(
    '${menu_items_volume_path}',
    format => 'csv',
    inferSchema => true,
    schemaEvolutionMode => 'addNewColumns'
));