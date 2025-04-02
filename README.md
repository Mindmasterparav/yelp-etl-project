# Yelp Data Engineering & Analysis Project  

## Overview  
This project processes and analyzes the **Yelp Open Dataset**, which is publicly available in JSON format. The dataset was first stored locally, then split into smaller files for efficient handling, uploaded to **AWS S3**, and finally loaded into **Snowflake** for structured querying and analysis.  

## Project Workflow  

### 1. Data Ingestion & Storage  
- Downloaded the **Yelp Open Dataset** (JSON format) from the official website.  
- Split large JSON files into smaller chunks using a Python script.  
- Uploaded partitioned **review and business data** to an **AWS S3 bucket**.  

### 2. Loading Data into Snowflake  
- Imported data from **AWS S3** into Snowflake tables.  
- Stored JSON data in a column using the **VARIANT** data type to preserve the nested structure.  
- Extracted relevant fields from JSON and created **structured tables** for better querying.  

### 3. Data Transformation & Analysis  
- Created two key tables in **Snowflake**:  
  - **TBL_YELP_REVIEWS** – containing review data.  
  - **TBL_YELP_BUSINESS** – containing business details.  
- Extracted relevant fields from JSON objects into structured columns.  
- Performed **SQL-based analysis** on business performance, customer sentiment, and location trends.  

## Technologies Used  
- **Python** (for data preprocessing & file splitting)  
- **AWS S3** (for cloud storage)  
- **Snowflake** (for data warehousing & analysis)  
- **SQL** (for querying & analysis)  

## Key Insights & Results  
- Extracted meaningful **business trends and customer insights** from structured data.  
- Optimized large-scale JSON processing using a combination of **Python, AWS, and Snowflake**.  
- Demonstrated an efficient **ETL (Extract, Transform, Load) pipeline** for handling semi-structured data.  

## How to Reproduce  
1. Download the Yelp Open Dataset from (https://business.yelp.com/data/resources/open-dataset).  
2. Run the Python script to split the JSON files.  
3. Upload the split files to an AWS S3 bucket.  
4. Copy data from S3 into Snowflake using **COPY INTO** commands.  
5. Extract relevant fields from JSON into structured tables.  
6. Perform analysis using SQL queries.  
