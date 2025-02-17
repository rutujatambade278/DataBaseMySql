CREATE DATABASE tflecommerce;
Use tflecommerce;

ALTER DATABASE tflecommerce SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

DROP DATABASE tflecommerce;

 CREATE TABLE users (
    id INT Identity (1,1)PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);
 
CREATE TABLE categories (
    id INT Identity(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    id INT Identity(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    category_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES categories(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE orders (
    id INT Identity(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    total_amount DECIMAL(10, 2),
    shipping_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);



CREATE TABLE order_status (
    order_id INT NOT NULL,
	status VARCHAR(50) CHECK(
    status IN('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') )NOT NULL,
    status_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (order_id, status_date)
);
 
CREATE TABLE order_fulfillment (
    fulfillment_id INT Identity(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    fulfillment_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(50) CHECK(
    status IN('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    tracking_number VARCHAR(100),
    carrier_name VARCHAR(100),
    fulfillment_notes TEXT,
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
 CREATE TABLE refunds (
    refund_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    refund_amount DECIMAL(10, 2) NOT NULL,
    refund_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE purchase_orders (
    order_id INT Identity(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
CREATE TABLE discount_codes (
    code VARCHAR(50) PRIMARY KEY,
    discount_percentage DECIMAL(5, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);
 
CREATE TABLE order_discounts (
    order_id INT,
    discount_code VARCHAR(50),
    PRIMARY KEY (order_id, discount_code),
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (discount_code) REFERENCES discount_codes(code)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
CREATE TABLE order_items (
    id INT Identity(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE returns (
    return_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    return_reason VARCHAR(255) NOT NULL,
    return_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

 
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
CREATE TABLE product_audit (
    audit_id INT Identity(1,1) PRIMARY KEY,
    product_id INT,
    action_type VARCHAR(50) CHECK( action_type IN ('INSERT', 'UPDATE', 'DELETE') ),
    old_stock_quantity INT,
    new_stock_quantity INT,
    action_timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES inventory(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
CREATE TABLE price_changes (
    change_id INT Identity(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    old_price DECIMAL(10, 2) NOT NULL,
    new_price DECIMAL(10, 2) NOT NULL,
    change_date DATETIME NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
CREATE TABLE payments (
    payment_id INT Identity(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) CHECK( payment_method IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer')) NOT NULL,
    payment_status VARCHAR(50) CHECK( payment_status IN ('Completed', 'Pending', 'Failed')) DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- Create reviews table
CREATE TABLE reviews (
    id INT Identity(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at DateTime DEFAULT GetDate(),
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- Create cart table
CREATE TABLE cart (
    cart_id INT Identity(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    created_at DateTime DEFAULT GetDate(),
    FOREIGN KEY (customer_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
-- Create cart_items table
CREATE TABLE cart_items (
    cart_item_id INT Identity(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
-- Create shipping_methods table
CREATE TABLE shipping_methods (
    shipping_method_id INT Identity(1,1) PRIMARY KEY,
    method_name VARCHAR(
	100) NOT NULL,
    description TEXT,
    cost DECIMAL(10, 2) NOT NULL
);
 
-- Create shipments table
CREATE TABLE shipments (
    shipment_id INT Identity(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_method_id INT NOT NULL,
    shipment_date DateTime DEFAULT GetDate(),
    tracking_number VARCHAR(100),
    status varchar(50) CHECK(status IN ('Pending', 'Shipped', 'In Transit', 'Delivered', 'Failed')) DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_methods(shipping_method_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
-- Create shipment_items table
CREATE TABLE shipment_items (
    shipment_item_id INT IDENTITY(1,1) PRIMARY KEY,
    shipment_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
-- Create shipping_addresses table
CREATE TABLE shipping_addresses (
    shipping_address_id INT Identity(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
 
-- Create subscriptions table
 
CREATE TABLE subscriptions (
    subscription_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    subscription_plan VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(50) CHECK (status IN ('Active', 'Expired', 'Cancelled')) DEFAULT 'Active',
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
 
 
-- Create table loyalty_redemption
CREATE TABLE loyalty_redemptions (
    redemption_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    points_redeemed INT NOT NULL,
    redemption_date DATETIME NOT NULL,
    status varchar(50) CHECK(status IN ('Pending', 'Completed', 'Failed')) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);                                   -- ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- Create billing_adjustments table
CREATE TABLE billing_adjustments (
    adjustment_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    adjustment_amount DECIMAL(10, 2) NOT NULL,
    adjustment_date DATETIME NOT NULL,
    reason VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);


INSERT INTO users (username, password, email, address) VALUES
('aj_boss', 'ajpassword1234', 'aj@example.com', '789 Pune, Pune'),
('arun_kumar', 'password123', 'arun@example.com', '12 MG Road, Delhi'),
('meera_nair', 'securepass', 'meera@example.com', '34 Gandhi Street, Mumbai'),
('vikas_patel', 'mypassword', 'vikas@example.com', '56 Nehru Avenue, Ahmedabad'),
('sunita_verma', 'strongpass', 'sunita@example.com', '78 Patel Nagar, Pune'),
('raj_sharma', 'pass1234', 'raj@example.com', '90 Ambedkar Road, Bangalore'),
('anita_singh', 'secure123', 'anita@example.com', '123 Ashok Marg, Jaipur'),
('suresh_reddy', 'mypassword123', 'suresh@example.com', '456 Charminar, Hyderabad'),
('laxmi_menon', 'passwordsecure', 'laxmi@example.com', '789 MG Road, Chennai'),
('rahul_gupta', 'securepass456', 'rahul@example.com', '101 Nehru Place, Delhi'),
('geeta_kapoor', 'mypassword789', 'geeta@example.com', '123 Banjara Hills, Hyderabad'),
('amit_tiwari', 'strongpass123', 'amit@example.com', '456 Brigade Road, Bangalore'),
('rekha_das', 'pass9876', 'rekha@example.com', '789 Park Street, Kolkata'),
('ajay_mehta', 'securepass789', 'ajay@example.com', '101 Connaught Place, Delhi'),
('divya_bhatt', 'mypassword456', 'divya@example.com', '123 Marine Drive, Mumbai'),
('vivek_agarwal', 'passwordstrong', 'vivek@example.com', '456 Lalbagh, Lucknow'),
('priya_joshi', 'securepass1234', 'priya@example.com', '789 Residency Road, Bangalore'),
('rohit_saxena', 'mypasswordstrong', 'rohit@example.com', '101 MG Road, Pune'),
('kiran_rao', 'password456', 'kiran@example.com', '123 Race Course Road, Chennai'),
('suman_kumar', 'securepass987', 'suman@example.com', '456 MG Road, Bhopal'),
('nisha_shah', 'mypassword1234', 'nisha@example.com', '789 MG Road, Coimbatore');


INSERT INTO categories (name, description) VALUES
('Electronics', 'Devices and gadgets including phones, computers, and accessories.'),
('Books', 'A variety of books from different genres and authors.'),
('Clothing', 'Apparel including shirts, pants, and accessories.');


INSERT INTO products (name, description, price, stock, category_id) VALUES
('Smartphone', 'Latest model with high-resolution camera.', 699.99, 50, 1),
('Laptop', 'Powerful laptop with 16GB RAM and 512GB SSD.', 1199.99, 30, 1),
('Fiction Novel', 'Bestselling fiction novel by renowned author.', 19.99, 100, 2),
('Jeans', 'Stylish jeans available in various sizes.', 39.99, 100, 3),
('Smartwatch', 'Smartwatch with health tracking features.', 199.99, 60, 1),
('Tablet', 'Tablet with 10-inch display and 128GB storage.', 329.99, 40, 1),
('E-book Reader', 'E-book reader with 8GB storage.', 89.99, 150, 2),
('Shirt', 'Cotton shirt available in various colors.', 29.99, 90, 3),
('Headphones', 'Noise-cancelling wireless headphones.', 149.99, 80, 1),
('Bluetooth Speaker', 'Portable Bluetooth speaker with high bass.', 49.99, 100, 1),
('Historical Novel', 'Historical novel by famous author.', 25.99, 120, 2),
('Trousers', 'Comfortable trousers available in different sizes.', 34.99, 70, 3),
('Camera', 'Digital camera with 20MP lens.', 299.99, 20, 1),
('Smart TV', '55-inch 4K Smart TV with HDR.', 599.99, 25, 1),
('Cookbook', 'Cookbook with Indian recipes.', 15.99, 80, 2),
('Dress', 'Elegant dress available in various sizes.', 49.99, 60, 3),
('Wireless Charger', 'Fast wireless charger for smartphones.', 29.99, 110, 1),
('Mystery Novel', 'Gripping mystery novel by top author.', 21.99, 90, 2),
('Sneakers', 'Comfortable sneakers for running.', 59.99, 50, 3),
('Bluetooth Earbuds', 'True wireless Bluetooth earbuds.', 69.99, 75, 1);



INSERT INTO orders (customer_id, order_date, shipping_address, total_amount, shipping_date, status) VALUES
(1, '2024-07-25', '12 MG Road, Delhi', 719.98, '2024-07-26', 'Shipped'),  -- Order with Smartphone and Jeans
(2, '2024-07-26', '34 Gandhi Street, Mumbai', 1259.98, '2024-07-27', 'Shipped'),  -- Order with Laptop and Fiction Novel
(3, '2024-07-27', '56 Nehru Avenue, Ahmedabad', 239.98, '2024-07-28', 'Delivered'),  -- Order with Smartwatch and Shirt
(4, '2024-07-28', '78 Patel Nagar, Pune', 529.98, '2024-07-29', 'Processing'),  -- Order with Tablet and Jeans
(5, '2024-07-29', '90 Ambedkar Road, Bangalore', 179.98, '2024-07-30', 'Cancelled'),  -- Order with E-book Reader and Shirt
(6, '2024-07-30', '123 Ashok Marg, Jaipur', 179.98, '2024-07-31', 'Shipped'),  -- Order with Headphones and Cookbook
(7, '2024-07-31', '456 Charminar, Hyderabad', 99.98, '2024-08-01', 'Delivered'),  -- Order with Bluetooth Speaker and Cookbook
(8, '2024-08-01', '789 MG Road, Chennai', 499.98, '2024-08-02', 'Processing'),  -- Order with Historical Novel and Trousers
(9, '2024-08-02', '101 Nehru Place, Delhi', 449.98, '2024-08-03', 'Shipped'),  -- Order with Camera and Dress
(10, '2024-08-03', '123 Banjara Hills, Hyderabad', 389.98, '2024-08-04', 'Processing'),  -- Order with Smart TV and Shirt
(11, '2024-08-04', '456 Brigade Road, Bangalore', 149.98, '2024-08-05', 'Shipped'),  -- Order with Wireless Charger and Cookbook
(12, '2024-08-05', '789 Park Street, Kolkata', 49.98, '2024-08-06', 'Cancelled'),  -- Order with Mystery Novel
(13, '2024-08-06', '101 Connaught Place, Delhi', 129.98, '2024-08-07', 'Processing'),  -- Order with Sneakers and Cookbook
(14, '2024-08-07', '123 Marine Drive, Mumbai', 99.98, '2024-08-08', 'Delivered'),  -- Order with Bluetooth Earbuds
(15, '2024-08-08', '456 Lalbagh, Lucknow', 99.98, '2024-08-09', 'Shipped'),  -- Order with Bluetooth Earbuds
(16, '2024-08-09', '789 Residency Road, Bangalore', 179.98, '2024-08-10', 'Delivered'),  -- Order with Headphones and Cookbook
(17, '2024-08-10', '101 MG Road, Pune', 239.98, '2024-08-11', 'Processing'),  -- Order with Smartwatch and Shirt
(18, '2024-08-11', '123 Race Course Road, Chennai', 529.98, '2024-08-12', 'Shipped'),  -- Order with Tablet and Jeans
(19, '2024-08-12', '456 MG Road, Bhopal', 449.98, '2024-08-13', 'Delivered'),  -- Order with Camera and Dress
(20, '2024-08-13', '789 MG Road, Coimbatore', 69.98, '2024-08-14', 'Processing');  -- Order with Bluetooth Earbuds


INSERT INTO order_items (order_id, item_id, quantity) VALUES
(1, 1, 2),  -- 2 Smartphones
(1, 4, 5),  -- 5 Jeans
(2, 2, 4),  -- 4 Laptops
(2, 3, 8),  -- 8 Fiction Novels
(3, 5, 1),  -- 1 Smartwatch
(3, 8, 1),  -- 1 Shirt
(4, 6, 1),  -- 1 Tablet
(4, 4, 5),  -- 5 Jeans
(5, 7, 6),  -- 6 E-book Readers
(5, 8, 7),  -- 7 Shirts
(6, 9, 1),  -- 1 Headphones
(6, 15, 5),  -- 5 Cookbooks
(7, 10, 1),  -- 1 Bluetooth Speaker
(7, 15, 4),  -- 4 Cookbooks
(8, 11, 1),  -- 1 Historical Novel
(8, 12, 1),  -- 1 Trousers
(9, 13, 1),  -- 1 Camera
(9, 16, 3),  -- 3 Dresses
(10, 14, 1),  -- 1 Smart TV
(10, 8, 2),  -- 2 Shirts
(11, 17, 1),  -- 1 Wireless Charger
(11, 15, 1),  -- 1 Cookbook
(12, 18, 1),  -- 1 Mystery Novel
(13, 19, 4),  -- 4 Sneakers
(13, 15, 1),  -- 1 Cookbook
(14, 20, 1),  -- 1 Bluetooth Earbuds
(15, 20, 6),  -- 6 Bluetooth Earbuds
(16, 9, 1),  -- 1 Headphones
(16, 15, 1),  -- 1 Cookbook
(17, 5, 9),  -- 9 Smartwatches
(17, 8, 1),  -- 1 Shirt
(18, 6, 1),  -- 1 Tablet
(18, 4, 2),  -- 2 Jeans
(19, 13, 1),  -- 1 Camera
(19, 16, 1),  -- 1 Dress
(20, 20, 7);  -- 7 Bluetooth Earbuds

INSERT INTO reviews (product_id, user_id, rating, review_text) VALUES
(1, 1, 5, 'Fantastic smartphone with amazing features!'),
(1, 2, 3, 'Good'),
(2, 2, 4, 'Very powerful laptop, but a bit heavy.'),
(3, 3, 5, 'Great book, could not put it down!'),
(4, 4, 3, 'Jeans are good, but the fit was not perfect.'),
(5, 5, 5, 'Smartwatch with excellent features .'),
(6, 6, 4, 'Tablet is good but battery life could be better.'),
(7, 7, 5, 'E-book reader is very convenient.'),
(8, 8, 4, 'Shirt material is good but color faded after wash.'),
(9, 9, 5, 'Headphones have great sound quality.'),
(10, 10, 4, 'Bluetooth speaker is portable and has good bass.'),
(11, 11, 5, 'Historical novel was very engaging.'),
(12, 12, 3, 'Trousers are comfortable but the size was a bit off.'),
(13, 13, 5, 'Camera quality is superb.'),
(14, 14, 4, 'Smart TV has excellent picture quality.'),
(15, 15, 5, 'Cookbook has some amazing recipes.'),
(16, 16, 3, 'Dress is nice but fitting could be better.'),
(17, 17, 5, 'Wireless charger is very convenient.'),
(18, 18, 5, 'Mystery novel kept me hooked till the end.'),
(19, 19, 4, 'Sneakers are comfortable for running.'),
(20, 20, 5, 'Bluetooth earbuds have excellent sound quality.');


INSERT INTO payments (order_id, payment_amount, payment_method, payment_status) VALUES
(1, 719.98, 'Credit Card', 'Completed'),  -- Payment for order 1
(2, 1259.98, 'PayPal', 'Completed'),  -- Payment for order 2
(3, 239.98, 'Debit Card', 'Completed'),  -- Payment for order 3
(4, 529.98, 'Bank Transfer', 'Pending'),  -- Payment for order 4
(5, 179.98, 'Credit Card', 'Failed'),  -- Payment for order 5
(6, 179.98, 'PayPal', 'Completed'),  -- Payment for order 6
(7, 99.98, 'Debit Card', 'Completed'),  -- Payment for order 7
(8, 499.98, 'Credit Card', 'Pending'),  -- Payment for order 8
(9, 449.98, 'Bank Transfer', 'Completed'),  -- Payment for order 9
(10, 389.98, 'PayPal', 'Failed'),  -- Payment for order 10
(11, 149.98, 'Credit Card', 'Completed'),  -- Payment for order 11
(12, 49.98, 'Debit Card', 'Completed'),  -- Payment for order 12
(13, 129.98, 'Bank Transfer', 'Pending'),  -- Payment for order 13
(14, 99.98, 'Credit Card', 'Completed'),  -- Payment for order 14
(15, 99.98, 'PayPal', 'Completed'),  -- Payment for order 15
(16, 179.98, 'Debit Card', 'Completed'),  -- Payment for order 16
(17, 239.98, 'Bank Transfer', 'Pending'),  -- Payment for order 17
(18, 529.98, 'Credit Card', 'Completed'),  -- Payment for order 18
(19, 449.98, 'PayPal', 'Completed'),  -- Payment for order 19
(20, 69.98, 'Debit Card', 'Completed');  -- Payment for order 20


INSERT INTO order_status (order_id, status, status_date) VALUES
(1, 'Shipped', '2024-07-26'),
(2, 'Shipped', '2024-07-27'),
(3, 'Delivered', '2024-07-28'),
(4, 'Processing', '2024-07-28'),
(5, 'Cancelled', '2024-07-29'),
(6, 'Shipped', '2024-07-30'),
(7, 'Delivered', '2024-07-31'),
(8, 'Processing', '2024-08-01'),
(9, 'Shipped', '2024-08-02'),
(10, 'Processing', '2024-08-03');


INSERT INTO cart (customer_id, created_at) VALUES
(1, '2024-07-25 10:00:00'), -- Cart for user 1
(2, '2024-07-26 11:00:00'), -- Cart for user 2
(3, '2024-07-27 12:00:00'), -- Cart for user 3
(4, '2024-07-28 13:00:00'), -- Cart for user 4
(5, '2024-07-29 14:00:00'); -- Cart for user 5


INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 2), -- 2 Smartphones in cart 1
(1, 4, 3), -- 3 Jeans in cart 1
(2, 2, 1), -- 1 Laptop in cart 2
(2, 3, 5), -- 5 Fiction Novels in cart 2
(3, 5, 1), -- 1 Smartwatch in cart 3
(3, 8, 2), -- 2 Shirts in cart 3
(4, 6, 1), -- 1 Tablet in cart 4
(4, 12, 2), -- 2 Trousers in cart 4
(5, 10, 1), -- 1 Bluetooth Speaker in cart 5
(5, 15, 3); -- 3 Cookbooks in cart 5



INSERT INTO shipping_methods (method_name, description, cost) VALUES
('Standard Shipping', 'Delivery within 5-7 business days', 5.99),
('Express Shipping', 'Delivery within 2-3 business days', 12.99),
('Overnight Shipping', 'Next day delivery', 24.99),
('International Shipping', 'Delivery within 10-15 business days', 39.99),
('Economy Shipping', 'Delivery within 7-10 business days', 4.99),
('Priority Shipping', 'Delivery within 3-5 business days', 9.99),
('Two-Day Shipping', 'Guaranteed delivery in 2 business days', 15.99),
('Same-Day Shipping', 'Delivery on the same day', 29.99),
('Next-Day Air', 'Next day delivery by air', 19.99),
('Standard International', 'Standard international delivery', 49.99),
('Expedited International', 'Expedited international delivery', 69.99),
('Courier Service', 'Courier delivery within 1-2 business days', 14.99),
('Flat Rate Shipping', 'Flat rate shipping cost', 6.99),
('Freight Shipping', 'Freight delivery for large items', 99.99),
('Delivery by Sea', 'Sea freight delivery', 29.99),
('Delivery by Rail', 'Rail freight delivery', 39.99),
('Delivery by Air Cargo', 'Air cargo delivery', 89.99),
('Local Delivery', 'Local delivery within the same city', 7.99),
('Regional Delivery', 'Delivery within the region', 8.99),
('Express International', 'Express international delivery', 59.99);


INSERT INTO shipments (order_id, shipping_method_id, shipment_date, tracking_number, status) VALUES
(1, 1, '2024-07-25', 'TRACK001', 'Shipped'),
(2, 2, '2024-07-26', 'TRACK002', 'Shipped'),
(3, 3, '2024-07-27', 'TRACK003', 'Delivered'),
(4, 4, '2024-07-28', 'TRACK004', 'Pending'), -- Changed 'Processing' to 'Pending'
(5, 5, '2024-07-29', 'TRACK005', 'Failed'),   -- Changed 'Cancelled' to 'Failed'
(6, 6, '2024-07-30', 'TRACK006', 'Shipped'),
(7, 7, '2024-07-31', 'TRACK007', 'Delivered'),
(8, 8, '2024-08-01', 'TRACK008', 'Pending'),  -- Changed 'Processing' to 'Pending'
(9, 9, '2024-08-02', 'TRACK009', 'Shipped'),
(10, 10, '2024-08-03', 'TRACK010', 'Pending'); -- Changed 'Processing' to 'Pending'



INSERT INTO shipment_items (shipment_id, product_id, quantity) VALUES
(1, 1, 5),      -- Smartphone
(1, 2, 2),      -- Laptop
(2, 3, 7),      -- Fiction Novel
(2, 4, 3),      -- Jeans
(3, 5, 4),      -- Smartwatch
(3, 6, 2),      -- Tablet
(4, 7, 10),     -- E-book Reader
(4, 8, 6),      -- Shirt
(5, 9, 3),      -- Headphones
(5, 10, 8),    -- Bluetooth Speaker
(6, 11, 5),    -- Historical Novel
(6, 12, 2),    -- Trousers
(7, 13, 1),    -- Camera
(7, 14, 1),    -- Smart TV
(8, 15, 6),    -- Cookbook
(8, 16, 3),    -- Dress
(9, 17, 7),    -- Wireless Charger
(9, 18, 4),    -- Mystery Novel
(10, 19, 5),   -- Sneakers
(10, 20, 3);   -- Bluetooth Earbuds



INSERT INTO shipping_addresses (order_id, address, city, state, zip_code, country) VALUES
(1, '123 Elm Street', 'Springfield', 'IL', '62701', 'USA'),
(2, '456 Oak Avenue', 'Metropolis', 'NY', '10001', 'USA'),
(3, '789 Pine Road', 'Gotham', 'NJ', '07001', 'USA'),
(4, '101 Maple Lane', 'Smallville', 'KS', '66101', 'USA'),
(5, '202 Birch Boulevard', 'Star City', 'CA', '90210', 'USA'),
(6, '303 Cedar Drive', 'Haven', 'PA', '19001', 'USA'),
(7, '404 Spruce Street', 'Riverside', 'TX', '75001', 'USA'),
(8, '505 Willow Way', 'Sunnydale', 'FL', '33101', 'USA'),
(9, '606 Fir Avenue', 'Greenville', 'SC', '29601', 'USA'),
(10, '707 Redwood Lane', 'Oakwood', 'OH', '44101', 'USA'),
(11, '808 Poplar Street', 'Rosewood', 'WA', '98001', 'USA'),
(12, '909 Chestnut Drive', 'Forestville', 'MI', '48201', 'USA'),
(13, '1010 Sycamore Road', 'Clearwater', 'CO', '80101', 'USA'),
(14, '1111 Aspen Avenue', 'Hillcrest', 'MN', '55401', 'USA'),
(15, '1212 Juniper Lane', 'Lakeside', 'OR', '97201', 'USA'),
(16, '1313 Pinecrest Drive', 'Woodland', 'UT', '84101', 'USA'),
(17, '1414 Oakwood Lane', 'Meadowbrook', 'NV', '89101', 'USA'),
(18, '1515 Maplewood Avenue', 'Ridgeview', 'AZ', '85001', 'USA'),
(19, '1616 Willowbrook Street', 'Clearview', 'MT', '59001', 'USA'),
(20, '1717 Cedarwood Lane', 'Northfield', 'VT', '05601', 'USA');


INSERT INTO discount_codes (code, discount_percentage, start_date, end_date) VALUES
('SUMMER21', 10.00, '2024-07-01', '2024-07-31'),
('WINTER21', 15.00, '2024-12-01', '2024-12-31'),
('DIWALI21', 20.00, '2021-11-01', '2024-11-15'),
('HOLI21', 18.00, '2024-03-01', '2024-03-10'),
('NEWYEAR21', 25.00, '2024-12-31', '2025-01-01'),
('INDEPENDENCE21', 15.00, '2022-08-15', '2024-08-15'),
('REPUBLIC21', 12.00, '2023-01-26', '2024-01-26'),
('SUMMER22', 10.00, '2025-07-01', '2025-07-31'),
('WINTER22', 15.00, '2025-12-01', '2025-12-31'),
('DIWALI22', 20.00, '2025-11-01', '2025-11-15'),
('HOLI22', 18.00, '2024-03-01', '2025-03-10'),
('NEWYEAR22', 25.00, '2024-05-31', '2026-01-01'),
('INDEPENDENCE22', 15.00, '2023-08-15', '2025-08-15'),
('REPUBLIC22', 12.00, '2022-01-26', '2025-01-26'),
('SUMMER23', 10.00, '2021-07-01', '2026-07-31'),
('WINTER23', 15.00, '2020-12-01', '2026-12-31'),
('DIWALI23', 20.00, '2021-11-01', '2026-11-15'),
('HOLI23', 18.00, '2022-03-01', '2026-03-10'),
('NEWYEAR23', 25.00, '2023-12-31', '2027-01-01'),
('INDEPENDENCE23', 15.00, '2022-08-15', '2026-08-15');



INSERT INTO order_discounts (order_id, discount_code) VALUES
(1, 'SUMMER21'),
(2, 'WINTER21'),
(3, 'DIWALI21'),
(4, 'HOLI21'),
(5, 'NEWYEAR21'),
(6, 'INDEPENDENCE21'),
(7, 'REPUBLIC21');



INSERT INTO inventory (product_id, stock_quantity) VALUES
(1, 90),
(2, 200),
(3, 300),
(4, 400),
(5, 500),
(6, 600),
(7, 70),
(8, 200),
(9, 100),
(10, 200),
(11, 100),
(12, 200),
(13, 100),
(14, 200),
(15, 100);



INSERT INTO price_changes (product_id, old_price, new_price, change_date) VALUES
(1, 699.99, 649.99, '2024-08-01 10:00:00'),
(2, 1199.99, 1149.99, '2024-08-01 11:00:00'),
(3, 19.99, 17.99, '2024-08-02 09:00:00'),
(4, 39.99, 34.99, '2024-08-02 10:00:00'),
(5, 199.99, 179.99, '2024-08-03 14:00:00'),
(6, 329.99, 299.99, '2024-08-03 15:00:00'),
(7, 89.99, 79.99, '2024-08-04 12:00:00'),
(8, 29.99, 24.99, '2024-08-04 13:00:00'),
(9, 149.99, 139.99, '2024-08-05 16:00:00'),
(10, 49.99, 44.99, '2024-08-05 17:00:00'),
(11, 25.99, 22.99, '2024-08-06 10:00:00'),
(12, 34.99, 29.99, '2024-08-06 11:00:00'),
(13, 299.99, 279.99, '2024-08-07 12:00:00'),
(14, 599.99, 569.99, '2024-08-07 13:00:00'),
(15, 15.99, 14.99, '2024-08-08 14:00:00'),
(16, 49.99, 44.99, '2024-08-08 15:00:00'),
(17, 29.99, 24.99, '2024-08-09 16:00:00'),
(18, 21.99, 19.99, '2024-08-09 17:00:00'),
(19, 59.99, 54.99, '2024-08-10 18:00:00'),
(20, 69.99, 64.99, '2024-08-10 19:00:00');



INSERT INTO order_fulfillment (order_id, fulfillment_date, status, tracking_number, carrier_name, fulfillment_notes) VALUES
(1, '2024-08-01 12:00:00', 'Pending', 'TRACK123456', 'UPS', 'Order Pending.'),
(2, '2024-08-02 13:00:00', 'Shipped', 'TRACK123457', 'FedEx', 'Shipped via FedEx.'),
(3, '2024-08-03 14:00:00', 'Delivered', 'TRACK123458', 'DHL', 'Delivered to customer.'),
(4, '2024-08-04 15:00:00', 'Pending', NULL, NULL, 'Awaiting packing.'),
(5, '2024-08-05 16:00:00', 'Shipped', 'TRACK123459', 'UPS', 'Shipped and on its way.'),
(6, '2024-08-06 17:00:00', 'Cancelled', 'TRACK123460', 'FedEx', 'Cancelled.'),
(7, '2024-08-07 18:00:00', 'Delivered', 'TRACK123461', 'DHL', 'Delivered successfully.'),
(8, '2024-08-08 19:00:00', 'Shipped', 'TRACK123462', 'UPS', 'Shipped with UPS.'),
(9, '2024-08-09 20:00:00', 'Pending', NULL, NULL, 'Packing in progress.'),
(10, '2024-08-10 21:00:00', 'Shipped', 'TRACK123463', 'FedEx', 'Shipped via FedEx.'),
(11, '2024-08-11 22:00:00', 'Shipped', 'TRACK123464', 'UPS', 'Shipped via FedEx..'),
(12, '2024-08-12 23:00:00', 'Pending', NULL, NULL, 'Awaiting shipping instructions.'),
(13, '2024-08-13 10:00:00', 'Shipped', 'TRACK123465', 'DHL', 'On its way to the destination.'),
(14, '2024-08-14 11:00:00', 'Delivered', 'TRACK123466', 'FedEx', 'Delivered to the address.'),
(15, '2024-08-15 12:00:00', 'Delivered', 'TRACK123467', 'UPS', 'Delivered to the address.'),
(16, '2024-08-16 13:00:00', 'Shipped', 'TRACK123468', 'DHL', 'Shipped and on route.'),
(17, '2024-08-17 14:00:00', 'Delivered', 'TRACK123469', 'FedEx', 'Delivered successfully.'),
(18, '2024-08-18 15:00:00', 'Shipped', 'TRACK123470', 'UPS', 'Shipped and on its way.'),
(19, '2024-08-19 16:00:00', 'Pending', NULL, NULL, 'Awaiting packing.'),
(20, '2024-08-20 17:00:00', 'Shipped', 'TRACK123471', 'DHL', 'Shipped and on its way.');




INSERT INTO refunds (order_id, product_id, refund_amount, refund_date) VALUES
(1, 1, 699.99, '2024-08-01 10:00:00'),
(2, 2, 1199.99, '2024-08-02 11:00:00'),
(3, 3, 19.99, '2024-08-03 09:00:00'),
(4, 4, 39.99, '2024-08-04 10:00:00'),
(5, 5, 199.99, '2024-08-05 14:00:00'),
(6, 6, 329.99, '2024-08-06 15:00:00'),
(7, 7, 89.99, '2024-08-07 12:00:00'),
(8, 8, 29.99, '2024-08-08 13:00:00'),
(9, 9, 149.99, '2024-08-09 16:00:00'),
(10, 10, 49.99, '2024-08-10 17:00:00'),
(11, 11, 25.99, '2024-08-11 10:00:00'),
(12, 12, 34.99, '2024-08-12 11:00:00'),
(13, 13, 299.99, '2024-08-13 12:00:00'),
(14, 14, 599.99, '2024-08-14 13:00:00'),
(15, 15, 15.99, '2024-08-15 14:00:00'),
(16, 16, 49.99, '2024-08-16 15:00:00'),
(17, 17, 29.99, '2024-08-17 16:00:00'),
(18, 18, 21.99, '2024-08-18 17:00:00'),
(19, 19, 59.99, '2024-08-19 18:00:00'),
(20, 20, 69.99, '2024-08-20 19:00:00');



-- Insert sample data into the returns table
INSERT INTO returns (order_id, product_id, return_reason, return_date, status) VALUES
(1, 1, 'Defective item', '2024-07-27', 'Pending'),
(2, 3, 'Incorrect item received', '2024-07-28', 'Pending'),
(3, 5, 'Product not as described', '2024-07-29', 'Pending'),
(4, 6, 'Wrong item received', '2024-07-30', 'Pending'),
(5, 8, 'Changed mind', '2024-07-31', 'Pending'),
(6, 10, 'Defective item', '2024-08-01', 'Pending'),
(7, 10, 'Product not as described', '2024-08-02', 'Pending'),
(8, 11, 'Changed mind', '2024-08-03', 'Pending'),
(9, 13, 'Defective item', '2024-08-04', 'Pending'),
(10, 14, 'Incorrect item received', '2024-08-05', 'Pending'),
(11, 17, 'Defective item', '2024-08-06', 'Pending'),
(12, 18, 'Changed mind', '2024-08-07', 'Pending'),
(13, 19, 'Product not as described', '2024-08-08', 'Pending'),
(14, 20, 'Wrong item received', '2024-08-09', 'Pending'),
(15, 20, 'Defective item', '2024-08-10', 'Pending'),
(16, 17, 'Defective item', '2024-08-11', 'Pending'),
(17, 5, 'Product not as described', '2024-08-12', 'Pending'),
(18, 6, 'Changed mind', '2024-08-13', 'Pending'),
(19, 13, 'Incorrect item received', '2024-08-14', 'Pending'),
(20, 20, 'Defective item', '2024-08-15', 'Pending');


-- Sample data for billing_adjustments
INSERT INTO billing_adjustments (user_id, adjustment_amount, adjustment_date, reason) VALUES
(1, -20.00, '2024-06-10 10:00:00', 'Discount applied'),
(2, 15.75, '2024-07-05 13:00:00', 'Billing error correction'),
(3, -5.50, '2024-05-30 08:00:00', 'Refund for overcharge'),
(4, 25.00, '2024-07-10 12:00:00', 'Late fee');


-- Sample data for loyalty_redemptions
INSERT INTO loyalty_redemptions (user_id, points_redeemed, redemption_date, status) VALUES
(1, 150, '2024-06-05 14:30:00', 'Completed'),
(2, 300, '2024-07-01 09:15:00', 'Pending'),
(3, 200, '2024-05-25 16:45:00', 'Completed'),
(4, 50, '2024-07-15 11:00:00', 'Failed');


-- Sample data for subscriptions
INSERT INTO subscriptions (user_id, subscription_plan, start_date, end_date, status) VALUES
(1, 'Basic Plan', '2024-01-15', '2024-07-15', 'Expired'),
(2, 'Premium Plan', '2024-03-01', NULL, 'Active'),
(3, 'Standard Plan', '2024-05-20', '2024-11-20', 'Active'),
(4, 'Basic Plan', '2024-02-10', '2024-08-10', 'Expired');