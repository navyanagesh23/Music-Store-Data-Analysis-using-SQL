# Music-Store-Data-Analysis-using-SQL

This project explores and analyzes a music store's customer behavior, sales performance, and music preferences using SQL. We designed the schema, imported data, and ran analytical queries on a relational MySQL database.

## Objective

- Build and query a music store database using SQL.
- Extract insights to support business decisions in marketing, inventory, and customer engagement.

## Schema & Tables Used

- Tables: Genre, Album, Artist, Track, MediaType, Playlist, PlaylistTrack, Customer, Employee, Invoice, InvoiceLine
- Keys & Constraints: 
  - Primary Keys: CustomerId, InvoiceId, TrackId, etc.
  - Foreign Keys: TrackId in InvoiceLine, CustomerId in Invoice

## Problem Statement

We aimed to solve business queries like:
- Who are the top customers?
- Which music genres are most popular?
- Which cities/countries generate the most revenue?
- What are the most frequently purchased tracks or artists?
- Which customers spend the most and where?

## Sample Queries

- Top customers by total spending
- Top 10 rock artists by track count
- Most popular genre per country
- Customer who spent the most in each country
- Tracks longer than the average duration

## Insights Gained

- Rock is a globally preferred genre.
- Specific customers and cities contribute to higher revenue.
- Patterns in track length and artist popularity assist inventory planning.

## Tools Used

- MySQL
- CSV data import using LOAD DATA INFILE
- Joins, Subqueries, Aggregations, Grouping

## Challenges Faced

- Handling complex foreign key relationships
- Dealing with NULL values (e.g., in Composer, State)
- Data import issue (resolved using SQL commands)

## Experience

- Built strong SQL query skills and schema understanding.
- Worked with real-world relational data.
- Improved teamwork and communication.
