# YouTube Data Analysis Project

## Overview
This project aims to analyze YouTube data using various AWS services to build a comprehensive data analytics pipeline. The outcome will be visualized in a QuickSight dashboard, allowing for insightful decision-making based on viewership data, trends, and patterns.

### Objectives
- To collect and store YouTube data efficiently.
- To process and analyze data using AWS services.
- To visualize data with Amazon QuickSight for better insights.

## Architecture
The architecture of this project comprises the following AWS services:

1. **YouTube API**: Data source for fetching video statistics, user engagement data, and more.
2. **AWS Lambda**: Serverless compute service to run code in response to triggers and process incoming data.
3. **Amazon S3**: Storage service for storing raw and processed data files.
4. **Amazon RDS**: Relational database service for storing structured data for querying and analysis.
5. **AWS Glue**: ETL (Extract, Transform, Load) service to prepare data for analysis.
6. **Amazon QuickSight**: BI service for creating interactive dashboards and visualizing data.

### Data Flow Diagram
1. Data is fetched from the YouTube API and stored in Amazon S3.
2. AWS Lambda functions process the data, transforming it into a suitable format.
3. The processed data is then stored in Amazon RDS.
4. AWS Glue performs ETL operations on the data for analysis.
5. Finally, Amazon QuickSight visualizes the data, providing powerful insights through interactive dashboards.

## Conclusion
This YouTube Data Analysis project leverages AWS services to provide a scalable and efficient solution for analyzing video data, enhancing data-driven decision-making processes for content creators and marketers.