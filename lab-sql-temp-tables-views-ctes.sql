USE sakila;
SELECT * FROM customer;
#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_information AS
SELECT c.customer_id, c.first_name, c.last_name, c.email,
COUNT(r.rental_id) AS rental_count
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

SELECT * FROM rental_information;

#Step 2: Create a Temporary Table
#create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment 
#table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_total_paid AS
SELECT ri.customer_id, ri.first_name, ri.last_name, ri.email,
SUM(p.amount) AS total_paid
FROM rental_information ri
INNER JOIN payment p ON ri.customer_id = p.customer_id
GROUP BY ri.customer_id, ri.first_name, ri.last_name, ri.email;

SELECT * FROM customer_total_paid;

#Step 3: Create a CTE and the Customer Summary Report

WITH customer_summary AS (
    SELECT
        ri.first_name,
        ri.last_name,
        ri.email,
        ri.rental_count,
        ctp.total_paid,
        ctp.total_paid / ri.rental_count AS average_payment_per_rental
    FROM
        rental_information ri
    JOIN customer_total_paid ctp ON ri.customer_id = ctp.customer_id
)
SELECT
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM
    customer_summary;

