# YouTube Data Analysis - AWS Data Engineering Project

This project demonstrates a complete data engineering pipeline for analyzing YouTube data using AWS services with QuickSight visualization.

## Project Architecture

```
YouTube Data Source
        ↓
   AWS Lambda
   (API Ingestion)
        ↓
   S3 (Raw Bucket)
        ↓
   AWS Glue
   (ETL Pipeline)
        ↓
   S3 (Processed Bucket)
        ↓
   Amazon Athena
   (Query Layer)
        ↓
   QuickSight Dashboard
   (Visualization)
```

## AWS Services Used

- **S3**: Data lake storage for raw and processed data
- **Lambda**: Serverless compute for data ingestion
- **AWS Glue**: ETL and data cataloging
- **Athena**: SQL query engine on S3
- **CloudWatch**: Monitoring and logging
- **IAM**: Access control and security
- **QuickSight**: Business intelligence and visualization

## Project Components

### 1. Data Ingestion (Lambda)
- Fetch YouTube data via YouTube API
- Store raw data in S3
- Scheduled execution using CloudWatch Events

### 2. Data Processing (Glue)
- Data cleaning and transformation
- Schema validation
- Partitioning by date and category

### 3. Data Storage (S3)
- Raw data layer: `s3://youtube-data-raw/`
- Processed data layer: `s3://youtube-data-processed/`
- Archive layer: `s3://youtube-data-archive/`

### 4. Analytics (Athena + QuickSight)
- Query data using SQL
- Create dashboards for KPIs
- Real-time analytics and reporting

## Key Metrics Analyzed

- Video view counts
- Like/dislike ratios
- Comment sentiment analysis
- Channel performance metrics
- Trending videos analysis
- Viewer demographics
- Engagement rates

## Dashboard Features

- Real-time video performance
- Channel comparison analytics
- Trending content insights
- Historical trend analysis
- Custom filters and drill-downs

## Setup Instructions

### Prerequisites
- AWS Account with appropriate permissions
- YouTube Data API key
- AWS CLI configured
- Python 3.9+

### Installation Steps

1. Clone the repository
2. Configure AWS credentials
3. Deploy infrastructure using CloudFormation/Terraform
4. Set up YouTube API credentials
5. Deploy Lambda functions
6. Configure Glue jobs
7. Create QuickSight datasets and dashboards

## Cost Optimization

- Use S3 lifecycle policies for archival
- Leverage Athena partitioning
- Schedule Lambda runs during off-peak hours
- Use QuickSight SPICE for caching

## Security Best Practices

- Encrypt data at rest and in transit
- Use IAM roles with least privilege
- Enable S3 versioning and MFA delete
- Monitor with CloudTrail
- Secure API keys in Secrets Manager

## File Structure

```
├── lambda/
│   ├── data_ingestion/
│   └── requirements.txt
├── glue/
│   ├── etl_scripts/
│   └── schemas/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── queries/
│   └── athena_queries.sql
├── dashboard/
│   └── quicksight_config.json
└── documentation/
    └── architecture.md
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first.

## License

MIT License
