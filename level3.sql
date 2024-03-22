/* Level3: Advance */

/* Q1: Find how much amount spent by each customer on artists?
Write a query to return customer name, artist name and total spent */
SELECT customer.first_name, customer.last_name, artist.name AS artist_name, 
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_spend
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY customer.first_name, customer.last_name, artist.name
ORDER BY total_spend DESC

/* Let's find which artist has highest earning. 
SELECT artist.artist_id, artist.name, 
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_spend
FROM Invoice_line
JOIN track ON invoice_line.track_id = track.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY artist.artist_id
ORDER BY total_spend DESC
LIMIT 1
*/

/* Q2: We want to find out the most popular music genre for each country.
We determine the most popular genre as with the highest amount of puchases.
White a query that returns each country along with the top genre.
For countries where the maximum number of purchases is shared return all genre.*/
WITH popular_genre AS
(
	SELECT COUNT(invoice_line.quantity) AS purcheses, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice_line.invoice_id = invoice.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON invoice_line.track_id = track.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2, 3, 4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre
WHERE RowNo <=1

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount */
-- Method 1
WITH RECURSIVE
customer_with_country AS (
    SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending
    FROM invoice
    JOIN customer ON customer.customer_id = invoice.customer_id
    GROUP BY 1, 2, 3, 4
    ORDER BY 2, 3 DESC
),

country_max_spending AS (
    SELECT billing_country, MAX(total_spending) AS max_spending
    FROM customer_with_country
    GROUP BY billing_country
)

SELECT 
    cc.billing_country, cc.total_spending, cc.first_name, cc.last_name
FROM customer_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;

-- Method 2 (CT method)
WITH customer_with_country AS(
	SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
	ROW_NUMBER() OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
	FROM invoice
	JOIN customer ON customer.customer_id = invoice.customer_id
	GROUP BY 1, 2, 3, 4
	ORDER BY 4 ASC, 5 DESC
)
SELECT * FROM customer_with_country WHERE RowNo <=1










