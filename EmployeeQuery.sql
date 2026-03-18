-- 1) Get Full Names and cities of all employees who work in Chicago
Select name,city from emprecord where city in ('Chicago');
-- 2) Get all employees sorted by salary from highest to lowest 
Select name,salary from emprecord order by salary desc;
-- 3) Get all employees whose name starts with any letter from A to E
Select name from emprecord where name like 'A%' or name like 'B%' or name like 'C%' or name like 'D%' or name like 'E%';
Select name from emprecord where left(name,1) between 'A' and 'E';
Select name from emprecord where name regexp '^[A-E]';
-- 4) Get all employees where salary is missing
Select name,department from emprecord where salary is null;
-- 5) Show all employees' name,salary,and tax which is 20% of salary for null salary show tax as 0
Select name,salary,coalesce(salary*0.2,0) as tax from emprecord; 
-- 6) Get page 2 of employees where page has 3 employees sort by id.show all columns
select * from emprecord order by id limit 3 offset 3;
-- 7)  Show each employees name and column called profile
Select name,concat(name,'|',coalesce(department,'N/A'),'|',coalesce(city,'N/A')) as profile from emprecord;
-- 8) Show each employee name,salary and column
Select name,salary,case when salary>=90000 then 'Executive' when salary>=60000 then 'Senior' when salary>=50000 then 'Junior' when salary<50000 then 'Intern' 
else 'unclassified' end as salaryband from emprecord order by salary desc;
-- 9) Show name,salary and column called takehome which is salary after deducting tax based on rules
Select name,salary,case when salary>=90000 then salary*0.7   
when salary>=60000 then salary*0.8 when salary<60000 then salary*0.9 else 0 end as takehome from emprecord
where case when salary>=90000 then salary*0.7 when salary >=60000 then salary*0.8 when salary<60000 then salary *0.9 else 0 end>40000 order by 3 desc;
-- 10) Find city in newyork or chicago salary between 50k and 95k and order by employees 
Select city,name,salary,case when joindate<'2020-01-01' then 'Veteran' when joindate<='2021-12-31' then 'Experienced' else 'Fresh' end as status from emprecord
where city in ('New York','Chicago') and salary between 50000 and 95000 order by joindate asc limit 3;
-- 11) Show all projects where budget is greater than 50000 status isn't completed 
Select project_name,budget,status from projects where budget>50000 and status<>'Completed' order by budget desc;
-- 12) Show employees who joined between 2018 and 2021 experience who joined according to year 2021 3-5 year,2019 5+year,otherwise 1-3 years 
Select name, joindate,department,case when joindate <'2019-01-01' Then '5+ years' when joindate<'2021-01-01' then '3-5 years' else '1-3 years' end as experience 
from emprecord where joindate between '2018-01-01' and '2021-12-31' order by joindate asc;
-- 13) Show budget-tier,budgetaftertax etc
Select project_name,budget,case when budget>=90000 then 'Platinum' when budget>=60000 then 'Gold' when budget>=40000 then 'Silver' else 'Bronze' end as budget_tier,
budget*0.85 as budget_after_tax from projects where status in ('Active','On Hold') order by 4 desc;
-- 14) Show city,salary ,city status replace null salary sort by name
Select name,city,coalesce(salary,0) as salary,case when city is null then 'Remote' when city='New York' then 'HQ' else 'Branch' end as location_status
from emprecord order by name asc;
-- 15)  Show project with budget>40000 and label the budget sort by budget desc
Select project_name,budget,employee_id,case when employee_id is null then 'Unassigned' else 'Assigned' end as assignment_status,concat('Project:',project_name,' | Budget: ',
budget) as budget_label from projects where budget>40000 order by budget desc;
-- 16)  Add column salarydisplay,citydisplay along with name,city,salary
Select name,city,salary,case when salary is null then 'Not Disclosed' else concat('salary:$',salary) end as salary_display,
case when city is null then 'Location: Remote' else concat('Location:',city) end as city_display from emprecord where city <> 'Dallas' order by city asc;
-- 17) Add column years_category join before 2018,join 2018 and 2020 and after 2020 add column status
Select name,salary,joindate,case when joindate <'2018-01-01' then 'Founding Member' when joindate between '2018-01-01' and '2019-12-31' then 'Early Employee' 
else 'Recent Hire' end as yearscategory,
case when salary is null then 'TBD' when salary>69166 then 'Above Average' else 'Below Average' end as salary_status  from emprecord where city is not null order by joindate asc;
-- 18) Add column project summary and sort by budget 
Select e.name,e.salary,e.city,p.project_name,p.budget,concat(e.name,' is working on ',p.project_name,' with budget ',cast (p.budget)) as project_summary from emprecord e 
join projects p on e.id=p.employee_id where status='Active' order by p.budget desc;
-- 19) Add column fullprofile and add column employee_tier
Select name,salary,city,joindate,concat(name,' | ',coalesce(city,'Remote'),' | ',Coalesce(salary,'Not Disclosed'),' | ',joindate) as full_profile,
case when salary is null then 'Unclassified' when salary>=90000 and city='New York' then 'Elite' when salary>=60000 then 'Senior' else 'Junior' end as employee_tier
from emprecord where joindate>'2018-01-01' order by salary desc,name asc;
-- 20) add column overalltier,show employee salary>55000 budget>40000 sort by budget then salary
Select e.name,e.salary,e.city,p.project_name,p.budget,p.status,concat(e.name, ' from ',coalesce(e.city,'Remote'),' | ','Project: ',p.project_name,' | ','Budget:$',p.budget) as combinedsummary,
case when p.status='Active' and e.salary>=90000 then 'Top Performer' when p.status='Active' and e.salary<90000 then 'Active Contributor'
when p.status='On Hold' then 'On Bench' else 'Completed' end as overall_tier from emprecord e join projects p on e.id=p.employee_id where e.salary>55000 and p.budget>40000 order by p.budget,e.salary desc ;
-- 21) Add column_grade,project_grade,master_summary and sort by budget and salary
Select e.name,e.salary,e.department,e.city,p.project_name,p.budget,p.status,case when e.salary is null then 'Ungraded' when e.salary>=90000 and e.department='Engineering' then 'Principal Engineer'
when e.salary>=60000 and e.department='Marketing' then 'Senior Marketer' else 'Associate' end as employee_grade,case when p.budget>=90000 and p.status='Active' then 'Flagship' when p.budget>=60000 then 'Standard' else 'Supporting' end as project_grade,
concat(e.name,' | ',p.project_name,' | ',' | $',coalesce(e.salary,'Confidential'),' | ',p.status) as mastersummary
from emprecord e join projects p on e.id=p.employee_id where e.department in ('Engineering','Marketing') and p.budget>=50000 and p.status<>'Completed' and (e.salary >60000 or e.salary is null) order by budget desc,salary desc,name asc;
-- 22) Find departments where totalprojectbudget>50000 and projectcount>=1
Select e.department,count(p.project_id) as projectcount,sum(p.budget) as totalprojectbudget from emprecord e join projects p on e.id=p.employee_id group by e.department having count(p.project_id)>=1 and sum(p.budget)>50000;
-- 23) Write subquery and join to find employees who earn above company average salary have atleast one active project 
Select e.name,e.department,e.salary,p.project_name,dept_avg.avg_salary from emprecord e join projects p on e.id=p.employee_id join (Select department,round(avg(salary),2) as avg_salary from emprecord group by department ) as dept_avg on e.department=dept_avg.department
where p.status='Active' and e.salary>dept_avg.avg_salary;	
-- 24) Create a cte having highbudgetproject then find project with budget>60000 
with highbudget as(
Select project_name,budget from projects where budget>60000)
Select project_name,budget from highbudget;
-- 25) Show name and project name using cte
with engineeringemployee as (Select  id,name from emprecord where department='Engineering'),
activeprojects as (Select project_name,employee_id from projects where status='Active'),
combinate as(Select e.name,a.project_name from engineeringemployee e join activeprojects a on e.id=a.employee_id)
Select * from combinate;
-- 26) find department with highest average salary show department and average salary
with depthighestavgsalary as (Select department,round(avg(salary),2) as avgsal from emprecord group by department)
Select department,avgsal from depthighestavgsalary order by avgsal desc limit 1;
-- 
with employeestats as(Select count(id) as totalemployee,department,round(avg(salary),2) as avgsalary,max(salary) as maxsalary from emprecord group by department having avg(salary)>55000)
Select department,totalemployee,avgsalary,maxsalary from employeestata;