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