# 📊 Amazon Review Sentiment Analysis

## ✅ Overview

This project analyzes Amazon product reviews using **Python**, stores
data in **MySQL**, and visualizes insights in **Power BI**. Cloud
integration is demonstrated using **Azurite** (Azure Blob Storage
emulator).

------------------------------------------------------------------------

## 🚀 Tech Stack

![Python]
![MySQL]
![Power%20BI]
![Azure]

------------------------------------------------------------------------

## 🏗️ Architecture Workflow

    Python (Data Generation + Sentiment Analysis) → MySQL (Relational Storage)
            → Power BI (Visualization) → Azure Blob (Simulated with Azurite)

------------------------------------------------------------------------

## 📂 Dataset

-   **Size**: 500 Amazon product reviews (synthetic but realistic)
-   **Features**:
    -   Customer ID, Product ID, Review Text, Rating
    -   Sentiment (Positive/Negative/Neutral)
    -   Polarity Score (-1 to +1)

------------------------------------------------------------------------

## 🛠️ Key SQL Queries

``` sql
-- Total Reviews
SELECT COUNT(*) FROM amazon_reviews_sentiment;

-- Avg Polarity by Category
SELECT category, ROUND(AVG(polarity), 2) FROM amazon_reviews_sentiment GROUP BY category;

-- Top 10 Products by Positive Reviews
SELECT product_id, COUNT(sentiment) as Positive_Count
FROM amazon_reviews_sentiment
WHERE sentiment='Positive'
GROUP BY product_id
ORDER BY Positive_Count DESC
LIMIT 10;
```

------------------------------------------------------------------------

## 📊 Power BI Dashboard

### Main Dashboard:

![Main Dashboard]

### Drill-through Page:

![Drillthrough Page]

------------------------------------------------------------------------

## ▶ How to Run

1.  Clone this repository:

    ``` bash
    git clone <your-repo-url>
    ```

2.  Install Python dependencies:

    ``` bash
    pip install -r requirements.txt
    ```

3.  Import dataset into MySQL using the provided SQL scripts.

4.  Open Power BI and connect to MySQL database for visualization.

------------------------------------------------------------------------

## 🔮 Future Enhancements

-   ✅ Integrate live Azure Blob Storage
-   ✅ Use Azure Cognitive Services for advanced NLP
-   ✅ Deploy real-time dashboard on Power BI Service

------------------------------------------------------------------------

## 🔗 Connect with Me

-   [GitHub](https://github.com/Tanu272004/Amazon_Sentiments.git)
-   [LinkedIn](https://www.linkedin.com/in/tanmay-sharma-800599373/)
