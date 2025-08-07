


Create database music_store;
use music_store;

-- 1. Genre  
CREATE TABLE Genre ( 
GenreId INT PRIMARY KEY, 
Name VARCHAR(120) 
); 
-- 2.  MediaType
CREATE TABLE MediaType ( 
 
    MediaTypeId INT PRIMARY KEY, 
    Name VARCHAR(120) 
); 
select *from mediatype;
select *from genre;
select *from album;

-- 3. Artist 
CREATE TABLE Artist ( 
    ArtistId INT PRIMARY KEY, 
    Name VARCHAR(120) 
); 
select *from artist;
-- 4.  Album 
CREATE TABLE Album ( 
    AlbumId INT PRIMARY KEY, 
    Title VARCHAR(160), 
    ArtistId INT, 
 
    FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId) 
); 
select *from album;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE track
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);




-- 5. Track
CREATE TABLE Track (
	track_id INT PRIMARY KEY,
	name VARCHAR(200),
	album_id INT,
	media_type_id INT,
	genre_id INT,
	composer VARCHAR(220),
	milliseconds INT,
	bytes INT,
	unit_price DECIMAL(10,2),
	FOREIGN KEY (album_id) REFERENCES Album(albumid),
	FOREIGN KEY (media_type_id) REFERENCES MediaType(mediatypeid),
	FOREIGN KEY (genre_id) REFERENCES Genre(genreid)
); 
drop table track ;
select *from track;
SELECT COUNT(*) FROM track;


-- 6. Playlist 
CREATE TABLE Playlist ( 
    PlaylistId INT PRIMARY KEY, 
    Name VARCHAR(255) 
); 

select *from playlist;

-- 7. PlaylistTrack 
CREATE TABLE PlaylistTrack (
	playlist_id INT,
	track_id INT,
	PRIMARY KEY (playlist_id, track_id),
	FOREIGN KEY (playlist_id) REFERENCES Playlist(playlistid),
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
);

select *from playlisttrack;
SELECT COUNT(*) FROM playlisttrack;

-- 8. Employee
CREATE TABLE Employee (
	employee_id INT PRIMARY KEY,
	last_name VARCHAR(120),
	first_name VARCHAR(120),
	title VARCHAR(120),
	reports_to INT,
    levels VARCHAR(255),
	birthdate DATE,
	hire_date DATE,
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100)
);

select *from employee;
drop table employee;
SELECT COUNT(*) FROM employee;


-- 9. Customer 
CREATE TABLE Customer ( 
    CustomerId INT PRIMARY KEY, 
    FirstName VARCHAR(120), 
    LastName VARCHAR(120), 
    Company VARCHAR(120), 
    Address VARCHAR(255), 
    City VARCHAR(100), 
    State VARCHAR(100), 
    Country VARCHAR(100), 
    PostalCode VARCHAR(20), 
    Phone VARCHAR(50), 
    Fax VARCHAR(50), 
    Email VARCHAR(100), 
    SupportRepId INT, 
    FOREIGN KEY (SupportRepId) REFERENCES Employee(Employee_Id) 
); 
select*from customer;
-- 10. Invoice 
CREATE TABLE Invoice ( 
    InvoiceId INT PRIMARY KEY, 
    CustomerId INT, 
    InvoiceDate DATE, 
    BillingAddress VARCHAR(255), 
    BillingCity VARCHAR(100), 
    BillingState VARCHAR(100), 
    BillingCountry VARCHAR(100), 
    BillingPostalCode VARCHAR(20), 
    Total DECIMAL(10,2), 
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) 
); 
select * from invoice;
-- 11. InvoiceLine 
CREATE TABLE InvoiceLine ( 
    InvoiceLineId INT PRIMARY KEY, 
    InvoiceId INT, 
    TrackId INT, 
    UnitPrice DECIMAL(10,2), 
    Quantity INT, 
    FOREIGN KEY (InvoiceId) REFERENCES Invoice(InvoiceId), 
    FOREIGN KEY (TrackId) REFERENCES Track(Track_Id) 
); 

