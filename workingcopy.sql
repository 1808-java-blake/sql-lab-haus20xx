SET SCHEMA 'chinook';

-- -- NOTE: All working code is single commented, all instructions/headers are double commented
-- -- so that if you "Ctrl + ." (or your uncomment shortcut of choice)   a section of code instructions will be preserved as comments
-- -- while working code will become functional.

-- -- Part I – Working with an existing database

-- -- 1.0	Setting up Oracle Chinook
-- -- In this section you will begin the process of working with the Oracle Chinook database
-- -- Task – Open the Chinook_Oracle.sql file and execute the scripts within.

-- -- 2.0 SQL Queries
-- -- In this section you will be performing various queries against the Oracle Chinook database.
-- -- 2.1 SELECT
-- -- Task – Select all records from the Employee table.
-- SELECT * FROM employee;

-- --  Task – Select all records from the Employee table where last name is King.
-- SELECT * FROM employee
-- 	WHERE lastname = 'King';

-- -- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
-- SELECT * FROM employee
-- 	WHERE firstname = 'Andrew'
-- 	AND reportsto isnull;

-- -- 2.2 ORDER BY
-- -- Task – Select all albums in Album table and sort result set in descending order by title.
-- SELECT * FROM album
-- 	ORDER BY title desc;

-- -- Task – Select first name from Customer and sort result set in ascending order by city
-- SELECT firstname FROM customer
-- 	ORDER BY city asc;

-- -- 2.3 INSERT INTO
-- -- Task – Insert two new records into Genre table
-- INSERT INTO genre(genreid, "name")
-- 	VALUES(42, 'collective'),(99,'advantgarde');
-- -- Task – Insert two new records into Employee table
-- INSERT INTO employee(employeeid,lastname,firstname,title,reportsto,
-- 			birthdate,hiredate,address,city,"state",country,postalcode,phone,fax,email)
-- 	VALUES (9,'House','Kenneth','Head Honcho',null,TIMESTAMP '1996-08-08 00:00:00', now(),'123 Mustard drive','Condominant','Fl'
-- 		   ,'USA',12345,'9043168012',12345,'nospam@spampls.com'),(10,'Home','Kenny','Shoulder Honcho',null,TIMESTAMP '1996-08-07 00:00:00', now(),'123 Ketchup drive','Condominant','Fl'
-- 		   ,'USA',12345,'9043169999',12345,'try2spam@spampls.com');
-- -- Task – Insert two new records into Customer table
-- INSERT INTO customer()

-- -- 2.4 UPDATE
-- -- Task – Update Aaron Mitchell in Customer table to Robert Walter
-- UPDATE customer
-- SET firstname = 'Robert', lastname = 'Walter'
-- WHERE firstname = 'Aaron'
-- AND lastname = 'Mitchell';
-- SELECT * FROM customer;

-- -- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
-- UPDATE artist
-- SET name = 'CCR'
-- WHERE name = 'Creedence Clearwater Revival';
-- Select * FROM artist;

-- -- 2.5 LIKE
-- -- Task – Select all invoices with a billing address like “T%”
-- SELECT * FROM invoice
-- 	WHERE billingaddress LIKE 'T%';

-- -- 2.6 BETWEEN
-- -- Task – Select all invoices that have a total between 15 and 50
-- SELECT * FROM invoice
-- 	WHERE total BETWEEN 15 AND 50;

-- -- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
-- SELECT * FROM employee
-- 	WHERE hiredate
-- 	BETWEEN TIMESTAMP '2003-6-1 00:00:00' AND TIMESTAMP '2004-3-1 00:00:00';

-- -- 2.7 DELETE
-- -- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
-- DELETE FROM invoiceline
-- 	WHERE invoiceid IN(
-- 	SELECT invoiceid FROM invoice
-- 	WHERE customerid IN(
-- 		SELECT customerid FROM customer
-- 			WHERE firstname = 'Robert' AND
-- 			lastname = 'Walter'));

