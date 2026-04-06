-- Athena Queries for YouTube Data Analysis

-- 1. Create Table (if not exists)
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
LOCATION 's3://youtube-data-processed/videos/';

-- 2. Top 10 Most Viewed Videos
SELECT 
    video_title,
    channel_title,
    view_count,
    like_count,
    comment_count,
    published_at
FROM youtube_videos
ORDER BY view_count DESC
LIMIT 10;

-- 3. Channel Performance Summary
SELECT 
    channel_title,
    COUNT(*) as total_videos,
    SUM(view_count) as total_views,
    AVG(view_count) as avg_views,
    SUM(like_count) as total_likes,
    SUM(comment_count) as total_comments,
    MAX(published_at) as latest_video_date
FROM youtube_videos
GROUP BY channel_title
ORDER BY total_views DESC;

-- 4. Engagement Rate Analysis
SELECT 
    video_title,
    channel_title,
    view_count,
    (like_count + comment_count) as total_engagement,
    ROUND(((like_count + comment_count) * 100.0 / view_count), 2) as engagement_rate
FROM youtube_videos
WHERE view_count > 0
ORDER BY engagement_rate DESC
LIMIT 20;

-- 5. Daily Views Trend
SELECT 
    DATE(published_at) as publish_date,
    SUM(view_count) as daily_views,
    COUNT(*) as videos_published,
    AVG(view_count) as avg_view_per_video
FROM youtube_videos
GROUP BY DATE(published_at)
ORDER BY publish_date DESC;

-- 6. Category Distribution
SELECT 
    category_id,
    COUNT(*) as video_count,
    SUM(view_count) as total_views,
    AVG(view_count) as avg_views
FROM youtube_videos
GROUP BY category_id
ORDER BY total_views DESC;

-- 7. High Engagement Videos (Engagement Rate > 5%)
SELECT 
    video_title,
    channel_title,
    view_count,
    like_count,
    comment_count,
    ROUND(((like_count + comment_count) * 100.0 / view_count), 2) as engagement_rate
FROM youtube_videos
WHERE view_count > 0 AND ((like_count + comment_count) * 100.0 / view_count) > 5
ORDER BY engagement_rate DESC;

-- 8. Repair and add partitions
MSCK REPAIR TABLE youtube_videos;
