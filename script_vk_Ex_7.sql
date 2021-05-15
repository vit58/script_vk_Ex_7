-- УРОК 7 СЛОЖНЫЕ ЗАПРОСЫ

-- ДЗ 7-2 Выведите список товаров products и разделов catalogs, который соответствует товару.
-- Выведем список всех товаров в разделе «Процессоры».
 
/*В таблице РАЗДЕЛОВ catalogs (список) каталогов указаны id и соотвествующие им разделы.
Процессоры id = 1 и соответствующий catalog_id = 1 таблицы products).  
В разделе Процессоры представлены ТИПЫ процессоров (товары). И конечно, для них всех catalog_id = 1  

-- Решение ВЛОЖЕННЫЕ ЗАПРОСЫ
SELECT * FROM catalogs; -- Таблица catalogs связана через внешний ключ catalog_id 
-- с таблицей товарных позиций products.
SELECT * FROM products;
desc products;
select id, name, catalog_id -- вывести эти три столбца 
from products -- из таблицы products
where catalog_id = (SELECT id FROM catalogs WHERE name = "Процессоры"); -- НО вывести только те строки, Где catalog_id = (Найти id из табл., catalogs соответствующий name = "Процессоры" )

 */

-- Решение JOIN
select catalogs.id, catalogs.name as catalogs_name, products.name as products_name
from catalogs inner join products
on catalogs.id = products.catalog_id;


-- ДЗ 7-1 Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
/*
-- Неявный JOIN с условием 
SELECT users.*, orders.*
  FROM users, orders
  WHERE users.id = orders.user_id;--  Т.е. Нам нужны не ВСЕ строки, только те, у которых (в обеих табл.) есть совпадение по id. 
  -- И .user_id - ссылка на человека, выполнившего этот заказ. Т.е. получили табл. заказчиков-пользотелей, и соотвествующих им заказов.
*/

SELECT * FROM users limit 10;
SELECT * FROM orders limit 10;
SELECT users.id, users.first_name, users.last_name, orders.user_id
  FROM users CROSS JOIN orders
  on users.id = orders.user_id;


 
 



-- УРОК 7 СЛОЖНЫЕ ЗАПРОСЫ (ВЛОЖЕННЫЕ ЗАПРОСЫ)

 /*Объединение UNION
 Важное условие — совпадение всех параметров результирующих запросов. 
 Количество, порядок следования и тип столбцов , т.е. структура таблицы должны совпадать. 
  */

 DROP TABLE IF EXISTS rubrics;
CREATE TABLE rubrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO rubrics VALUES
  (NULL, 'Видеокарты'),
  (NULL, 'Память');
 desc rubrics;

-- Объединим две таблицы
SELECT * FROM rubrics;
SELECT * FROM catalogs;

-- Для получения УНИКАЛЬНЫХ значений используем краткую форму UNION, хотя могли бы писать UNION DISTINCT.
SELECT name FROM catalogs
union -- в результирующий запрос попадают только не повторяющиеся результаты. 
-- Повторяющиеся представлены в единственном экземпляре
SELECT name FROM rubrics;

-- Что результатом объединения были ВСЕ записи, используем UNION ALL
SELECT name FROM catalogs
UNION ALL
SELECT name FROM rubrics
ORDER BY name-- Сортировка, она действует на весь результат запроса, а не на отдельные таблицы.
-- Для обратного порядка: ORDER BY name DESC;
LIMIT 2;-- Сначала происходит объединение результатов и лишь затем применяется ограничение limit
-- Если структура таблиц не совпадает, объединить их при помощи UNION не получится.

SELECT * FROM catalogs;
SELECT * FROM products;
-- Однако, мы можем объеденить, совпадающие столбцы
SELECT * FROM catalogs-- Следует иметь в виду, что первый SELECT-запрос определяет название столбцов.
UNION
SELECT id, name FROM products;
/*
 * после ключевого слова SELECT следует указывать только те столбцы, которые нужны в результирующей таблице
 *  или для составления запроса.
 * 
 * 	 
/*
 * ВЛОЖЕННЫЕ ЗАПРОСЫ
Вложенный запрос позволяет использовать результат, возвращаемый одним запросом, в другом.
Чтобы СУБД могла отличать основной запрос и подзапрос, последний заключают в круглые скобки.
 */

