Create Database Performance_Data ;
/* 3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and 
DEPARTMENT from the employee record table, and make a list of 
employees and details of their department
*/

Select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT from emp_record_table ; 


/* 4.Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, 
DEPARTMENT, and EMP_RATING if the EMP_RATING is:
• less than two
• greater than four
• between two and four */

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, 
DEPT , EMP_RATING
from emp_record_table
where EMP_RATING < 2;

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, 
DEPT , EMP_RATING
from emp_record_table
where EMP_RATING > 4;

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, 
DEPT , EMP_RATING
from emp_record_table
where EMP_RATING between 2 and 4 ;

/*5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of 
employees in the Finance department from the employee table and 
then give the resultant column alias as NAME. */

select concat(FIRST_NAME," ",LAST_NAME) as NAME from emp_record_table
where dept = 'FINANCE' ;

/* 6. Write a query to list only those employees who have someone 
reporting to them. Also, show the number of reporters (including the 
President)  */

select e1.MANAGER_ID , e2.FIRST_NAME, e2.LAST_NAME , count(e1.EMP_ID) as NUMBER_OF_REPORTINGS
from emp_record_table e1 join emp_record_table e2 on e1.MANAGER_ID = e2.EMP_ID
group by e1.MANAGER_ID, e2.FIRST_NAME, e2.LAST_NAME ;

/* 7.Write a query to list down all the employees from the healthcare and 
finance departments using union. Take data from the employee record 
table */


Select * from emp_record_table
where DEPT = 'FINANCE'
union
select * from emp_record_table
where DEPT = 'HEALTHCARE' ;

/* 8.Write a query to list down employee details such as EMP_ID, 
FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING 
grouped by dept. Also include the respective employee rating along 
with the max emp rating for the department.
*/

with cte as (select max(emp_rating) as max_rating , dept from emp_record_table group by dept )
Select e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.ROLE, e.DEPT, e.EMP_RATING , c.max_rating 
from emp_record_table e join cte c on e.dept = c.dept
order by e.DEPT ;

/* 9. Write a query to calculate the minimum and the maximum salary of the 
employees in each role. Take data from the employee record table. */

select Role, max(salary) as Max_salary , min(salary) as Min_salary from emp_record_table
group by role;

/* 10. Write a query to assign ranks to each employee based on their 
experience. Take data from the employee record table. */

select emp_id, EXP as Experience, dense_rank() over(order by EXP Desc)  from emp_record_table ;

/* 11. Write a query to create a view that displays employees in various 
countries whose salary is more than six thousand. Take data from the 
employee record table. */

create or replace view v_countryEmployees as 
select emp_id , salary , country from emp_record_table
where SALARY > 6000
order by country ; 

/* 12. Write a nested query to find employees with experience of more than 
ten years. Take data from the employee record table.
 */
 
 select emp_id, exp  from ( select * from emp_record_table where EXP > 10)a ;
 
 /* 13. Write a query to create a stored procedure to retrieve the details of the 
employees whose experience is more than three years. Take data from 
the employee record table.
 */
 delimiter $$
 create procedure details_emp()
 begin
 select * from emp_record_table
 where exp > 3 ;
 end $$
 delimiter ;
 
 call details_emp();
 
 /* 14. Write a query using stored functions in the project table to check 
whether the job profile assigned to each employee in the data science 
team matches the organization’s set standard
The standard is given as follows:
• Employee with experience less than or equal to 2 years, assign 
'JUNIOR DATA SCIENTIST’
• Employee with experience of 2 to 5 years, assign 'ASSOCIATE DATA 
SCIENTIST’
• Employee with experience of 5 to 10 years, assign 'SENIOR DATA 
SCIENTIST’
• Employee with experience of 10 to 12 years, assign 'LEAD DATA 
SCIENTIST’,
• Employee with experience of 12 to 16 years, assign 'MANAGER'
 */
 
 
 drop function if exists f_criteria_check ;
 
 delimiter $$
 create function f_criteria_check( f_exp int) returns varchar(25)
 deterministic
 begin
 
 declare v_role varchar(255) default null  ;
 
 select  role into v_role from data_science_team
 where Exp = f_exp;
    
 return v_role   ;
 end $$
 delimiter ;
 
 
select f_criteria_check(5) ;

 
 /* 15.Create an index to improve the cost and performance of the query to 
find the employee whose FIRST_NAME is ‘Eric’ in the employee table 
after checking the execution plan. */

create index i_index
on emp_record_table( FIRST_NAME ) ;

select performance_data.f_criteria_check();

/* 16.Write a query to calculate the bonus for all the employees, based on 
their ratings and salaries (Use the formula: 5% of salary * employee 
rating).
 */
 
 select *, round((0.05*salary*EMP_RATING),2) as bonus from emp_record_table ;
 
 /* 17. Write a query to calculate the average salary distribution based on the 
continent and country. Take data from the employee record table.
 */
 
 Select avg(salary) , country ,  continent from emp_record_table 
 group by country , CONTINENT ;
