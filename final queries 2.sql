/* 1 */
SELECT DISTINCT p.* FROM products p INNER JOIN product_category pc ON p.id = pc.product_id INNER JOIN categories c ON pc.category_id = c.id WHERE ( c.slug ='books-and-movies' );

/* 2 */
SELECT o.id 'Order ID' , p.title 'Product Title', o.total_price 'Total Price', o.quantity 'Quantity', o.single_price 'Product Price' FROM orderitems o INNER JOIN orders o1 ON o.order_id = o1.id INNER JOIN products p ON o.product_id = p.id WHERE o.order_id = 7;

/* 3 */
SELECT o.id 'Order ID' , c.first_name 'Customer First Name' , c.last_name 'Customer Last Name' , o.verification 'Order Verification', a.state 'Order State' , a.city 'Order City' , a.address 'Order Address', a.phone_number 'Order Phone Number' , o.created_at 'Order Created', o.updated_at 'Order Last Update' FROM orders o INNER JOIN customers c ON o.customer_id = c.id INNER JOIN addresses a ON o.address_id = a.id WHERE o.verification = 'verified';

/* 4 */
SELECT c.first_name , c.last_name , o.id 'Order ID', c.email FROM customers c FULL OUTER JOIN orders o ON c.id = o.customer_id;

/* 5 - ( Order By default is ASC ) */
SELECT * FROM products p ORDER BY p.price;
SELECT * FROM products p ORDER BY p.price ASC; /* same results */ 

/* 6 Order by in Descending order*/
SELECT * FROM products p ORDER BY p.price DESC;

/* 7 Group By & SUM Function */
SELECT c.first_name ,c.last_name, SUM(o.total_price) 'Total Order' FROM customers c INNER JOIN orders o ON c.id = o.customer_id GROUP BY c.first_name , c.last_name;

/* 8 */
SELECT s.name 'Seller' ,SUM(o.total_price) 'Total Sales' FROM sellers s INNER JOIN products p ON s.id = p.seller_id INNER JOIN orderitems o ON p.id = o.product_id GROUP BY s.name;

/* 9 */
SELECT p.title , o.order_id FROM products p LEFT JOIN orderitems o ON p.id = o.product_id;

/* 10 */
SELECT p.id , p.title , r.title , r.content ,CONCAT_WS(' ',c.first_name,c.last_name) 'Customer Name' FROM reviews r RIGHT JOIN products p ON r.product_id = p.id LEFT JOIN customers c ON r.customer_id = c.id;

/* 11 */
SELECT s.name 'Seller Name',w.balance 'Latest Balance', w1.amount 'Widthraw Request Amount' , w1.status 'Request Verification Status' FROM wallets w INNER JOIN sellers s ON w.seller_id = s.id INNER JOIN withdraws w1 ON w.id = w1.wallet_id;

/* 12 */
SELECT s.name, SUM(w1.amount) 'Total Widthraw Request Amount' FROM wallets w INNER JOIN sellers s ON w.seller_id = s.id INNER JOIN withdraws w1 ON w.id = w1.wallet_id WHERE w1.status = 'verified' GROUP BY s.name ORDER BY 2 DESC;

/* 13 */
SELECT o.id 'Order ID' , o.customer_id 'Customer ID', p.bank_portal 'Purchase Bank Portal' , p.amount 'Purchase Amount' , p.status , o.payment FROM purchases p INNER JOIN orders o ON p.order_id = o.id WHERE (p.status = 'verified' AND o.payment = 'verified');

/* 14 */
SELECT t.id 'Ticket ID' ,CONCAT_WS(' ',c.first_name,c.last_name) 'Customer Name' , t.section 'Ticket Section' , t.priority 'Ticket Priority' , t.verified 'Verified' , t.solved 'Solved'  FROM tickets t INNER JOIN customers c ON t.customer_id = c.id WHERE (t.priority = 'high' AND t.solved = 0);

/* 15 */
SELECT t.id 'Ticket ID' ,CONCAT(c.first_name,' ',c.last_name) 'Customer Name' , t.section 'Ticket Section',t.content 'Ticket Content' , t.priority 'Ticket Priority' FROM tickets t INNER JOIN customers c ON t.customer_id = c.id WHERE t.verified = 0;

/* 16 */
SELECT * FROM coupons c WHERE c.expired_at < SYSDATETIME();
SELECT * FROM coupons c WHERE c.expired_at < '12/6/2021';
SELECT * FROM coupons c WHERE c.expired_at < '12/6/2021 12:00:00 AM';


