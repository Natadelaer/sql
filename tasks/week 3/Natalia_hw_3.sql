SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select concat (last_name, ' ', first_name) as "Сustomer name", a.address, city.city, c2.country
from customer c
join address a on c.address_id = a.address_id
join city on a.city_id  = city.city_id
join country c2 on city.country_id = c2.country_id;

--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.


select  store.store_id, count(customer.customer_id) as customer_count
from store
join customer on store.store_id = customer.store_id
group by store.store_id;

--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

 
select store.store_id as "ID покупателя", count(customer.customer_id) as "Количество покупателей"
from store
join staff on store.manager_staff_id = staff.staff_id
join customer on store.store_id = customer.store_id
group by store.store_id
having count(customer.customer_id) > 300;



-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select store.store_id as "ID покупателя", count(customer.customer_id) as "Количество покупателей", city.city as "город", concat (staff.last_name, ' ', staff.first_name) as "Имя сотрудника"
from store
join staff on store.manager_staff_id = staff.staff_id
join customer on store.store_id = customer.store_id
join address a  on store.address_id  = a.address_id
join city on a.city_id  = city.city_id
group by store.store_id, city.city, "Имя сотрудника"
having count(customer.customer_id) > 300;


--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select concat(customer.last_name, ' ', customer.first_name) as "Фамилия и имя покупателя", count(rental.rental_id) as "Количество фильмов"
from customer
join rental on customer.customer_id = rental.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
order by "Количество фильмов" desc
limit 5;


--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма


select 
    concat(customer.last_name, ' ', customer.first_name) as "Фамилия и имя покупателя",
    count(rental.rental_id) as "Количество фильмов",
    round(sum(payment.amount), 0) as "Общая стоимость платежей",
    min(payment.amount) as "Минимальная стоимость платежа",
    max(payment.amount) as "Максимальная стоимость платежа"
from rental
join payment on rental.rental_id = payment.rental_id
join customer on rental.customer_id = customer.customer_id 
group by "Фамилия и имя покупателя";


--ЗАДАНИЕ №5
--Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы 
--в результате не было пар с одинаковыми названиями городов. Решение должно быть через Декартово произведение.
 
select c1.city as "Город 1", c2.city as "Город 2"
from city c1
cross join city c2
where c1.city <> c2.city;


--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и 
--дате возврата (поле return_date), вычислите для каждого покупателя среднее количество 
--дней, за которые он возвращает фильмы. В результате должны быть дробные значения, а не интервал.

select customer_id as "ID покупателя" ,
    round(avg(extract(epoch from return_date - rental_date) / 86400)::numeric, 2 )  as "Среднее количество дней на возврат"
from rental
group by customer_id
order by customer_id;

-- если честно, я не два дня тыкалась и пришла к такому
-- я до сих пор не понимаю, почему у меня расходится решение с ответами на сотые.
-- вроде бы я и формат учла, и что дробные :с


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

select
    film.title as "Название фильма",
    film.rating as "Рейтинг",
    c."name" as "Жанр",
    film.release_year as "Год выпуска", 
    l."name" as "Язык",
    count(rental.rental_id) as "Количество аренд",
    sum(payment.amount) as "Общая стоимость аренды"
from
    rental
    inner join inventory on rental.inventory_id = inventory.inventory_id
    inner join film on inventory.film_id = film.film_id
    inner join payment on rental.rental_id = payment.rental_id
    inner join "language" l on film.language_id = l.language_id 
    inner join film_category fc on film.film_id = fc.film_id 
    inner join category c on fc.category_id = c.category_id 
group by
    film.title, 
    film.rating,
    film.release_year,
    l."name",
    c."name"
order by
    film.title;



--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью него фильмы, которые отсутствуют на dvd дисках.


select
    film.title as "Название фильма",
    film.rating as "Рейтинг",
    c."name" as "Жанр",
    film.release_year as "Год выпуска", 
    l."name" as "Язык",
    count(rental.rental_id) as "Количество аренд",
    sum(payment.amount) as "Общая стоимость аренды"
from
    film
    left join inventory on film.film_id = inventory.film_id
    left join rental on inventory.inventory_id = rental.inventory_id
    left join payment on rental.rental_id = payment.rental_id
    left join "language" l on film.language_id = l.language_id 
    left join film_category fc on film.film_id = fc.film_id 
    left join category c on fc.category_id = c.category_id 
where
    inventory.inventory_id is null
group by
    film.title, 
    film.rating,
    film.release_year,
    l."name",
    c."name"
order by
    film.title;


--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".
   
select staff_id, count(payment.payment_id) as "Количество продаж",
  case
  	when count(payment.payment_id) > 7300 then 'Да'
  	else 'Нет'
    end as "Премия"
from
    payment
group by
    staff_id;





