
Use tflecommerce;

-- CREATE TRIGGER before_product_delete
-- BEFORE DELETE ON products
-- FOR EACH ROW
-- BEGIN
--     -- Check if the product is present in any order
--     IF EXISTS (
--         SELECT 1
--         FROM order_items oi
--         WHERE oi.item_id = OLD.id
--     ) THEN
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'Cannot delete product with existing orders.';
--     END IF;
-- END//
 
DELIMITER ;
-- 10. Trigger to Automatically Update User Points Based on Order Total
DELIMITER //
CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
DECLARE calculate_points int default 0;

    SET calculate_points = FLOOR(NEW.total_amount / 10);
    -- Assuming 1 point per 10 units of order total
    IF EXISTS(Select 1 from loyalty_redemptions where user_id= NEW.customer_id)
    THEN
    UPDATE loyalty_redemptions
    SET points_redeemed = points_redeemed + calculate_points
    WHERE user_id = NEW.customer_id;
    ELSE
   INSERT INTO loyalty_redemptions (user_id, points_redeemed, redemption_date, status) VALUES
         (NEW.customer_id, calculate_points, NOW(), 'Pending');
       END IF ;
       END//
DELIMITER ;

INSERT INTO orders(customer_id, order_date, shipping_address, total_amount, shipping_date, status) VALUES
(2, '2024-07-23', 'Manchar, pune', 1019.98, '2024-07-30', 'Shipped');

DROP  trigger after_order_insert;
