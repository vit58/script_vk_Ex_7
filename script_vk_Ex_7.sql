-- ���� 7 ������� �������

-- �� 7-2 �������� ������ ������� products � �������� catalogs, ������� ������������� ������.
-- ������� ������ ���� ������� � ������� ������������.
 
/*� ������� �������� catalogs (������) ��������� ������� id � �������������� �� �������.
���������� id = 1 � ��������������� catalog_id = 1 ������� products).  
� ������� ���������� ������������ ���� ����������� (������). � �������, ��� ��� ���� catalog_id = 1  

-- ������� ��������� �������
SELECT * FROM catalogs; -- ������� catalogs ������� ����� ������� ���� catalog_id 
-- � �������� �������� ������� products.
SELECT * FROM products;
desc products;
select id, name, catalog_id -- ������� ��� ��� ������� 
from products -- �� ������� products
where catalog_id = (SELECT id FROM catalogs WHERE name = "����������"); -- �� ������� ������ �� ������, ��� catalog_id = (����� id �� ����., catalogs ��������������� name = "����������" )

 */

-- ������� JOIN
select catalogs.id, catalogs.name as catalogs_name, products.name as products_name
from catalogs inner join products
on catalogs.id = products.catalog_id;


-- �� 7-1 ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.
/*
-- ������� JOIN � �������� 
SELECT users.*, orders.*
  FROM users, orders
  WHERE users.id = orders.user_id;--  �.�. ��� ����� �� ��� ������, ������ ��, � ������� (� ����� ����.) ���� ���������� �� id. 
  -- � .user_id - ������ �� ��������, ������������ ���� �����. �.�. �������� ����. ����������-�����������, � �������������� �� �������.
*/

SELECT * FROM users limit 10;
SELECT * FROM orders limit 10;
SELECT users.id, users.first_name, users.last_name, orders.user_id
  FROM users CROSS JOIN orders
  on users.id = orders.user_id;


 
 



-- ���� 7 ������� ������� (��������� �������)

 /*����������� UNION
 ������ ������� � ���������� ���� ���������� �������������� ��������. 
 ����������, ������� ���������� � ��� �������� , �.�. ��������� ������� ������ ���������. 
  */

 DROP TABLE IF EXISTS rubrics;
CREATE TABLE rubrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������'
) COMMENT = '������� ��������-��������';

INSERT INTO rubrics VALUES
  (NULL, '����������'),
  (NULL, '������');
 desc rubrics;

-- ��������� ��� �������
SELECT * FROM rubrics;
SELECT * FROM catalogs;

-- ��� ��������� ���������� �������� ���������� ������� ����� UNION, ���� ����� �� ������ UNION DISTINCT.
SELECT name FROM catalogs
union -- � �������������� ������ �������� ������ �� ������������� ����������. 
-- ������������� ������������ � ������������ ����������
SELECT name FROM rubrics;

-- ��� ����������� ����������� ���� ��� ������, ���������� UNION ALL
SELECT name FROM catalogs
UNION ALL
SELECT name FROM rubrics
ORDER BY name-- ����������, ��� ��������� �� ���� ��������� �������, � �� �� ��������� �������.
-- ��� ��������� �������: ORDER BY name DESC;
LIMIT 2;-- ������� ���������� ����������� ����������� � ���� ����� ����������� ����������� limit
-- ���� ��������� ������ �� ���������, ���������� �� ��� ������ UNION �� ���������.

SELECT * FROM catalogs;
SELECT * FROM products;
-- ������, �� ����� ����������, ����������� �������
SELECT * FROM catalogs-- ������� ����� � ����, ��� ������ SELECT-������ ���������� �������� ��������.
UNION
SELECT id, name FROM products;
/*
 * ����� ��������� ����� SELECT ������� ��������� ������ �� �������, ������� ����� � �������������� �������
 *  ��� ��� ����������� �������.
 * 
 * 	 
/*
 * ��������� �������
��������� ������ ��������� ������������ ���������, ������������ ����� ��������, � ������.
����� ���� ����� �������� �������� ������ � ���������, ��������� ��������� � ������� ������.
 */

