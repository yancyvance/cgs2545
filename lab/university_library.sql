-- This script creates a database called university_library
-- It will also create the necessary tables based on the database model

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