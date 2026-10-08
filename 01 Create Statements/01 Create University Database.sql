-- Create the database with name university
CREATE DATABASE university;

-- Indicate that we will use the university database
-- for succeeding queries
USE university;

-- Create the Student table
CREATE TABLE Student (
    StudentID       INT,
    FirstName       VARCHAR(100) NOT NULL,
    LastName        VARCHAR(100) NOT NULL,
    DateOfBirth     DATE NOT NULL,
    Email           VARCHAR(100) NOT NULL,
    Major           VARCHAR(50),
    IsActive        BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT pk_student
        PRIMARY KEY (StudentID),
    CONSTRAINT uq_student_email
        UNIQUE (Email)
);

-- Create the Course table
CREATE TABLE Course (
    CourseCode      VARCHAR(10),
    CourseTitle     VARCHAR(100) NOT NULL,
    CreditHours     INT NOT NULL,
    
    CONSTRAINT pk_course
        PRIMARY KEY (CourseCode)
);

-- Create the Registration table
CREATE TABLE Registration (
    CourseCode      VARCHAR(10) NOT NULL,
    OwnerID         INT NOT NULL,
    Semester        VARCHAR(10) NOT NULL,
    SemesterYear    INT NOT NULL,
    Grade           VARCHAR(5),
    
    CONSTRAINT pk_registration
        PRIMARY KEY (CourseCode, OwnerID, Semester, SemesterYear),
    CONSTRAINT fk_registration_course
        FOREIGN KEY (CourseCode)
            REFERENCES Course(CourseCode),
    CONSTRAINT fk_registration_student
        FOREIGN KEY (OwnerID)
            REFERENCES Student(StudentID)
);


SELECT * FROM Course;

INSERT INTO Course (CourseCode, CourseTitle, CreditHours)
VALUES
    ('CGS2545', 'Database Concepts', 3);

SELECT * FROM Course;

INSERT INTO Course (CourseCode, CourseTitle, CreditHours)
VALUES
    ('COP3223', 'Introduction to Programming in C', 3),
    ('COP3502', 'Computer Science I', 3),
    ('MAC2311', 'Calculus I', 4);
    
SELECT * FROM Course;

SELECT * FROM Student;

INSERT INTO Student (StudentID, FirstName, LastName, DateOfBirth, Email, Major)
VALUES
    (1234567, 'John', 'Doe', '2000-10-06', 'john@ucf.edu', NULL),
    (2345678, 'Maria', 'Cruz', '2005-11-06', 'maria@ucf.edu', 'Information Technology');
    
SELECT * FROM Student;

SELECT * FROM Registration;

INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('CGS2545', 1234567, 'Fall', 2026, NULL),
    ('COP3223', 1234567, 'Summer', 2026, 'B+'),
    ('COP3502', 2345678, 'Spring', 2025, 'A');
    
SELECT * FROM Registration;

INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('COP3503', 2345678, 'Fall', 2026, NULL);

INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('CGS2545', 1234567, 'Fall', 2026, 'A+');

-- create the department table
CREATE TABLE Department (
    DeptID          INT,
    DeptName        VARCHAR(100) NOT NULL,
    
    CONSTRAINT pk_department
        PRIMARY KEY (DeptID)
);

SELECT * FROM Department;

INSERT INTO Department (DeptID, DeptName)
VALUES
    (1, 'Computer Science'),
    (2, 'Mathematics');

SELECT * FROM Department;

ALTER TABLE Course
ADD COLUMN DeptID INT NOT NULL DEFAULT 0,
ADD CONSTRAINT fk_course_department
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID);
    
SELECT * FROM Course;

INSERT INTO Department (DeptID, DeptName)
VALUES
    (0, 'Unassigned');
    
SELECT * FROM Department;

ALTER TABLE Course
ADD COLUMN DeptID INT NOT NULL DEFAULT 0,
ADD CONSTRAINT fk_course_department
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID);
    
SELECT * FROM Course;


UPDATE Course
SET DeptID = 1
WHERE CourseCode = 'CGS2545';

SELECT * FROM Course;

UPDATE Course
SET DeptID = 1
WHERE CourseCode = 'COP3223' OR CourseCode = 'COP3502';

SELECT * FROM Course;

UPDATE Course
SET DeptID = 2
WHERE CourseCode = 'MAC2311';

SELECT * FROM Course;

SELECT * FROM Registration;

/* 
Comments go here. 
*/
UPDATE Registration
SET Grade = 'F'
WHERE CourseCode = 'CGS2545'
    AND OwnerID = 1234567
    AND Semester = 'Fall'
    AND SemesterYear = 2026;
    
SELECT * FROM Registration;



















