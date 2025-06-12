# 🎓 Student Management System - SQL Database Project

This project models a comprehensive **University Student Management System** using SQL. It includes students, departments, instructors, courses, and enrollments. The database is designed for academic analytics and reporting, such as enrollment trends, gender distribution, department-wise participation, and course popularity.

---

## 📌 Project Overview

The goal of this project is to build a normalized relational database schema that supports:
- Student-course enrollments
- Instructor-course assignments
- Department-wise reporting
- Gender distribution analytics
- Operational insights using SQL

---

## 🛠️ Tools Used

| Tool             | Purpose                        |
|------------------|--------------------------------|
| **Microsoft SQL Server** | Database & Query Execution |
| **Dbdiagram.io**         | ERD Modeling              |
| **Excel / Google Sheets** | Sample Data Input        |

---

## 🧱 Database Tables

The project consists of 6 core tables:

| Table              | Description                                      |
|--------------------|--------------------------------------------------|
| `students`         | Stores student info and department reference     |
| `departments`      | Academic departments like CS, Math, etc.         |
| `courses`          | Course catalog, linked to departments            |
| `instructors`      | Faculty members, also linked to departments      |
| `enrollments`      | Junction table linking students to courses       |
| `course_instructors` | Junction table linking instructors to courses |

---

## 🔗 Relationships

- One-to-Many:  
  - `departments` → `students`, `courses`, `instructors`  
- Many-to-Many (via junction tables):  
  - `students` ↔ `courses` → `enrollments`  
  - `instructors` ↔ `courses` → `course_instructors`

---

## 📊 Analytical Queries Included

A rich set of queries was developed to support academic reporting and insights, including:

| Report Area                      | Sample Questions Answered                             |
|----------------------------------|--------------------------------------------------------|
| 🎓 Enrollment Analysis           | How many students per course?                         |
| 📚 Course & Department Trends    | Which course has the most enrollments?                |
| 🧑‍🏫 Instructor Analysis         | Which instructors teach the most gender-diverse courses? |
| 📈 Operational Health            | Which students aren't enrolled in any course?         |
| 📉 Department Gaps              | Which departments have the least students?            |
| 🔍 Average Load Analysis         | How many courses does each student take on average?   |

Each query is documented with:
- SQL code
- Explanation of joins and logic
- Use of `CTEs`, `JOINs`, `CASE`, `DENSE_RANK`, etc.

---

## 📁 Project Structure

📄 DDL.sql # Database table creation scripts
- 📄 DML.sql # Analytical SQL queries
- 📄 sample_data_inserts.sql # Insert statements for sample data
- 📄 University_Sample_Data.xlsx # Structured Excel with sample data
- 📄 University_Enrollment_Documentation.docx # Project documentation
- 📄 README.md # Project summary and usage



---

## 🧪 Sample Data

Sample data is provided in `.xlsx` formats for:
- `students`
- `departments`
- `courses`
- `instructors`
- `enrollments`
- `course_instructors`

---

## ✅ Getting Started

1. Clone this repo or download the `.sql` files.
2. Open the `DDL.sql` in SQL Server and run it to create the tables.
3. Run `sample_data_inserts.sql` to populate data.
4. Run `DML.sql` to execute the analysis queries.

---

## 📬 Feedback & Contributions

Feel free to fork the repo, suggest improvements, or reach out with feedback! This project is part of a growing portfolio in academic database design and SQL analytics.

---

## 📘 License

This project is shared for educational use and is open for collaboration.

---

