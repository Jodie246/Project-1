use magist;

#What categories of tech products does Magist have?
SELECT 
    pcnt.product_category_name_english as category,
    round(sum(oi.price)) as price
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
GROUP BY pcnt.product_category_name_english
order by sum(oi.price) desc;


#How many products of these tech categories have been sold (within the time window of the database snapshot)?
select count(distinct p.product_id)
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
      WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
        
#What percentage does that represent from the overall number of products sold?       
select (SELECT 
    count(distinct oi.product_id)
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
    WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')) as tech,

(Select 
count(distinct p.product_id)
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id)
         as NonTech,
   (select tech / nontech *100) as percentage;
   
   
#What’s the average price of the products being sold?
SELECT 
    round(avg(oi.price)) as avg_price
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
    WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
        
#Are expensive tech products popular?
SELECT 
    
case
when avg(oi.price) > 1000 then 'Expensive'
else 'Not Expensive' end as 'expensive',
case
when count(p.product_id) > 1000 then 'High Sales'
else 'Low Sales' end as 'expensive',         
    pcnt.product_category_name_english,
    round(avg(oi.price)) as price,
    count(p.product_id)
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
GROUP BY pcnt.product_category_name_english
order by sum(oi.price) desc;

#How many months of data are included in the magist database?
SELECT 

datediff(max(o.order_purchase_timestamp) ,min(o.order_purchase_timestamp)) as daysinbetween,
count(distinct month(o.order_purchase_timestamp), year(o.order_purchase_timestamp)) as Months
FROM
    orders o 
    union all
SELECT 
    DATEDIFF(MAX(order_purchase_timestamp),
            MIN(order_purchase_timestamp)) AS daysinbetween,
    COUNT(DISTINCT MONTH(order_purchase_timestamp),
        YEAR(order_purchase_timestamp)) AS Months
FROM orders;

#How many sellers are there?
SELECT 
count(distinct seller_id)
FROM
    sellers
    
    
#How many Tech sellers are there?
SELECT 
count(distinct s.seller_id)
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
	INNER JOIN 
    sellers s on oi.seller_id = s.seller_id
    WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
        
	
#What percentage of overall sellers are Tech sellers?
select
(SELECT 
count(distinct s.seller_id)
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
	INNER JOIN 
    sellers s on oi.seller_id = s.seller_id
    WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony'))
        /
(SELECT 
count(distinct s.seller_id)
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
	INNER JOIN 
    sellers s on oi.seller_id = s.seller_id)
    * 100 as percentage;
    
#What is the total amount earned by all sellers?
SELECT 
round(sum(price))
FROM
   order_items oi 
   
#What is the total amount earned by all Tech sellers?
SELECT 
round(sum(price))
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
	INNER JOIN 
    sellers s on oi.seller_id = s.seller_id
      WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
   

#Can you work out the average monthly income of all sellers?
SELECT 
count(distinct s.seller_id),
round(round(sum(oi.price))/count(distinct month(order_purchase_timestamp), year(order_purchase_timestamp))) as avg_salary
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
	INNER JOIN 
    sellers s on oi.seller_id = s.seller_id

#Can you work out the average monthly income of Tech sellers?
SELECT 
count(distinct s.seller_id),
round(round(sum(oi.price))/count(distinct month(order_purchase_timestamp), year(order_purchase_timestamp))) as avg_salary
FROM
    product_category_name_translation pcnt
	INNER JOIN
    products p ON pcnt.product_category_name = p.product_category_name
	INNER JOIN
    order_items oi ON p.product_id = oi.product_id
    INNER JOIN 
    orders o on oi.order_id = o.order_id
	INNER JOIN 
    sellers s on oi.seller_id = s.seller_id
      WHERE
    pcnt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
        
        
#What’s the average time between the order being placed and the product being delivered?
select
avg(datediff(order_delivered_customer_date,order_purchase_timestamp))
FROM
orders
