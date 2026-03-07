-- Create database
CREATE DATABASE IF NOT EXISTS fraud_demo_db;

--Create Table
CREATE EXTERNAL TABLE IF NOT EXISTS fraud_demo_db.fraud_transactions (
    transaction_id BIGINT,
    timestamp STRING,
    amount DOUBLE,
    merchant STRING,
    location STRING,
    payment_method STRING,
    fraud INT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'separatorChar' = ',',
    'quoteChar' = '"',
    'escapeChar' = '\\'
)
STORED AS TEXTFILE
LOCATION 's3://finalproject-fraud-detection/raw/'
TBLPROPERTIES ('skip.header.line.count'='1');

-- Test
SELECT * FROM fraud_demo_db.fraud_transactions LIMIT 10;

-- Fraud vs Normal transactions
SELECT fraud, COUNT(*) AS transaction_count
FROM fraud_demo_db.fraud_transactions
GROUP BY fraud
ORDER BY fraud;

-- Fraud by location
SELECT location, COUNT(*) AS fraud_count
FROM fraud_demo_db.fraud_transactions
WHERE fraud = 1
GROUP BY location
ORDER BY fraud_count DESC;

-- Fraud by merchant
SELECT merchant, COUNT(*) AS fraud_count
FROM fraud_demo_db.fraud_transactions
WHERE fraud = 1
GROUP BY merchant
ORDER BY fraud_count DESC;

-- Fraud by payment method
SELECT payment_method, COUNT(*) AS fraud_count
FROM fraud_demo_db.fraud_transactions
WHERE fraud = 1
GROUP BY payment_method
ORDER BY fraud_count DESC;

-- Fraud by transaction amount range
SELECT
CASE
WHEN amount < 100 THEN 'Low'
WHEN amount BETWEEN 100 AND 500 THEN 'Medium'
ELSE 'High'
END AS amount_range,
COUNT(*) AS fraud_count
FROM fraud_demo_db.fraud_transactions
WHERE fraud = 1
GROUP BY
CASE
WHEN amount < 100 THEN 'Low'
WHEN amount BETWEEN 100 AND 500 THEN 'Medium'
ELSE 'High'
END
ORDER BY fraud_count DESC;
