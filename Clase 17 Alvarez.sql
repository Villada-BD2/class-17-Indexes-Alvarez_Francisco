-- ejercicio 1
select a.address_id, a.address, a.postal_code, c.city, co.country
from address a
join city c on a.city_id = c.city_id
join country co on c.country_id = co.country_id
where a.postal_code in ('17886', '83579', '53561');

select * 
from address 
where postal_code not in ('17886', '83579', '53561');


create index idx_postal_code on address(postal_code);

-- prueba 2:
select a.address_id, a.address, a.postal_code, c.city, co.country
from address a
join city c on a.city_id = c.city_id
join country co on c.country_id = co.country_id
where a.postal_code in ('17886', '83579', '53561');


/*
EXPLICACION:
antes de meter el indice en postal_code la consulta tarda mas porque mysql no le queda otra que hacer un escaneo completo revisando fila por fila en toda la tabla address. 
despues metemos el CREATE INDEX idx_postal_code ON address(postal_code); y cuando volvemos a correr la query baja el tiempo de ejecucion de toque. 
esto pasa porque mysql consulta directamente el arbol del indice btree, donde ubica las filas exactas en memoria y no escanea las 603 filas completas del atr address.
*/



-- ejercicio 2

select * from actor where first_name = 'DAN';

select * from actor where last_name = 'TORN';

explain select * from actor where first_name = 'DAN';
explain select * from actor where last_name = 'TORN';

/*
EXPLICACION EJERCICIO 2:
la diferencia entre buscar por first_name y last_name es que la tabla actor ya traia un indice llamado idx_actor_last_name en la columna last_name.
al hacer EXPLAIN select... cuando filtramos por last_name la columna type devuelve ref y usa el indice asi que va directo al registro. 
en cambio al buscar por first_name (first_name no tiene ningun indice pre-creado)la columna type devuelve ALL lo que significa que mysql tuvo que hacer el escaneo completo y leer la tabla entera para encontrar los resultados.
*/



-- ejercicio 3

-- LIKE:
select film_id, title, description 
from film 
where description like '%epic%';

-- MATCH y AGAINST:
select film_id, title, description 
from film_text 
where match(title, description) against('epic');

/*
EXPLICACION EJERCICIO 3:
la busqueda con "LIKE" busca coincidencia patron por patron o substring por lo que obliga a recorrer toda la columna de la tabla y no puede ordenar por que tan relevante es la palabra. 
Por otro lado, "film_text" utiliza un índice FULLTEXT con MATCH AGAINST, que permite buscar palabras dentro del índice sin tener que recorrer toda la tabla, lo que puede mejorar considerablemente el rendimiento en búsquedas de texto.
ademas MATCH AGAINST devuelve los resultados ordenados por relevancia de coincidencia cosa que con LIKE no se puede hacer.
*/