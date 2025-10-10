/*
    Note: Because of referential integrity, the order
    when we insert records here will matter. When you
    execute this script, you have to ensure that there
    will be no duplicates in the existing table OR that
    your tables are currently empty.
    
    Additionally, make sure to modify the tables of your
    database to reflect the changes we made after the
    initial creation of the tables.
*/

-- This inserts 5 records to the Student table
INSERT INTO Student (StudentID, FirstName, LastName, DateOfBirth) VALUES
    (10001, 'Alice', 'Johnson', '2004-03-15'),
    (10002, 'Brian', 'Lopez',   '2003-07-22'),
    (10003, 'Catherine', 'Nguyen', '2005-01-10'),
    (10004, 'David', 'Smith',   '2002-11-30'),
    (10005, 'Ella', 'Martinez', '2004-09-05');


-- This inserts 5 records to the Course table
INSERT INTO Course (CourseCode, Title, CreditHour) VALUES
	('COP3223', 'Introduction to Programming in C', 3),
	('COP3330', 'Object-Oriented Programming in Java', 3),
	('COP3502', 'Computer Science I', 3),
	('CDA3103', 'Computer Logic and Organization', 5),
	('CNT3004', 'Computer Networks', 5);


-- This inserts 12 records to the Registration table
INSERT INTO Registration (Semester, Grade, OwnerID, CourseCode) VALUES
	('Su25', 'A', 10001, 'COP3223'),
	('Fa24', 'B+', 10002, 'COP3223'),
	('Fa24', 'A-', 10003, 'COP3223'),
	('Sp25', 'A', 10001, 'COP3330'),
	('Sp25', 'B', 10004, 'COP3330'),
	('Sp25', 'A', 10005, 'COP3502'),
	('Fa24', 'B+', 10002, 'COP3502'),
	('Su25', 'A-', 10003, 'CDA3103'),
	('Su25', 'B', 10004, 'CNT3004'),
	('Fa24', 'F', 10001, 'COP3223'),
	('Sp25', 'D', 10001, 'COP3223'),
	('Su24', 'C-', 10003, 'COP3223');