-- DELETE FROM invoice 
-- 	WHERE customerid IN (
-- 	SELECT customerid FROM customer
-- 			WHERE firstname = 'Robert' AND
-- 			lastname = 'Walter');

-- DELETE FROM customer
-- 	WHERE firstname = 'Robert' AND
-- 	lastname = 'Walter';
-- SELECT * FROM customer;

-- -- 3.0	SQL Functions
-- -- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- -- 3.1 System Defined Functions
-- -- Task – Create a function that returns the current time.
-- CREATE OR REPLACE FUNCTION currentTimeUser()
-- RETURNS TIMESTAMP AS $$
-- BEGIN
-- 	RETURN now();
-- END;
-- $$ LANGUAGE plpgsql;
-- SELECT currentTimeUser();

-- -- Task – create a function that returns the length of a mediatype from the mediatype table
-- CREATE OR REPLACE FUNCTION lengthOfMediaType(mediaid INTEGER)
-- RETURNS INTEGER as $$
-- BEGIN
-- 	RETURN length("name") FROM mediatype
-- 				 WHERE mediatypeid = mediaid;
-- END;
-- $$ LANGUAGE plpgsql;
-- SELECT lengthOfMediaType(1);

-- -- 3.2 System Defined Aggregate Functions
-- -- Task – Create a function that returns the average total of all invoices
-- SELECT CAST(avg(total) AS NUMERIC(10,2)) from invoice;
-- -- Task – Create a function that returns the most expensive track
-- SELECT MAX(unitprice) FROM track;

-- -- 3.3 User Defined Scalar Functions
-- -- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
-- CREATE OR REPLACE FUNCTION avgPrice()
-- RETURNS NUMERIC(10,2) AS $$
-- BEGIN
-- 	RETURN CAST(AVG(unitprice) AS NUMERIC(10,2)) FROM invoiceline;
-- END;
-- $$ LANGUAGE plpgsql;
-- SELECT avgPrice();

-- -- 3.4 User Defined Table Valued Functions
-- -- Task – Create a function that returns all employees who are born after 1968.
-- CREATE OR REPLACE FUNCTION oldEmployees()
-- RETURNS SETOF employee AS $$
-- 	SELECT * FROM employee
-- 	WHERE hiredate > TIMESTAMP '1968-12-31 23:59:59';
-- $$ LANGUAGE sql;
-- SELECT * FROM oldEmployees();

-- -- 4.0 Stored Procedures
--  -- In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- -- 4.1 Basic Stored Procedure
-- -- Task – Create a stored procedure that selects the first and last names of all the employees.
-- CREATE OR REPLACE FUNCTION fAndLEmployees()
-- RETURNS TABLE(fName VARCHAR(100), lName VARCHAR(100)) as $$
-- 	BEGIN
-- 		RETURN QUERY
-- 		SELECT firstname, lastname FROM employee;
-- 	END;
-- $$ LANGUAGE plpgsql;
-- SELECT * FROM fAndLEmployees();

-- -- 4.2 Stored Procedure Input Parameters
-- -- Task – Create a stored procedure that updates the personal information of an employee.
-- CREATE OR REPLACE FUNCTION updateEmployee(eid INTEGER,lname VARCHAR,fname VARCHAR,emailAddress VARCHAR)
-- RETURNS void AS $$
-- BEGIN
-- 	UPDATE employee
-- 	SET lastname = lname, firstname = fname , email = emailAddress
-- 	WHERE employeeid = eid;
-- END;
-- $$ LANGUAGE plpgsql;
--ONLY updates employee name and email but could easily extend to all other fields

-- -- Task – Create a stored procedure that returns the managers of an employee.
-- CREATE OR REPLACE FUNCTION whoManages(eid INTEGER)
-- RETURNS SETOF employee AS $$
-- BEGIN
-- 	RETURN QUERY SELECT * FROM employee 
-- 	WHERE employeeid IN(SELECT reportsto
-- 						FROM employee
-- 						WHERE employeeid=eid);
-- END;
-- $$ LANGUAGE plpgsql;
-- SELECT * FROM whoManages(2);

