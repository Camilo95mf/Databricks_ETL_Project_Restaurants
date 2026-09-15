-- ingestion of customer reviews files using autoloader

CREATE OR REFRESH STREAMING TABLE customer_reviews_landing AS
SELECT 
    *,
    current_timestamp() AS ingestion_date,
    _metadata.file_name AS source_file
FROM STREAM(read_files(
    '${customer_reviews_volume_path}',
    format => 'csv',
    inferSchema => true,
    schemaEvolutionMode => 'addNewColumns'
));