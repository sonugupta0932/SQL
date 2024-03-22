/* Question Set1: Easy */
/* Q1: Who is the senior most employee based on the job?*/

SELECT * FROM employee
ORDER BY levels DESC
limit 1

/* Q2: Which contries has most invices?*/
SELECT billing_country, COUNT(*) AS Count FROM invoice
GROUP BY billing_country
ORDER BY Count DESC
LIMIT 1

/* Q3: What are top 3 values of the total invoices*/
SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3

/* Q4: Which city has the best customers?
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals*/
SELECT billing_city AS city, ROUND(SUM(total)) AS invoice_total FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC

/* Q5: Who is the best customer?
The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money. */

/*1nd Method*/
SELECT customer.first_name, customer.last_name, SUM(invoice.total) AS total
FROM invoice
JOIN customer ON invoice.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1;

/*2nd Method (subquery)*/
SELECT customer.first_name, customer.last_name, CAST(SUM(invoice.total) AS NUMERIC(36,2)) AS total
FROM invoice
JOIN customer ON invoice.customer_id = customer.customer_id
GROUP BY customer.customer_id
HAVING SUM(invoice.total) = (
    SELECT MAX(total_sum)
    FROM (
        SELECT SUM(total) AS total_sum
        FROM invoice
        GROUP BY customer_id
    ) AS subquery
);

/*When you use HAVING total, the error occurs because total is an alias for the aggregated column SUM(invoice.total).
In SQL, aliases defined in the SELECT clause cannot be directly used in the HAVING clause.
Instead, you need to use the expression SUM(invoice.total) to refer to the aggregated column.*/








