CREATE DATABASE university;

SHOW DATABASES;

USE university;

CREATE TABLE Student (
	StudentID		INT,
	FirstName		VARCHAR(50),
	LastName		VARCHAR(50),
CONSTRAINT pk_student PRIMARY KEY (StudentID)
);

SHOW TABLES;

CREATE TABLE Course (
	CourseCode		CHAR(7),
	Title			VARCHAR(100),
CONSTRAINT pk_course PRIMARY KEY (CourseCode)
);

CREATE TABLE Registration (
	Semester		CHAR(4),
	Grade			VARCHAR(2),
	OwnerID			INT,
	CourseCode		CHAR(7),
CONSTRAINT pk_registration PRIMARY KEY (OwnerID, CourseCode),
CONSTRAINT fk_registation_student FOREIGN KEY (OwnerID)
	REFERENCES Student(StudentID),
CONSTRAINT fk_registation_course FOREIGN KEY (CourseCode)
	REFERENCES Course(CourseCode)
);