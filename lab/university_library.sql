-- This script creates a database called university_library
-- It will create the necessary tables based on the database model
-- It will also populate the tables with fictional data

CREATE DATABASE university_library;

USE university_library;

CREATE TABLE Author (
    AuthorID        INT AUTO_INCREMENT,
    FirstName       VARCHAR(100) NOT NULL,
    LastName        VARCHAR(100) NOT NULL,
CONSTRAINT pk_author PRIMARY KEY (AuthorID)
);

CREATE TABLE Book (
    ISBN            VARCHAR(20),
    Title           VARCHAR(100) NOT NULL,
    Publisher       VARCHAR(100) NOT NULL,
    IsReference     BOOLEAN,
CONSTRAINT pk_book PRIMARY KEY (ISBN)
);

CREATE TABLE Student (
    StudentID       INT,
    FirstName       VARCHAR(100) NOT NULL,
    LastName        VARCHAR(100) NOT NULL,
    Email           VARCHAR(100) NOT NULL UNIQUE,
    Major           VARCHAR(100),
    IsActive        BOOLEAN,
CONSTRAINT pk_student PRIMARY KEY (StudentID)
);

CREATE TABLE Staff (
    StaffID         INT,
    FirstName       VARCHAR(100) NOT NULL,
    LastName        VARCHAR(100) NOT NULL,
CONSTRAINT pk_staff PRIMARY KEY (StaffID)
);

CREATE TABLE BookAuthor (
    BookAuthorID    INT AUTO_INCREMENT,             -- surrogate key
    ISBN            VARCHAR(20) NOT NULL,
    AuthorID        INT NOT NULL,
CONSTRAINT pk_book_author PRIMARY KEY (BookAuthorID),
CONSTRAINT fk_book_author_book FOREIGN KEY (ISBN)
    REFERENCES Book(ISBN),
CONSTRAINT fk_book_author_author FOREIGN KEY (AuthorID)
    REFERENCES Author(AuthorID),
CONSTRAINT uq_book_author UNIQUE (ISBN, AuthorID)   -- to ensure no duplicates due to surrogate key
);

CREATE TABLE BookCopy (
    Barcode         VARCHAR(100),
    AcquiredDate    DATE NOT NULL,
    ISBN            VARCHAR(20) NOT NULL,
CONSTRAINT pk_bookcopy PRIMARY KEY (Barcode),
CONSTRAINT fk_bookcopy_book FOREIGN KEY (ISBN)
    REFERENCES Book(ISBN)
);

CREATE TABLE Borrow (
    BorrowID            INT AUTO_INCREMENT,
    CheckoutDate        DATETIME NOT NULL,
    DueDate             DATETIME NOT NULL,
    ReturnDate          DATETIME,
    Fine                DOUBLE,
    CheckoutStaffID     INT NOT NULL,
    ReturnStaffID       INT,                        -- it can be null if not yet returned
    Barcode             VARCHAR(100) NOT NULL,
    StudentID           INT NOT NULL,
CONSTRAINT pk_borrow PRIMARY KEY (BorrowID),
CONSTRAINT fk_borrow_staff_checkout FOREIGN KEY (CheckoutStaffID)
    REFERENCES Staff(StaffID),
CONSTRAINT fk_borrow_staff_return FOREIGN KEY (ReturnStaffID)
    REFERENCES Staff(StaffID),
CONSTRAINT fk_borrow_bookcopy FOREIGN KEY (Barcode)
    REFERENCES BookCopy(Barcode),
CONSTRAINT fk_borrow_student FOREIGN KEY (StudentID)
    REFERENCES Student(StudentID)
);



INSERT INTO Student (StudentID, FirstName, LastName, Email, Major, IsActive) VALUES
    (1001, 'Alice', 'Johnson', 'alice.johnson@univ.edu', 'Computer Science', TRUE),
    (1002, 'Bob', 'Smith', 'bob.smith@univ.edu', 'Literature', TRUE),
    (1003, 'Clara', 'Nguyen', 'clara.nguyen@univ.edu', 'Biology', FALSE),
    (1004, 'David', 'Sanders', 'david.patel@univ.edu', 'History', TRUE),
    (1005, 'Emma', 'Brown', 'emma.brown@univ.edu', 'Physics', TRUE);
    
INSERT INTO Author (AuthorID, FirstName, LastName) VALUES
    (1, 'Jane', 'Austen'),
    (2, 'George', 'Orwell'),
    (3, 'Mary', 'Shelley'),
    (4, 'J.K.', 'Rowling'),
    (5, 'F. Scott', 'Fitzgerald');
    
INSERT INTO Book (ISBN, Title, Publisher, IsReference) VALUES
    ('9780141439518', 'Pride and Prejudice', 'Penguin Classics', FALSE),
    ('9780451524935', '1984', 'Signet Classics', FALSE),
    ('9780486282114', 'Frankenstein', 'Dover Publications', FALSE),
    ('9780439139595', 'Harry Potter and the Goblet of Fire', 'Scholastic', FALSE),
    ('9781743273565', 'The Great Gatsby', 'Scribner', TRUE);

INSERT INTO BookAuthor (BookAuthorID, ISBN, AuthorID) VALUES
    (1, '9780141439518', 1),
    (2, '9780451524935', 2),
    (3, '9780486282114', 3),
    (4, '9780439139595', 4),
    (5, '9781743273565', 5);

INSERT INTO BookCopy (Barcode, ISBN, AcquiredDate) VALUES
    ('BC1001', '9780141439518', '2021-02-10'),
    ('BC1002', '9780141439518', '2022-03-15'),
    ('BC2001', '9780451524935', '2020-11-01'),
    ('BC3001', '9780486282114', '2023-05-22'),
    ('BC4001', '9780439139595', '2021-02-19'),
    ('BC5001', '9781743273565', '2019-09-10');

INSERT INTO Staff (StaffID, FirstName, LastName) VALUES
    (1, 'Linda', 'Moore'),
    (2, 'Kevin', 'Turner'),
    (3, 'Salim', 'Rahman');

INSERT INTO Borrow (BorrowID, CheckoutDate, DueDate, ReturnDate, Fine, CheckoutStaffID, ReturnStaffID, Barcode, StudentID) VALUES
    (1, '2024-09-01', '2024-09-15', '2024-09-14', NULL, 3, 1, 'BC1002', 1001),
    (2, '2024-10-10', '2024-10-24', '2024-11-11', 7, 1, 1, 'BC2001', 1002),
    (3, '2024-11-05', '2024-11-19', '2024-11-10', NULL, 2, 2, 'BC4001', 1005),
    (4, '2024-08-20', '2024-09-03', '2024-09-06', 3, 2, 2, 'BC3001', 1003),
    (5, '2024-12-01', '2024-12-15', '2024-12-13', NULL, 3, 1, 'BC1002', 1001);
