# YouTube Data Analysis Architecture

## System Overview

This document describes the end-to-end architecture for the YouTube Data Analysis project on AWS.

## Data Flow

### Stage 1: Ingestion
- **Source**: YouTube Data API
- **Compute**: AWS Lambda (Python)
- **Frequency**: Daily scheduled execution
- **Output**: Raw JSON files → S3

### Stage 2: Processing
- **Tool**: AWS Glue
- **Operations**: 
  - Data validation
  - Schema enforcement
  - Data cleaning
  - Partitioning
- **Output**: Parquet files → S3

### Stage 3: Analytics
- **Query Engine**: Amazon Athena
- **Catalog**: AWS Glue Data Catalog
- **Optimization**: Partition pruning, columnar storage

### Stage 4: Visualization
- **BI Tool**: Amazon QuickSight
- **Datasets**: Connected to Athena
- **Dashboards**: KPI tracking and analysis

## AWS S3 Bucket Structure

```
youtube-data-lake/
├── raw/
│   └── year=2026/month=04/day=06/
│       ├── videos_*.json
│       └── channels_*.json
├── processed/
│   ├── videos/
│   │   └── year=2026/month=04/day=06/
│   │       └── data.parquet
│   └── channels/
│       └── year=2026/month=04/day=06/
│           └── data.parquet
└── archive/
    └── year=2025/
```

## Lambda Function Design

### Function: YouTubeDataIngestion
- **Runtime**: Python 3.9
- **Memory**: 512 MB
- **Timeout**: 300 seconds
- **Trigger**: CloudWatch Events (Daily 00:00 UTC)
- **Environment Variables**:
  - YOUTUBE_API_KEY
  - S3_BUCKET_RAW
  - AWS_REGION

## AWS Glue Job Configuration

### Job: TransformYouTubeData
- **Type**: Spark
- **Glue Version**: 4.0
- **Worker Type**: G.1X
- **Number of Workers**: 5
- **Timeout**: 2880 minutes
- **Retry**: 1

## Athena Table Schema

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS youtube_videos (
    video_id STRING,
    channel_id STRING,
    channel_title STRING,
    video_title STRING,
    description STRING,
    published_at TIMESTAMP,
    view_count BIGINT,
    like_count BIGINT,
    comment_count BIGINT,
    duration INT,
    tags ARRAY<STRING>,
    category_id STRING,
    ingestion_date DATE
)
PARTITIONED BY (year INT, month INT, day INT)
STORED AS PARQUET
LOCATION 's3://youtube-data-lake/processed/videos/'
```

## QuickSight Dashboard Specifications

### Datasets
- Videos Performance Dataset
- Channels Comparison Dataset
- Trending Content Dataset

### Visualizations
- KPI Cards (Total Views, Avg Engagement)
- Time Series Charts (Views over time)
- Bar Charts (Top videos, Top channels)
- Heat Maps (Activity patterns)
- Pie Charts (Category distribution)

## IAM Roles and Permissions

### Lambda Execution Role
- S3 bucket read/write
- Secrets Manager access (for API keys)
- CloudWatch logs

### Glue Execution Role
- S3 full access
- Glue catalog access
- CloudWatch logs

### Athena Execution Role
- S3 query results bucket
- Glue catalog access
- CloudWatch logs

## Monitoring and Logging

- CloudWatch Logs for Lambda and Glue
- CloudWatch Metrics for custom KPIs
- CloudTrail for audit logging
- X-Ray for performance tracing

## Cost Estimates (Monthly)

- Lambda: ~$5-15 (light usage)
- S3: ~$20-50 (storage + requests)
- Glue: ~$50-100 (job execution)
- Athena: ~$10-30 (data scanned)
- QuickSight: ~$15/user (enterprise edition)

---