-- ingestion of customer files using autoloader

CREATE OR REFRESH STREAMING TABLE customer_landing AS
SELECT 
    *,
    current_timestamp() AS ingestion_date,
    _metadata.file_name AS source_file
FROM STREAM(read_files(
    '${customer_volume_path}',
    format => 'csv',
    inferSchema => true,
    schemaEvolutionMode => 'addNewColumns'
));

