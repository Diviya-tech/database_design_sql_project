##Relational Database System Design & SQL Implementation

📌 Project Overview

This project presents a complete relational database system designed from business requirements through implementation. It includes conceptual modeling, normalization, schema refinement, and a full SQL-based implementation supporting business operations and query analysis.

The system demonstrates structured database engineering practices including:

Requirement analysis

Entity–Relationship (ER) modeling

Functional dependency analysis

Normalization

Relational schema design

SQL implementation (DDL + DML)

Business-oriented query execution

This repository reflects the full lifecycle of relational database design.

🧠 Problem Statement

The objective of this project was to translate real-world business requirements into a structured relational database system capable of:

Maintaining data integrity

Enforcing constraints

Supporting operational workflows

Executing meaningful business queries

The system was designed to ensure consistency, eliminate redundancy, and maintain normalization standards.

🏗️ Database Design Process

1️⃣ Conceptual Modeling

An Entity–Relationship (ER) model was developed to capture:

Entities

Relationships

Cardinality constraints

Primary and foreign keys

This model forms the foundation of the database structure.

2️⃣ Functional Dependency Analysis & Normalization

Functional dependencies were identified and analyzed to:

Eliminate redundancy

Remove partial and transitive dependencies

Ensure proper normalization

The schema was refined to satisfy normalization requirements and maintain data consistency.

3️⃣ Relational Schema Mapping

The conceptual ER design was converted into a relational schema including:

Table definitions

Primary keys

Foreign key relationships

Referential integrity constraints

The schema supports scalable and structured data storage.

💾 SQL Implementation

The system is implemented using structured SQL scripts located in the /sql directory.

DDL (Data Definition Language)

create.sql – Creates all tables and constraints

drop.sql – Removes existing tables safely

DML (Data Manipulation Language)

insert.sql – Inserts sample data

update.sql – Updates existing records

Business Logic Queries

business_queries.sql – Executes queries aligned with business objectives

These scripts collectively simulate a production-ready database environment.

📂 Project Structure
database-design-sql-project/
│
├── docs/
│   ├── Final Problem Description
│   ├── ER Diagram
│   ├── Functional Dependencies
│   └── Relational Schema
│
├── sql/
│   ├── create.sql
│   ├── insert.sql
│   ├── update.sql
│   ├── drop.sql
│   └── business_queries.sql
│
├── README.md
└── .gitignore
⚙️ How to Run

Execute drop.sql (optional reset)

Execute create.sql to create tables

Execute insert.sql to populate data

Execute update.sql if required

Run business_queries.sql to evaluate outputs

Compatible with standard SQL environments (MySQL/PostgreSQL/SQL Server with minor syntax adjustments).

📊 Key Strengths of This Design

Clear separation between design and implementation

Normalized schema reducing redundancy

Referential integrity enforcement

Modular SQL scripts

Business-oriented query layer

This project demonstrates structured backend database development and disciplined schema design.

🚀 Potential Extensions

Stored procedures and triggers

Index optimization

Transaction management

REST API integration

Migration to cloud-managed database systems

🎯 Skills Demonstrated

Relational database design

ER modeling

Functional dependency analysis

Normalization (2NF/3NF)

SQL (DDL + DML)

Backend data architecture thinking
