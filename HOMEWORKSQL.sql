USE sakila ;
-- 1a
SELECT a.first_name, a.last_name FROM actor AS a;
 
-- 1b

SELECT CONCAT(UPPER(a.first_name), " ", UPPER(a.last_name)) AS 'Actor Name' FROM actor AS a;

-- 2a

SELECT a.first_name, a.last_name FROM actor AS a
WHERE a.first_name = 'JOE';

-- 2b 

SELECT a.first_name, a.last_name FROM actor AS a
WHERE a.last_name LIKE '%GEN%';

-- 2c

SELECT a.first_name, a.last_name FROM actor AS a
WHERE a.last_name LIKE '%LI%'
ORDER BY a.last_name, a.first_name; 

-- 2d
SELECT co.country_id, co.country FROM country AS co
WHERE co.country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor 
ADD ( description BLOB );

-- 3b

ALTER TABLE actor
DROP COLUMN `description`;

-- 4a

SELECT last_name , count(*) FROM actor 
GROUP BY last_name;

-- 4b
SELECT last_name, Total from (
SELECT last_name , COUNT(*) AS 'Total' FROM actor 
GROUP BY last_name) AS T
WHERE T.Total > 1;

-- 4c

SELECT last_name , first_name FROM actor 
WHERE last_name = 'WILLIAMS' AND  first_name = 'GROUCHO';

UPDATE actor
SET first_name = 'HARPO' 
WHERE  last_name = 'WILLIAMS' AND  first_name = 'GROUCHO';

-- 4d

SELECT last_name , first_name FROM actor 
WHERE first_name = 'HARPO';

UPDATE actor
SET first_name = 'GROUCHO' 
WHERE first_name = 'HARPO';

-- 5a used tabled name rental1 for example.
    CREATE TABLE `rental1` (
   `rental_id` int(11) NOT NULL AUTO_INCREMENT,
   `rental_date` datetime NOT NULL,
   `inventory_id` mediumint(8) unsigned NOT NULL,
   `customer_id` smallint(5) unsigned NOT NULL,
   `return_date` datetime DEFAULT NULL,
   `staff_id` tinyint(3) unsigned NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`rental_id`),
   UNIQUE KEY `rental_date` (`rental_date`,`inventory_id`,`customer_id`),
   KEY `idx_fk_inventory_id` (`inventory_id`),
   KEY `idx_fk_customer_id` (`customer_id`),
   KEY `idx_fk_staff_id` (`staff_id`)
   );

Drop table rental1;

-- 6a

SELECT S.first_name, S.last_name, A.address FROM staff AS S
INNER JOIN address AS A ON a.address_id = s.address_id;

-- 6b

SELECT S.first_name, S.last_name, SUM(p.amount) AS 'Rung Up' FROM staff AS S
LEFT JOIN payment AS p ON p.staff_id = s.staff_id
WHERE p.payment_date between '2005-08-01' AND '2005-08-31'
GROUP BY S.last_name;

-- 6c

SELECT f.title, count(fa.actor_id) AS 'actor_count' FROM film AS f
LEFT JOIN film_actor AS fa ON f.film_id = fa.film_id
GROUP BY f.film_id; 

-- 6d
SELECT f.title, count(i.inventory_id) AS 'inv_count' FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
GROUP BY f.film_id
HAVING f.title = 'Hunchback Impossible';

-- 6e

SELECT c.last_name, SUM(p.amount) AS 'total_payment' FROM customer AS c
LEFT JOIN payment AS p ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a
SELECT title FROM film
WHERE title LIKE ('K%')
AND language_id =(SELECT language_id FROM language
WHERE name = 'English')
UNION 
SELECT title FROM film
WHERE title LIKE ('Q%')
AND language_id =(SELECT language_id FROM language
WHERE name = 'English');

-- 7b

SELECT first_name, last_name FROM actor
Where actor_id IN (
SELECT actor_id FROM film_actor
Where film_id = (
SELECT film_id FROM film
Where title = 'Alone Trip'));

-- 7c

SELECT first_name, last_name, country, email FROM customer AS c
INNER JOIN address AS a ON a.address_id = c.address_id
INNER JOIN city AS ci ON ci.city_id = a.city_id
INNER JOIN country AS co On co.country_id = ci.country_id
Where country = 'Canada';

-- 7d

SELECT title FROM film 
Where film_id IN (
Select film_id FROM film_category
Where category_id = (
SELECT category_id FROM sakila.category
WHERE name = 'Family'));

-- 7e 

SELECT title,  count(*) AS 'Rented' FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
LEFT JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY title
ORDER BY Rented DESC;

-- 7f 
SELECT s.store_id, SUM(p.amount) AS 'total_payment (USD)' FROM  payment AS p 
LEFT JOIN store AS s ON s.manager_staff_id = p.staff_id
GROUP BY s.store_id;

-- 7g

SELECT s.store_id, c.city, co.country   FROM store AS s
LEFT JOIN address as a ON a.address_id = s.address_id
LEFT JOIN city as c ON a.city_id = c.city_id
LEFT JOIN country as co ON co.country_id = c.country_id
GROUP BY s.store_id;
-- 7h
SELECT c.name, sum(p.amount) as TOTAL FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN (SELECT DISTINCT film_id, inventory_id FROM inventory) AS i ON i.inventory_id = r.inventory_id
INNER JOIN film_category AS fc ON i.film_id = fc.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY TOTAL DESC
LIMIT 5;

-- 8a
CREATE VIEW TOP_GENRES AS 
SELECT c.name, sum(p.amount) as TOTAL FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN (SELECT DISTINCT film_id, inventory_id FROM inventory) AS i ON i.inventory_id = r.inventory_id
INNER JOIN film_category AS fc ON i.film_id = fc.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY TOTAL DESC
LIMIT 5;


-- 8b
SELECT * FROM TOP_GENRES;

-- 8c


DROP VIEW TOP_GENRES;



 