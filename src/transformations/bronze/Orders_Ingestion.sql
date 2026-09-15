-- ingestion of orders files using autoloader

CREATE OR REFRESH STREAMING TABLE orders_landing AS
SELECT 
    *,
    current_timestamp() AS ingestion_date,
    _metadata.file_name AS source_file
FROM STREAM(read_files(
    '${orders_volume_path}',
    format => 'csv',
    inferSchema => true,
    schemaEvolutionMode => 'addNewColumns',
    quote => '"',
    escape => '"'
));