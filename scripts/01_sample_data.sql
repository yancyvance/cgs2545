/*
    Note: Because of referential integrity, the order
    when we insert records here will matter. When you
    execute this script, you have to ensure that there
    will be no duplicates in the existing table OR that
    your tables are currently empty.
*/

-- This inserts 5 records to the Student table
INSERT INTO Student (StudentID, FirstName, LastName) VALUES
	(10001, 'Alice', 'Johnson'),
	(10002, 'Brian', 'Lopez'),
	(10003, 'Catherine', 'Nguyen'),
	(10004, 'David', 'Smith'),
	(10005, 'Ella', 'Martinez');


-- This inserts 5 records to the Course table
INSERT INTO Course (CourseCode, Title) VALUES
	('COP3223', 'Introduction to Programming in C'),
	('COP3330', 'Object-Oriented Programming in Java'),
	('COP3502', 'Computer Science I'),
	('CDA3103', 'Computer Logic and Organization'),
	('CNT3004', 'Computer Networks');


-- This inserts 10 records to the Registration table
INSERT INTO Registration (Semester, Grade, OwnerID, CourseCode) VALUES
	('Fa24', 'A', 10001, 'COP3223'),
	('Fa24', 'B+', 10002, 'COP3223'),
	('Fa24', 'A-', 10003, 'COP3223'),
	('Sp25', 'A', 10001, 'COP3330'),
	('Sp25', 'B', 10004, 'COP3330'),
	('Sp25', 'A', 10005, 'COP3502'),
	('Fa24', 'B+', 10002, 'COP3502'),
	('Su25', 'A-', 10003, 'CDA3103'),
	('Su25', 'B', 10004, 'CNT3004'),
	('Su25', 'A', 10001, 'CNT3004');