CREATE DATABASE amazon_sentiment_analysis;
USE amazon_sentiment_analysis;


CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50)
);


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50)
);



LOAD DATA INFILE 'T:\GitHub\Financial report\Amazon.Scripts\Amazon-Sentiments\reviews.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, customer_id, product_id, category, review_text, rating, sentiment, polarity);



-- Total Reviews by Sentiment
SELECT sentiment, COUNT(*) AS review_count
FROM amazon_sentiment_analysis.amazon_reviews_sentiment
GROUP BY sentiment
ORDER BY review_count DESC;

-- Average Polarity by Category

Select category , round(avg(polarity),2) as Avg_Polarity
from amazon_sentiment_analysis.amazon_reviews_sentiment
Group by category
order by Avg_Polarity;

--  Top 10 Products by Positive Reviews
select product_id,count(sentiment) as Reviews
From amazon_sentiment_analysis.amazon_reviews_sentiment
Where sentiment = 'Positive'
Group by product_id
Order by Reviews Desc
Limit 10;


-- Negative Reviews Percentage
SELECT 
    ROUND((SUM(CASE WHEN sentiment = 'Negative' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS negative_percentage
FROM amazon_sentiment_analysis.amazon_reviews_sentiment;