-- �� 7-2 �������� ������ ������� products � �������� catalogs, ������� ������������� ������.
-- ������� ������ ���� ������� � ������� ������������.
 
/*� ������� �������� catalogs (������) ��������� ������� id � �������������� �� �������.
���������� id = 1 � ��������������� catalog_id = 1 ������� products).  
� ������� ���������� ������������ ���� ����������� (������). � �������, ��� ��� ���� catalog_id = 1  
 */

SELECT * FROM catalogs; -- ������� catalogs ������� ����� ������� ���� catalog_id 
-- � �������� �������� ������� products.
SELECT * FROM products;
desc products;
select id, name, catalog_id -- ������� ��� ��� ������� 
from products -- �� ������� products
where catalog_id = (SELECT id FROM catalogs WHERE name = "����������"); -- �� ������� ������ �� ������, 
-- ��� catalog_id = (����� id �� ����., catalogs ��������������� name = "����������" )

-- �������� ������ ����� ������ �����. ��������, ������ � ������� products ����� � ����� ������� �����. 
SELECT
  id, name, catalog_id
FROM
  products
where
-- ���������� ��������� ������
-- price = (SELECT MAX(price) FROM products)-- ������ ������������ ���� ��� ������ ������� MAX()
-- ����� ������������ �� ������ �������� ���������, �� � ����� ������ ���������� ��������. 
  price < (SELECT AVG(price) FROM products); -- ������ ��� ������, ��� ���� ���� ��������
  
  
 -- ��� ������� �� ������� �������� �������� ��������
  select
-- ��� ����� ����������� ����������, ���������� ������������������ �����
  products.id,-- � ����� �������� ������ id, 
  products.name,-- � ��� - name 
  (SELECT
 	catalogs.name-- � ��� - name
   FROM
 	catalogs
   WHERE
 	catalogs.id = products.catalog_id) AS 'catalog'-- � ��� - id = catalog_id
FROM
  products;
 
 /*
 ��� ���� ��������� �������, ������� ������ ���������� ���� ���� ��������. 
��������� �������� ���������. ����� ��������������� ��������� �������� � ����� ��������, 
��� ����������� ��������������� ������������ ��������� �������, ��������, IN
 */
 SELECT
  id, name, catalog_id
FROM
  products
WHERE
  catalog_id IN (SELECT id FROM catalogs); -- ��������� ������ - ������ catalog_id IN (1, 2)
 /*
  * IN - ������������, ���� ���������� ��������� �������� ��������� � ��������� ��������.
  * ANY - ��� ���������� ��������� (���������� ���������: ������, ������, ������-�����, ������-�����). 
  * 
  * �������, ���� �� ����� ������� ������� ������������ ������ �������� �������, 
  * ������� ������� ����� ������� �� ������� ������������.
  */
   SELECT
  id, name, price, catalog_id
FROM
  products
WHERE
  catalog_id = 2 AND
  price < ANY (SELECT price FROM products WHERE catalog_id = 1);
 /*
  * �������������� �������, ������� ������������ ��������� ��������, ����� ���� ������, 
  * �. �., �� ��������� �� ����� ������. ��� �������� ����� ������������ �������� ����� EXISTS � NOT EXISTS.
  */
 --  �������� �� ������� ��������, ��� ������� ���� ���� �� ���� �������� �������:
 SELECT * FROM catalogs
 WHERE EXISTS (SELECT * FROM products WHERE catalog_id = catalogs.id);

-- ����������� ������������� ��������� NOT EXISTS. �������� ��������, ��� ������� ��� �� ����� �������� �������:
SELECT * FROM catalogs
WHERE NOT EXISTS (SELECT 1 FROM products WHERE catalog_id = catalogs.id);

 /*
  * �� ��� ��� ��������������� ��������� �������, ������������ ������������ �������. 
  * ������ � ���� MySQL ����������� ��� ���������� �������� �������, ������� ���������� ����� ������ �������.
  */
 SELECT id, name, price, catalog_id FROM products
WHERE (catalog_id, 5060.00) IN (SELECT id, price FROM catalogs);-- ��������� � ������� ����� IN ���������� ������������� ������


-- ��� FROM �� ����� �� �������!!! (��. ���������)

  


 */