-- Drop tables if they exist to avoid conflicts
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

-- Create Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

-- Create Categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100)
);

-- Create Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    category_id INT REFERENCES categories(category_id)
);

-- Create Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10,2)
);

-- Create Order_Items table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price NUMERIC(10,2)
);

-- Insert sample data into categories
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Books'),
('Clothing');

-- Insert sample data into customers
INSERT INTO customers (name, email, country) VALUES
('Alice Johnson', 'alice@example.com', 'USA'),
('Bob Smith', 'bob@example.com', 'Canada'),
('Carol White', 'carol@example.com', 'USA');

-- Insert sample data into products
INSERT INTO products (name, price, category_id) VALUES
('Smartphone', 699.99, 1),
('Laptop', 1299.99, 1),
('Novel Book', 19.99, 2),
('T-Shirt', 15.99, 3);

-- Insert sample data into orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-05-01', 719.98),
(2, '2025-05-02', 1315.98),
(3, '2025-05-03', 35.98);

-- Insert sample data into order_items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 2, 1, 1299.99),
(2, 4, 1, 15.99),
(3, 3, 2, 19.99);
-- List all customers from USA ordered by name
SELECT * FROM customers
WHERE country = 'USA'
ORDER BY name;
-- Total sales amount by customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;
-- List orders with customer names and order dates
SELECT o.order_id, c.name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;
-- Show all customers and their orders if any
SELECT c.name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.name;
-- Find product(s) with highest sales revenue
SELECT name, total_revenue FROM (
    SELECT p.name, SUM(oi.quantity * oi.price) AS total_revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.name
) AS revenue_table
ORDER BY total_revenue DESC
LIMIT 1;






