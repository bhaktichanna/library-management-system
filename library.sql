-- Create the Library database
CREATE DATABASE Library;

-- Use the Library database
USE Library;

-- Create Authors table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL
);

-- Create Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Genre VARCHAR(100),
    PublishedDate DATE,
    Quantity INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create Members table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    JoinDate DATE NOT NULL
);

-- Create BorrowRecords table
CREATE TABLE BorrowRecords (
    BorrowID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
2. Inserting Data
Now, let's insert some sample data into these tables.

sql
Copy code
-- Insert data into Authors table
INSERT INTO Authors (Name) VALUES
('F. Scott Fitzgerald'),
('J.K. Rowling'),
('George Orwell');

-- Insert data into Books table
INSERT INTO Books (Title, AuthorID, Genre, PublishedDate, Quantity) VALUES
('The Great Gatsby', 1, 'Fiction', '1925-04-10', 10),
('Harry Potter and the Sorcerer''s Stone', 2, 'Fantasy', '1997-06-26', 15),
('1984', 3, 'Dystopian', '1949-06-08', 5);

-- Insert data into Members table
INSERT INTO Members (Name, Email, JoinDate) VALUES
('John Doe', 'johndoe@example.com', '2024-05-01'),
('Jane Smith', 'janesmith@example.com', '2024-05-02');

-- Insert data into BorrowRecords table
INSERT INTO BorrowRecords (MemberID, BookID, BorrowDate, ReturnDate) VALUES
(1, 1, '2024-05-10', NULL),
(2, 2, '2024-05-11', '2024-05-20');

INSERT INTO Books (Title, AuthorID, Genre, PublishedDate, Quantity)
VALUES ('Animal Farm', 3, 'Political Satire', '1945-08-17', 7);


Sure, let's dive deeper into the Library Management System project with more detailed SQL code examples.

1. Creating the Database and Tables
First, we need to create the database and the necessary tables.

sql
Copy code
-- Create the Library database
CREATE DATABASE Library;

-- Use the Library database
USE Library;

-- Create Authors table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL
);

-- Create Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Genre VARCHAR(100),
    PublishedDate DATE,
    Quantity INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create Members table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    JoinDate DATE NOT NULL
);

-- Create BorrowRecords table
CREATE TABLE BorrowRecords (
    BorrowID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
2. Inserting Data
Now, let's insert some sample data into these tables.

sql
Copy code
-- Insert data into Authors table
INSERT INTO Authors (Name) VALUES
('F. Scott Fitzgerald'),
('J.K. Rowling'),
('George Orwell');

-- Insert data into Books table
INSERT INTO Books (Title, AuthorID, Genre, PublishedDate, Quantity) VALUES
('The Great Gatsby', 1, 'Fiction', '1925-04-10', 10),
('Harry Potter and the Sorcerer''s Stone', 2, 'Fantasy', '1997-06-26', 15),
('1984', 3, 'Dystopian', '1949-06-08', 5);

-- Insert data into Members table
INSERT INTO Members (Name, Email, JoinDate) VALUES
('John Doe', 'johndoe@example.com', '2024-05-01'),
('Jane Smith', 'janesmith@example.com', '2024-05-02');

-- Insert data into BorrowRecords table
INSERT INTO BorrowRecords (MemberID, BookID, BorrowDate, ReturnDate) VALUES
(1, 1, '2024-05-10', NULL),
(2, 2, '2024-05-11', '2024-05-20');
3. Querying the Database
Here are some example queries to interact with the database.

Adding a New Book

sql
Copy code
INSERT INTO Books (Title, AuthorID, Genre, PublishedDate, Quantity)
VALUES ('Animal Farm', 3, 'Political Satire', '1945-08-17', 7);
Registering a New Member

sql
Copy code
INSERT INTO Members (Name, Email, JoinDate)
VALUES ('Alice Johnson', 'alicejohnson@example.com', '2024-05-15');
Recording a Book Borrow

sql
Copy code
INSERT INTO BorrowRecords (MemberID, BookID, BorrowDate, ReturnDate)
VALUES (3, 3, '2024-05-21', NULL);
Listing All Overdue Books

sql
Copy code
SELECT Members.Name, Books.Title, BorrowRecords.BorrowDate
FROM BorrowRecords
JOIN Members ON BorrowRecords.MemberID = Members.MemberID
JOIN Books ON BorrowRecords.BookID = Books.BookID
WHERE BorrowRecords.ReturnDate IS NULL AND BorrowRecords.BorrowDate < DATE_SUB(CURDATE(), INTERVAL 30 DAY);
Updating Book Quantity After Borrow

sql
Copy code
UPDATE Books
SET Quantity = Quantity - 1
WHERE BookID = 3;
Checking Available Books

sql
Copy code
SELECT Title, Quantity
FROM Books
WHERE Quantity > 0;
Returning a Book

When a book is returned, we need to update the ReturnDate in BorrowRecords and increase the Quantity in Books.

sql
Copy code
-- Update return date
UPDATE BorrowRecords
SET ReturnDate = '2024-06-01'
WHERE BorrowID = 1;

-- Increase book quantity
UPDATE Books
SET Quantity = Quantity + 1
WHERE BookID = 1;
4. Creating Views and Stored Procedures
Creating a View for Borrowed Books

sql
Copy code
CREATE VIEW BorrowedBooks AS
SELECT 
    BorrowRecords.BorrowID,
    Members.Name AS MemberName,
    Books.Title AS BookTitle,
    BorrowRecords.BorrowDate,
    BorrowRecords.ReturnDate
FROM 
    BorrowRecords
JOIN 
    Members ON BorrowRecords.MemberID = Members.MemberID
JOIN 
    Books ON BorrowRecords.BookID = Books.BookID
WHERE 
    BorrowRecords.ReturnDate IS NULL;
Stored Procedure to Add a New Book

sql
Copy code
DELIMITER //

CREATE PROCEDURE AddNewBook (
    IN p_Title VARCHAR(255),
    IN p_AuthorID INT,
    IN p_Genre VARCHAR(100),
    IN p_PublishedDate DATE,
    IN p_Quantity INT
)
BEGIN
    INSERT INTO Books (Title, AuthorID, Genre, PublishedDate, Quantity)
    VALUES (p_Title, p_AuthorID, p_Genre, p_PublishedDate, p_Quantity);
END //

DELIMITER ;
Stored Procedure to Borrow a Book

sql
Copy code
DELIMITER //

CREATE PROCEDURE BorrowBook (
    IN p_MemberID INT,
    IN p_BookID INT,
    IN p_BorrowDate DATE
)
BEGIN
    DECLARE available INT;

    -- Check availability
    SELECT Quantity INTO available
    FROM Books
    WHERE BookID = p_BookID;

    IF available > 0 THEN
        -- Insert borrow record
        INSERT INTO BorrowRecords (MemberID, BookID, BorrowDate, ReturnDate)
        VALUES (p_MemberID, p_BookID, p_BorrowDate, NULL);
        
        -- Decrease book quantity
        UPDATE Books
        SET Quantity = Quantity - 1
        WHERE BookID = p_BookID;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book not available';
    END IF;
END //

DELIMITER ;
