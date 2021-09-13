

--DBMD LECTURE
--UNIVERSITY DATABASE PROJECT 



--CREATE DATABASE
create database university

use university;
--//////////////////////////////


--CREATE TABLES 

create table Student 
(
	Student_id int not null primary key,
	region_id int not null,
	staff_id int not null,
	firstName varchar(max),
	lastName varchar(max),
	registerDate date
);


create table staff
(
	staff_id int not null primary key,
	region_id int not null,
	firstName varchar(max),
	lastName varchar(max)
);

create table course
(
	course_id int not null primary key,
	title varchar(max),
	Credit int
);

create table Region
(
	region_id int not null primary key,
	regionName varchar(max)
);

create table Enrollment
(
	student_id int not null,
	course_id int not null,
	primary key (student_id, course_id),
	FOREIGN KEY (student_id) REFERENCES student(student_id),
	FOREIGN KEY (course_id) REFERENCES course(course_id)
)

create table staffCourse
(
	staff_id int not null,
	course_id int not null,
	primary key (staff_id, course_id),
	foreign key (staff_id) references staff(staff_id),
	foreign key (course_id) references course(course_id)
)


alter table student
add constraint fk_region_id foreign key (region_id) references region(region_id);

alter table student
add constraint fk_staff_id foreign key (staff_id) references staff(staff_id);

alter table staff
add constraint fk2_region_id foreign key (region_id) references region(region_id);


--Make sure you add the necessary constraints.
--You can define some check constraints while creating the table, 
--but some you must define later with the help of a scalar-valued function you'll write.
--Check whether the constraints you defined work or not.
--Import Values (Use the Data provided in the Github repo). 
--You must create the tables as they should be and define the constraints as they should be. 
--You will be expected to get errors in some points. If everything is not as it should be, 
--you will not get the expected results or errors.
--Read the errors you will get and try to understand the cause of the errors.







--////////////////////


--CONSTRAINTS

--1. Students are constrained in the number of courses they can be enrolled in at any one time. 
--	 They may not take courses simultaneously if their combined points total exceeds 180 points.

ALTER TABLE course
ADD CONSTRAINT CHK_credit CHECK (credit<=180);







--------///////////////////


--2. The student's region and the counselor's region must be the same.
ALTER TABLE student
ADD constraint chk_region_id check (region_id = (select region_id from staff)) 



    
);










--///////////////////////////////



------ADDITIONALLY TASKS



--1. Test the credit limit constraint.






--//////////////////////////////////

--2. Test that you have correctly defined the constraint for the student counsel's region. 






--/////////////////////////


--3. Try to set the credits of the History course to 20. (You should get an error.)





--/////////////////////////////

--4. Try to set the credits of the Fine Arts course to 30.(You should get an error.)





--////////////////////////////////////

--5. Debbie Orange wants to enroll in Chemistry instead of German. (You should get an error.)








--//////////////////////////


--6. Try to set Tom Garden as counsel of Alec Hunter (You should get an error.)





--/////////////////////////

--7. Swap counselors of Ursula Douglas and Bronwin Blueberry.






--///////////////////


--8. Remove a staff member from the staff table.
--	 If you get an error, read the error and update the reference rules for the relevant foreign key.





 



















