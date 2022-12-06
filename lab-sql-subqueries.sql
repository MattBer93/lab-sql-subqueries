-- lab-sql-subqueries
use sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
select i.film_id, count(i.inventory_id) as count 
from inventory i
-- join film f using(film_id) 
where i.film_id = (
	select film_id 
	from film
	where title = 'Hunchback Impossible')
group by film_id;

-- List all films whose length is longer than the average of all the films.
select * from film;

select * from film
where length > (
	select avg(length) as average 
	from film
);

-- Use subqueries to display all actors who appear in the film Alone Trip.
-- Q: In subqueries we don't need to do joins?

-- 1st step | finding the film_id
select film_id from film
where title = 'Alone Trip';

-- 2nd step | finding the list of actor IDs that worked in that movie
select actor_id from film_actor
where film_id = (
	select film_id from film
	where title = 'Alone Trip'
);

-- final step | displaying full name of actors in list above
select first_name, last_name
from actor
where actor_id in (
	select actor_id from film_actor
	where film_id = (
		select film_id from film
		where title = 'Alone Trip'
	)
);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

-- 1. Find the category ID
select category_id from category
where name = 'Family';

-- 2. Find film IDs
select film_id from film_category
where category_id = (
	select category_id from category
	where name = 'Family'
);

-- 3. List all film names with those IDs
select title from film
where film_id in (
	select film_id from film_category
	where category_id = (
		select category_id from category
		where name = 'Family'
	)
);


-- Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

-- SUBQUERIES
-- 1. Find ID for Canada
select country_id from country
where country = "Canada";

-- 2. Find all cities that are in Canada
select city_id from city
where country_id = (
	select country_id from country
	where country = "Canada"
);

-- 3. Find all addresses that are in the list of cities above
select address_id from address
where city_id in (
	select city_id from city
	where country_id = (
		select country_id from country
		where country = "Canada"
	)
);

select first_name, last_name, email from customer
where address_id in (
	select address_id from address
	where city_id in (
		select city_id from city
		where country_id = (
			select country_id from country
			where country = "Canada"
		)
	)
);

-- JOINS
select first_name, last_name, email from customer
join address using(address_id)
join city using(city_id) 
join country using(country_id) 
where country = 'Canada';


-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- 1. Find most prolific actor
-- create table if not exists most_prolific
select actor_id from film_actor
group by actor_id
order by count(film_id) desc
limit 1;

select distinct film_id, title from film_actor
join film using(film_id)
where actor_id = (
	select actor_id from film_actor
	group by actor_id
	order by count(film_id) desc
	limit 1
);


-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the 
-- largest sum of payments
-- Do just sum of payments instead of count films
select customer_id from payment
group by customer_id
order by sum(amount)
limit 1;

select customer_id, first_name, last_name, sum(amount) as total from customer
join payment using(customer_id)
where customer_id = (
	select customer_id from payment
	group by customer_id
	order by sum(amount)
	limit 1
)
group by customer_id;


-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

-- 1. Find average of total_amount spent by each client 
select avg(amount)
from payment;

select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having sum(amount) > (
	select avg(amount)
	from payment
)
order by sum(amount);



