select * from invoiceline;

select*from playlisttrack;

-- --------------------------------------ANALYSIS--------------------------------------------

-- Question 1
-- 1. Who is the senior most employee based on job title?  
SELECT * 
FROM employee
ORDER BY title ASC
LIMIT 1;


-- Question 2
-- 2. Which countries have the most Invoices? 
SELECT BillingCountry, COUNT(*) AS InvoiceCount 
FROM Invoice 
GROUP BY BillingCountry 
ORDER BY InvoiceCount DESC;


-- Question 3
-- What are the top 3 values of total invoice? 
SELECT invoiceid,customerid,Total 
FROM Invoice 
ORDER BY Total DESC 
LIMIT 3;

-- Question 4
-- Which city has the best customers? - We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
SELECT BillingCity, SUM(Total) AS TotalRevenue
FROM Invoice
GROUP BY BillingCity
ORDER BY TotalRevenue DESC
LIMIT 1;

-- Question 5
-- Who is the best customer? - The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money 
SELECT c.CustomerId, c.FirstName, c.LastName, SUM(i.Total) AS TotalSpent
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 1;

-- Question 6
-- Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A 
SELECT DISTINCT c.Email, c.FirstName, c.LastName, g.Name AS Genre
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.Track_Id
JOIN Genre g ON t.Genre_Id = g.GenreId
WHERE g.Name = 'Rock'
ORDER BY c.Email ASC;

-- Question 7
-- Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands 
SELECT ar.Name AS ArtistName, COUNT(t.Track_Id) AS RockTrackCount
FROM Track t
JOIN Genre g ON t.Genre_Id = g.GenreId
JOIN Album al ON t.Album_Id = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
WHERE g.Name = 'Rock'
GROUP BY ar.ArtistId
ORDER BY RockTrackCount DESC
LIMIT 10;

-- Question 8
-- Return all the track names that have a song length longer than the average song length.- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first 
SELECT Name, Milliseconds
FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds) FROM Track)
ORDER BY Milliseconds DESC;

-- Question 9
-- Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent  
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    ar.Name AS ArtistName,
    SUM(il.UnitPrice * il.Quantity) AS TotalSpent
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.Track_Id
JOIN Album al ON t.Album_Id = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY c.CustomerId, ar.ArtistId
ORDER BY TotalSpent DESC;

-- Question 10
-- We want to find out the most popular music Genre for each country. We determine the most 
-- popular genre as the genre with the highest amount of purchases. Write a query that returns 
-- each country along with the top Genre. For countries where the maximum number of purchases 
-- is shared return all Genres 
WITH GenreCounts AS (
    SELECT 
        c.Country,
        g.Name AS GenreName,
        COUNT(il.InvoiceLineId) AS PurchaseCount
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN Track t ON il.TrackId = t.Track_Id
    JOIN Genre g ON t.Genre_Id = g.GenreId
    GROUP BY c.Country, g.GenreId
),
MaxCounts AS (
    SELECT Country, MAX(PurchaseCount) AS MaxPurchase
    FROM GenreCounts
    GROUP BY Country
)
SELECT gc.Country, gc.GenreName, gc.PurchaseCount
FROM GenreCounts gc
JOIN MaxCounts mc ON gc.Country = mc.Country AND gc.PurchaseCount = mc.MaxPurchase
ORDER BY gc.Country;

-- Question 11
--  Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how much they 
-- spent. For countries where the top amount spent is shared, provide all customers who spent this 
-- amount 

WITH CustomerSpending AS (
    SELECT 
        c.CustomerId,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        c.Country,
        SUM(i.Total) AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
),
MaxSpenders AS (
    SELECT Country, MAX(TotalSpent) AS MaxSpent
    FROM CustomerSpending
    GROUP BY Country
)
SELECT cs.Country, cs.CustomerName, cs.TotalSpent
FROM CustomerSpending cs
JOIN MaxSpenders ms ON cs.Country = ms.Country AND cs.TotalSpent = ms.MaxSpent
ORDER BY cs.Country;
