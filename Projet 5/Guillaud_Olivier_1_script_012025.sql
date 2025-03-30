--
-- Fichier g�n�r� par SQLiteStudio v3.4.9 sur lun. janv. 27 22:51:23 2025
--
-- Encodage texte utilis� : System
--
-- R�sultats de la requ�te :
-- --- D�but requ�te 1 
-- SELECT 
--     orders.*, 
--     JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_estimated_delivery_date) AS delta
-- FROM orders
-- WHERE 
--     order_purchase_timestamp >= (
--         SELECT DATE(MAX(order_purchase_timestamp), '-3 months') 
--         FROM orders
--     )
--     AND JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_estimated_delivery_date) >= 3
--     AND order_status <> 'canceled';
-- --- Fin requ�te 1
-- 
--   
-- --- D�but requ�te 2
-- SELECT 
--     i.seller_id,
--     SUM(i.price) AS total_amount_sold, -- Total des ventes
--     COUNT(i.order_id) AS total_items_sold -- Nombre d'articles vendus
-- FROM 
--     order_items AS i
-- JOIN 
--     orders AS o ON i.order_id = o.order_id
-- WHERE 
--     o.order_status = 'delivered'
-- GROUP BY 
--     i.seller_id
-- HAVING 
--     total_amount_sold > 100000
-- ORDER BY 
--     total_amount_sold DESC;
-- --- Fin requ�te 2
-- 
-- 
-- --- D�but requ�te 3
-- SELECT 
--     seller_id, 
--     SUM(i.price) AS total_amount_sold, 
--     COUNT(i.order_id) AS total_items_sold
-- FROM order_items AS i
-- INNER JOIN orders AS o
--     ON o.order_id = i.order_id
-- WHERE 
--     o.order_status = 'delivered'
--     AND seller_id IN (
--         SELECT seller_id
--         FROM order_items AS i2
--         INNER JOIN orders AS o2
--             ON o2.order_id = i2.order_id
--         WHERE o2.order_status = 'delivered'
--         GROUP BY seller_id
--         HAVING MIN(o2.order_purchase_timestamp) > (
--             SELECT DATE(MAX(order_purchase_timestamp), '-3 months')
--             FROM orders
--         )
--     )
-- GROUP BY seller_id
-- HAVING total_items_sold > 30;
-- --- Fin requ�te 3
-- 
-- 
-- --- D�but requ�te 4
-- SELECT 
--     c.customer_zip_code_prefix AS zip_code,
--     COUNT(r.review_score) AS total_reviews,
--     AVG(r.review_score) AS average_review_score
-- FROM 
--     order_reviews r
-- JOIN 
--     orders o ON r.order_id = o.order_id
-- JOIN 
--     customers c ON o.customer_id = c.customer_id
-- WHERE 
--     o.order_purchase_timestamp >= (
--         SELECT DATE(MAX(order_purchase_timestamp), '-12 months') 
--         FROM orders
--     )
-- GROUP BY 
--     c.customer_zip_code_prefix
-- HAVING 
--     total_reviews > 30 
-- ORDER BY 
--     average_review_score ASC 
-- LIMIT 5;
-- --- Fin requ�te 4
-- 
--
BEGIN TRANSACTION;
INSERT INTO olist (zip_code, total_reviews, average_review_score) VALUES (22753, 47, 2.80851063829787);
INSERT INTO olist (zip_code, total_reviews, average_review_score) VALUES (22770, 37, 3.13513513513514);
INSERT INTO olist (zip_code, total_reviews, average_review_score) VALUES (22793, 90, 3.23333333333333);
INSERT INTO olist (zip_code, total_reviews, average_review_score) VALUES (21321, 36, 3.27777777777778);
INSERT INTO olist (zip_code, total_reviews, average_review_score) VALUES (22780, 37, 3.35135135135135);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
