USE sakila;

##------------------PARTE 1----------------------##
##  FILTRAR  LOS NOMBRES Y APELLIDOS DE COUSTUMER (CLIENTES)
SELECT first_name, last_name FROM customer;

## SELECCIONA TODAS LAS PELICULAS QUE SU LENGTH (DURACION) SEA MAYOR A 120 MIN
SELECT * FROM film WHERE length > 120;


##------------------PARTE 2----------------------##
## SELECIONA TODAS LAS COLUMNAS DE CUSTOMER, Y ME LAS ORDENA POR APELLIDO DE MANERA ASCENDENTE (A -> Z)
SELECT * FROM customer
ORDER BY last_name ASC;

## SELECCIONA TODA LAS PELICULAS Y SE ORDENA DE FORMA DECENDENTE LAS 5 MAS LARGAS ORDENADAS DE MAYOR A MENOR POR LA DURACION DE CADA UNA Y 
SELECT * FROM film ORDER BY length DESC LIMIT 5;

##------------------PARTE 3----------------------##

## SELECCIONA Y RELACIONA LOS NOMBRES, APELLIDOS, CANTIDAD Y FECHA DE PAGO, DE LAS COLUMNAS DE CLIENTE Y PAGOS Y SE UNENE POR MEDIO DE LA COLUMNA PRINCIPAL DE CUSTOMER_id
SELECT 
    first_name,
    last_name,
    amount,
    payment_date
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id;

##SELECCIONA Y RELACIONA LO QUE ES LAS RENTADAS, CON EL INVENTARIO Y LA PELICULA, SE RELACIONAN LAS RENTADAS CON LAS DE INVENTARIO OR MEDIO DE INVENTORI_ID Y DE LAS PELUCLAS A LAS QEU ESTAN INVENTARIO SON FILM_ID
SELECT 
    rental_id,
    title,
    rental_date
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id;


##------------------PARTE 4----------------------##
## RELACIONA LOS NOMBRES Y APELLIDOS DE LOS CLIENTES QEU NO TIENEN PAGOS, AL REALIZAR ESTO SE EVIDENCIA QUE NO CUENTA CON CLIENTES SIN PAGOS, PARA CONFIRMAS ESTO SE HACE OTRO SELEC QUE CUENTA CUANTAS PERSONAS NO TIENE NPAGOS A LO QUE NOS DA QEU ES 0
SELECT 
    first_name,
    last_name
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
WHERE payment.payment_id IS NULL;
SELECT COUNT(*) 
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
WHERE payment.payment_id IS NULL;


## SELECCIONA LOS NOMBRES DE LAS PELICULAS Y LA DURACION  LOS COMPARA POR EL FILM_ID, Y DESPUES SI EN LA COLUMNA DE ACTOR_id NO ENCUENTRA NADA, USA ESE TITULO Y DURACION PARA PODER OBSERVARLO 
SELECT 
    film.title,
    film.length
FROM film
LEFT JOIN film_actor
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IS NULL;


##------------------PARTE 5----------------------##
## SE INTODUCE UN NUEVO NOMBRE DE ACTOR, SE ACTUALIZA POR OTRO, Y ELIMINA EN ESTE CASO EL USUARIO EN EL ID 201
INSERT INTO actor (first_name, last_name)
VALUES ('JUAN F','ORTIZ');

UPDATE actor
 SET 
first_name = 'CAMILO',
last_name = 'SANCHEZ'
WHERE actor_id = '201';


START TRANSACTION; 
DELETE FROM actor
WHERE actor_id = 201;
SELECT * FROM Actor
COMMIT;

##------------------PARTE 5----------------------##

## SE SELECIONA LOS USUARIOS, SE UNE CON LA TABLA DE PAGOS, POR MEDIO DE CUSTOMER_ID SE ASOCIAN ESTOS DOS, SE AGRUPA  Y SE ORDENA POR MEDIO DE UNA SUMA DE LO ENCONTRADO EN CADA UNO DE LOS CLIENTES
SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS total_pagado
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY total_pagado DESC
LIMIT 5;

## SE SELECIONA LA PELICULA,  SE UNE CON LA TABLA DE INVENTARIO, POR MEDIO DE INVENTORY_ID SE ASOCIAN ESTOS DOS, Y SE ASOCIA TAMBIEN CON 
SE AGRUPA POR MEIO DEL FILM_ID Y SE GENERA UN NUEVO GRUPO DE LAS VECES QUE FUE ALQUILADA
SELECT 
    film.title,
    COUNT(rental.rental_id) AS veces_alquilada
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
GROUP BY film.film_id
ORDER BY veces_alquilada DESC
LIMIT 5;