/* 17 */
SELECT * FROM coupons c WHERE c.expired_at < SYSDATETIME();
SELECT c.id 'Customer ID' , c.first_name 'First Name' , c.last_name 'Last Name' , co.code 'Coupon Code' , co.amount 'Coupon Amount' FROM coupons co INNER JOIN customercoupons cc ON co.id = cc.coupon_id INNER JOIN customers c ON cc.customer_id = c.id;
SELECT c.id 'Customer ID' , c.first_name 'First Name' , c.last_name 'Last Name' , co.code 'Coupon Code' , co.amount 'Coupon Amount' , co.expired_at 'Copun Expire For Customer' FROM coupons co INNER JOIN customercoupons cc ON co.id = cc.coupon_id INNER JOIN customers c ON cc.customer_id = c.id WHERE cc.expired_at >= SYSDATETIME();
SELECT c.id 'Customer ID' , c.first_name 'First Name' , c.last_name 'Last Name' , co.code 'Coupon Code' , co.amount 'Coupon Amount' , co.expired_at 'Copun Expire For Customer' FROM coupons co INNER JOIN customercoupons cc ON co.id = cc.coupon_id INNER JOIN customers c ON cc.customer_id = c.id WHERE ( (cc.expired_at >= SYSDATETIME()) AND (cc.useable_count = 0));


/* 18 */
SELECT * FROM carts c WHERE c.active_cart = 1;
SELECT * FROM carts c WHERE c.second_cart = 1;
SELECT * FROM carts c WHERE c.count > 10;
SELECT * FROM carts c WHERE (c.coupon_id IS NOT NULL) AND (c.active_cart = 1);
SELECT * FROM carts c WHERE (c.second_cart = 1 AND c.active_cart = 1); /* Should Return Empty Set ( No Results ) */
SELECT c.id 'Cart Item ID' ,p.title 'Item Title' , c1.id 'Cart ID' , CONCAT_WS(' ',c2.first_name,c2.last_name) 'Customer Name', c2.id 'Customer ID' , c1.active_cart 'Active Cart' , c1.second_cart 'Second Cart'  FROM cartitems c LEFT JOIN carts c1 ON c.cart_id = c1.id RIGHT JOIN customers c2 ON c1.customer_id = c2.id INNER JOIN products p ON c.product_id = p.id;


/* 19 */
SELECT * FROM categories c;
SELECT * FROM categories c WHERE c.parent_id = 2;

/* 20 */
WITH
categories_subtree AS (
  SELECT id, title, parent_id
  FROM categories 
  WHERE id = 13 /* Parent Category ID */
  UNION ALL
  SELECT c.id, c.title, c.parent_id
  FROM categories_subtree sub
  JOIN categories c on c.parent_id = sub.id
)
SELECT
  c.id,
  c.title,
  c.parent_id
FROM categories_subtree c;


/* 21 */
WITH 
cs AS (SELECT CONCAT_WS(' - ',c.first_name,c.last_name) person_name , c.email , type = 'customer' FROM customers c),
sl AS (SELECT s.owner_name person_name , s.email , type = 'seller' FROM sellers s),
us AS (SELECT CONCAT_WS(' - ',u.first_name,u.last_name) person_name , u.email , type = 'user' FROM users u)
SELECT cs.person_name , cs.email , type FROM cs 
UNION ALL 
SELECT sl.person_name , sl.email , type FROM sl 
UNION ALL 
SELECT us.person_name , us.email , type FROM us;

/* 22 */
WITH 
cs AS (SELECT CONCAT_WS(' - ',c.first_name,c.last_name) person_name , c.email , type = 'customer' FROM customers c),
sl AS (SELECT s.owner_name person_name , s.email , type = 'seller' FROM sellers s),
us AS (SELECT CONCAT_WS(' - ',u.first_name,u.last_name) person_name , u.email , type = 'user' FROM users u),
main AS (SELECT cs.person_name , cs.email , type FROM cs 
UNION ALL 
SELECT sl.person_name , sl.email , type FROM sl 
UNION ALL 
SELECT us.person_name , us.email , type FROM us
) SELECT * FROM main ORDER BY main.person_name;

/* 23 */

WITH 
cs AS (SELECT CONCAT_WS(' - ',c.first_name,c.last_name) person_name , c.email , type = 'customer' FROM customers c),
sl AS (SELECT s.owner_name person_name , s.email , type = 'seller' FROM sellers s),
us AS (SELECT CONCAT_WS(' - ',u.first_name,u.last_name) person_name , u.email , type = 'user' FROM users u),
main AS (SELECT cs.person_name , cs.email , type FROM cs 
UNION ALL 
SELECT sl.person_name , sl.email , type FROM sl 
UNION ALL 
SELECT us.person_name , us.email , type FROM us
) SELECT m.person_name, STRING_AGG(CONVERT(NVARCHAR(max) , m.type),' , ') FROM main m GROUP BY m.person_name;

/* 24 */
SELECT * FROM most_recommended_products p ORDER BY 3 DESC; /* using views */

/* 25 */
SELECT ut.id 'Ticket ID' , CONCAT_WS(' - ',c.first_name,c.last_name) 'Customer Name' FROM unsolved_tickets ut INNER JOIN customers c ON ut.customer_id = c.id; /* using views */