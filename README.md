# SQL User Login Analysis Project

This project contains a collection of advanced SQL analytics problems and optimized solutions built using MS SQL Server syntax. The dataset simulates a user login tracking system and demonstrates real-world SQL querying techniques frequently used in analytics engineering, business intelligence, and data analysis interviews.

## Project Objectives

The project focuses on solving practical business problems using SQL, including:

- User retention analysis
- Login activity tracking
- Quarterly business reporting
- Session trend analysis
- Gap analysis
- Ranking and window functions
- Recursive CTEs
- Time-series analysis

---

## Dataset

### Users Table
Contains user account details.

| Column Name | Description |
|---|---|
| user_id | Unique user identifier |
| user_name | User name |
| status | User status |

### Logins Table
Contains login session activity.

| Column Name | Description |
|---|---|
| user_id | User identifier |
| login_timestamp | Login date and timestamp |
| session_id | Unique session identifier |
| session_score | Session engagement score |

---

## SQL Concepts Covered

- Common Table Expressions (CTEs)
- Recursive CTEs
- Window Functions
- RANK / LAG
- DATEADD / DATEDIFF
- Aggregate Functions
- EXISTS / NOT EXISTS
- Time-based filtering
- Quarter-based reporting
- Performance optimization techniques

---

## Business Problems Solved

1. Users inactive in the last 5 months
2. Quarterly user and session analysis
3. Users active in January but inactive in November
4. Quarter-over-quarter session growth analysis
5. Highest session score by day
6. Daily active user streak analysis
7. Dates with no login activity

---

## Technologies Used

- MS SQL Server
- SQLite (converted query versions)
- SQL Window Functions
- Recursive Queries

---

## Project Structure

```bash
├── dataset/
│   ├── create_tables.sql
│   ├── insert_data.sql
│
├── solutions/
│   ├── problem_solutions_mssql.sql
│   ├── problem_solutions_sqlite.sql
│
├── README.md
```

---

## How to Run

1. Create the database tables
2. Execute the insert scripts
3. Run the SQL solution files
4. Compare MS SQL and SQLite implementations

---

## Learning Outcomes

This project is useful for:

- SQL interview preparation
- Data analyst practice
- Analytics engineering concepts
- Business reporting scenarios
- Query optimization practice

---

## Author

Vaibhav Kamal Nigam