-- ДЗ 7-2 Выведите список товаров products и разделов catalogs, который соответствует товару.
-- Выведем список всех товаров в разделе «Процессоры».
 
/*В таблице РАЗДЕЛОВ catalogs (список) каталогов указаны id и соотвествующие им разделы.
Процессоры id = 1 и соответствующий catalog_id = 1 таблицы products).  
В разделе Процессоры представлены ТИПЫ процессоров (товары). И конечно, для них всех catalog_id = 1  
 */

SELECT * FROM catalogs; -- Таблица catalogs связана через внешний ключ catalog_id 
-- с таблицей товарных позиций products.
SELECT * FROM products;
desc products;
select id, name, catalog_id -- вывести эти три столбца 
from products -- из таблицы products
where catalog_id = (SELECT id FROM catalogs WHERE name = "Процессоры"); -- НО вывести только те строки, 
-- где catalog_id = (Найти id из табл., catalogs соответствующий name = "Процессоры" )

-- Возможно решать целый спектр задач. Например, найдем в таблице products товар с самой высокой ценой. 
SELECT
  id, name, catalog_id
FROM
  products
where
-- сформируем вложенный запрос
-- price = (SELECT MAX(price) FROM products)-- найдем максимальную цену при помощи функции MAX()
-- можно использовать не только оператор равенства, но и любой другой логический оператор. 
  price < (SELECT AVG(price) FROM products); -- найдем все товары, чья цена ниже среднего
  
  
 -- Для каждого из товаров извлечем название каталога
  select
-- Так пишем воизбежание конфликтов, используем кваликафикационные имена
  products.id,-- а можем написать просто id, 
  products.name,-- и так - name 
  (SELECT
 	catalogs.name-- и так - name
   FROM
 	catalogs
   WHERE
 	catalogs.id = products.catalog_id) AS 'catalog'-- и так - id = catalog_id
FROM
  products;
 
 /*
 Это были вложенные запросы, которые всегда возвращали лишь одно значение. 
Попробуем передать несколько. Чтобы воспользоваться вложенным запросом в таких условиях, 
нам потребуется воспользоваться специальными ключевыми словами, например, IN
 */
 SELECT
  id, name, catalog_id
FROM
  products
WHERE
  catalog_id IN (SELECT id FROM catalogs); -- Вложенный запрос - аналог catalog_id IN (1, 2)
 /*
  * IN - используется, если необходимо применить оператор равенства в отношении множеств.
  * ANY - для реализации сравнений (логические операторы: больше, меньше, больше-равно, меньше-равно). 
  * 
  * Выясним, есть ли среди товаров раздела «Материнские платы» товарные позиции, 
  * которые дешевле любой позиции из раздела «Процессоры».
  */
   SELECT
  id, name, price, catalog_id
FROM
  products
WHERE
  catalog_id = 2 AND
  price < ANY (SELECT price FROM products WHERE catalog_id = 1);
 /*
  * Результирующая таблица, которая возвращается вложенным запросом, может быть пустой, 
  * т. е., не содержать ни одной строки. Для проверки этого используются ключевые слова EXISTS и NOT EXISTS.
  */
 --  Извлечем те разделы каталога, для которых есть хотя бы одна товарная позиция:
 SELECT * FROM catalogs
 WHERE EXISTS (SELECT * FROM products WHERE catalog_id = catalogs.id);

-- Допускается использование отрицания NOT EXISTS. Извлечем каталоги, для которых нет ни одной товарной позиции:
SELECT * FROM catalogs
WHERE NOT EXISTS (SELECT 1 FROM products WHERE catalog_id = catalogs.id);

 /*
  * До сих пор рассматривались вложенные запросы, возвращающие единственный столбец. 
  * Однако в СУБД MySQL реализованы так называемые строчные запросы, которые возвращают более одного столбца.
  */
 SELECT id, name, price, catalog_id FROM products
WHERE (catalog_id, 5060.00) IN (SELECT id, price FROM catalogs);-- Выражение в скобках перед IN называется конструктором строки


-- Про FROM до конца НЕ ОСОЗНАЛ!!! (см. Методичку)

  


 */