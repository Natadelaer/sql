--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============
--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.

select payment_id, payment_date, amount 
from payment 
where payment_date between '2005-06-17' and '2005-06-20' and amount > 1.00 
order by payment_date;

--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.

select lower(last_name), lower(first_name), active 
from customer
where (first_name = 'kelly' or first_name = 'willie') and active = 1;


--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква строки должна быть заглавной, остальные строчными.

select customer_id, email as "full email",
    concat(upper(left(email, 1)), lower(substring(email, 2, position('@' in email) - 1))) as "email before @", 
    concat(upper(substring(email, position('@' in email) + 1, 1)), lower(right(email, length(email) - position('@' in email)))) as "email after @"
from customer;



