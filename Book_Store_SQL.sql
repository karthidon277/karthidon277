-- Create table for authors
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

-- Create table for books
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    book_title VARCHAR(255) NOT NULL,
    author_id INT REFERENCES authors(author_id),
    genre VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    UNIQUE (book_title, author_id)
);

-- Create table for customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(15),
    address TEXT
);

-- Create table for orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);

-- Create table for order details
CREATE TABLE order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    book_id INT REFERENCES books(book_id),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Retrieve top-selling books
SELECT b.book_id, b.book_title, a.author_name, COUNT(od.book_id) AS total_sales
FROM books b
JOIN order_details od ON b.book_id = od.book_id
JOIN authors a ON b.author_id = a.author_id
GROUP BY b.book_id, b.book_title, a.author_name
ORDER BY total_sales DESC
LIMIT 10;

-- Calculate total sales revenue for a given period (e.g., for the month of January 2024)
SELECT SUM(od.quantity * od.price) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-01-31';
