CREATE DATABASE MovieRentalDB;

USE MovieRentalDB;

-- Create Tables

CREATE TABLE Movies (
    film_id INT PRIMARY KEY,
    title VARCHAR(255),
    category VARCHAR(100),
    length INT,
    rental_rate DECIMAL(5,2),
    replacement_cost DECIMAL(10,2)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(15)
);

CREATE TABLE Rentals (
    rental_id INT PRIMARY KEY,
    rental_date DATETIME,
    customer_id INT,
    film_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (film_id) REFERENCES Movies(film_id)
);

CREATE TABLE Returns (
    return_id INT PRIMARY KEY,
    rental_id INT,
    return_date DATETIME,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
);

-- Insert Movies

INSERT INTO Movies (film_id, title, category, length, rental_rate, replacement_cost) VALUES
(1, 'Inception', 'Sci-Fi', 148, 3.99, 14.99),
(2, 'The Shawshank Redemption', 'Drama', 142, 3.99, 14.99),
(3, 'The Godfather', 'Crime', 175, 4.99, 19.99),
(4, 'The Dark Knight', 'Action', 152, 3.99, 16.99),
(5, 'Pulp Fiction', 'Crime', 154, 3.49, 15.99),
(6, 'Forrest Gump', 'Drama', 142, 3.99, 14.99),
(7, 'The Matrix', 'Sci-Fi', 136, 3.49, 12.99),
(8, 'Fight Club', 'Drama', 139, 4.49, 15.99),
(9, 'Interstellar', 'Sci-Fi', 169, 4.99, 17.99),
(10, 'The Lord of the Rings: The Return of the King', 'Fantasy', 201, 5.49, 22.99);

-- Insert Customers

INSERT INTO Customers (customer_id, first_name, last_name, email, phone) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '123-456-7890'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '234-567-8901'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '345-678-9012'),
(4, 'Bob', 'Brown', 'bob.brown@example.com', '456-789-0123'),
(5, 'Charlie', 'Davis', 'charlie.davis@example.com', '567-890-1234'),
(6, 'Eve', 'Wilson', 'eve.wilson@example.com', '678-901-2345');

-- Insert Rentals with Specific Dates

INSERT INTO Rentals (rental_id, rental_date, customer_id, film_id) VALUES
(1, '2024-11-01 10:00:00', 1, 1), -- John rents Inception
(2, '2024-11-02 11:30:00', 2, 1), -- Jane rents Inception
(3, '2024-11-03 09:15:00', 1, 2), -- John rents The Shawshank Redemption
(4, '2024-11-04 14:45:00', 3, 3), -- Alice rents The Godfather
(5, '2024-11-05 13:00:00', 4, 4), -- Bob rents The Dark Knight
(6, '2024-11-06 12:30:00', 5, 5), -- Charlie rents Pulp Fiction
(7, '2024-11-07 15:00:00', 6, 6), -- Eve rents Forrest Gump
(8, '2024-11-08 16:30:00', 2, 7), -- Jane rents The Matrix
(9, '2024-11-09 17:00:00', 1, 8), -- John rents Fight Club
(10,'2024-11-10 18:30:00', 3 ,9); -- Alice rents Interstellar

-- Example Queries to Manage Rentals and Returns
select * from Movies;

select * from Customers;

-- Query to retrieve all rentals by a specific customer (e.g., John Doe)
SELECT r.rental_id , m.title AS movie_title , r.rental_date 
FROM Rentals r 
JOIN Movies m ON r.film_id = m.film_id 
WHERE r.customer_id = 1;

-- Query to return a rented movie (example for rental ID = 1)
INSERT INTO Returns (return_id , rental_id , return_date)
VALUES (1 ,1 , NOW());

-- Query to check late returns (assuming a rental period of up to 7 days)
SELECT r.rental_id , m.title AS movie_title 
FROM Returns rt 
JOIN Rentals r ON rt.rental_id = r.rental_id 
JOIN Movies m ON r.film_id = m.film_id 
WHERE rt.return_date > DATE_ADD(r.rental_date , INTERVAL 7 DAY);

SELECT SUM(m.rental_rate) AS total_cost 
FROM Rentals r 
JOIN Movies m ON r.film_id = m.film_id 
WHERE r.customer_id = 1; -- Change the customer_id as needed

SELECT r.rental_id, c.first_name, c.last_name, m.title, r.rental_date 
FROM Rentals r 
JOIN Customers c ON r.customer_id = c.customer_id 
JOIN Movies m ON r.film_id = m.film_id;

SELECT r.rental_id, c.first_name, c.last_name, m.title, r.rental_date 
FROM Rentals r 
JOIN Customers c ON r.customer_id = c.customer_id 
JOIN Movies m ON r.film_id = m.film_id 
WHERE r.rental_date BETWEEN '2024-11-01' AND '2024-11-10'; -- Adjust dates as needed

SELECT m.title, COUNT(r.rental_id) AS total_rentals 
FROM Movies m 
LEFT JOIN Rentals r ON m.film_id = r.film_id 
GROUP BY m.title;
