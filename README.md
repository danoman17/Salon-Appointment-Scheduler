# Ahsoka's Salon Appointment Scheduler

## Project Overview

This project is an appointment scheduler for Ahsoka's Salon. It uses PostgreSQL to manage the database of customers, services and appointments. It also uses a bash script to interact with the database.

## Database Schema
The database consists of three tables:

### Tables

#### `customers`
| Column       | Type    | Description                |
|--------------|---------|----------------------------|
| customer_id  | INTEGER | Primary key                |
| phone        | VARCHAR | Unique phone number        |
| name         | VARCHAR | Customer name              |

#### `services`
| Column     | Type    | Description       |
|------------|---------|-------------------|
| service_id | INTEGER | Primary key       |
| name       | VARCHAR | Service name      |

#### `appointments`
| Column         | Type    | Description                                |
|----------------|---------|--------------------------------------------|
| appointment_id | INTEGER | Primary key                                |
| customer_id    | INTEGER | Foreign key referencing `customers`        |
| service_id     | INTEGER | Foreign key referencing `services`         |
| time           | VARCHAR | Appointment time                           |

## Setup Instructions

1. Clone the repository:
    ```bash
    git clone https://github.com/danoman17/Salon-Appointment-Scheduler.git
    cd Salon-Appointment-Scheduler
    ```

2. Import the database schema and data:
    ```bash
    psql --username=<username> --dbname=salon < salon.sql
    ```

3. Run the data insertion script:
    ```bash
    ./salon.sh
    ```

4. Feel free to interact with the system.

## Conclusion

This project demonstrates the ability to design, implement, and manage a complex relational database in PostgreSQL. It showcases data modeling skills, knowledge of SQL, and understanding of database constraints and normalization.

Feel free to explore the database and modify it as needed for your purposes.