-- -- 4.3 Stored Procedure Output Parameters
-- -- Task – Create a stored procedure that returns the name and company of a customer.
-- CREATE OR REPLACE FUNCTION showUserInfo(cid INTEGER)
-- RETURNS TABLE(cfname VARCHAR,clname VARCHAR, ccompany VARCHAR) AS $$
-- BEGIN
-- 	RETURN QUERY
-- 	SELECT firstname, lastname, company FROM customer
-- 	WHERE customerid = cid;
-- END;
-- $$ LANGUAGE plpgsql;
-- SELECT * FROM showUserInfo(1);

-- -- 5.0 Transactions
-- -- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- -- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
-- CREATE OR REPLACE FUNCTION deleteFromInvoice(to_delete INTEGER)
-- RETURNS VOID as $$
-- BEGIN
	-- DELETE FROM invoiceline WHERE invoiceid = to_delete;
	-- DELETE FROM invoice WHERE invoiceid = to_delete;
-- END;
-- $$ LANGUAGE plpgsql;

-- SELECT deleteFromInvoice(2);

-- --Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
-- CREATE OR REPLACE FUNCTION insertIntoCustomer(cust_id VARCHAR, first_name VARCHAR, last_name VARCHAR, email_address VARCHAR)
-- RETURNS VOID AS $$
-- BEGIN
	-- INSERT INTO customer(customerid,firstname,lastname,email) VALUES (cust_id,first_name,last_name,email_address);
-- END;
-- $$ LANGUAGE plpgsql;

-- SELECT insertIntoCustomer(200,'k','h','kh@com.com');

-- -- 6.0 Triggers
-- -- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- --6.1 AFTER/FOR
-- -- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE TRIGGER after_insert_trig
	AFTER INSERT ON employee
	FOR EACH ROW
	EXECUTE PROCEDURE foo_trig_funct();
-- -- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE TRIGGER after_update_trig
	AFTER INSERT ON album
	FOR EACH ROW
	EXECUTE PROCEDURE foo_trig_funct();
-- --Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE TRIGGER after_delete_trig
	AFTER DELETE ON employee
	FOR EACH ROW
	EXECUTE PROCEDURE foo_trig_funct();

-- --6.2 INSTEAD OF
-- --Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
-- CREATE TRIGGER prevent_delete_trig
	-- BEFORE DELETE ON invoice
		-- FOR EACH ROW
		-- EXECUTE Procedure foo_trig_funct2();

-- CREATE OR REPLACE FUNCTION foo_trig_funct2()
-- RETURNS TRIGGER AS $$
-- BEGIN
	-- IF old.total > 50
	-- THEN 
	-- RETURN null;
	-- ELSE
	-- RETURN OLD;
	-- END IF;
-- END;
-- $$ LANGUAGE plpgsql;


-- -- 7.0 JOINS
-- -- In this section you swill be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- -- 7.1 INNER
-- -- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
-- SELECT firstname, lastname, invoiceid FROM customer INNER JOIN
-- 	invoice USING(customerid);

-- -- 7.2 OUTER
-- -- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
-- SELECT customer.customerid, customer.firstname, customer.lastname, invoiceid, total 
-- 	FROM customer FULL OUTER JOIN invoice USING(customerid);

-- -- 7.3 RIGHT
-- -- Task – Create a right join that joins album and artist specifying artist name and title.
-- SELECT artist.name, album.title FROM album RIGHT JOIN
-- 	artist USING(artistid);
-- -- 7.4 CROSS
-- -- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
-- SELECT artist.name, album.title FROM album CROSS JOIN artist
-- 	ORDER BY artist.name asc;

-- -- 7.5 SELF
-- -- Task – Perform a self-join on the employee table, joining on the reportsto column.

-- SELECT * FROM employee AS t1 JOIN employee AS t2 ON t1.reportsto=t2.employeeid;







