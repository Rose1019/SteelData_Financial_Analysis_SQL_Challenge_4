/*Creating Tables and Rows*/

create table customers(
c_id int primary key,
f_name varchar(50),
l_name varchar(50),
city varchar(50),
state varchar(50));

insert into customers
values
(1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');


create table branches(
branch_id int primary key,
branch_name varchar(50),
city varchar(50),
state varchar(50)
);

insert into branches 
values
(1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');

create table accounts(
account_id int primary key,
c_id int,
branch_id int,
acct_type varchar(50),
balance int,
foreign key (c_id) references customers(c_id),
foreign key (branch_id) references branches(branch_id));

insert into accounts
values
(1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);

create table transactions
(
t_id int primary key,
account_id int,
Transaction_Date date,
amount decimal(10,2),
foreign key(account_id) references accounts(account_id));

insert into transactions
values
(1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);

/*1. What are the names of all the customers who live in New York?*/

select concat(f_name,l_name) as Customer_Name,city as City
from customers
where city='New York';

/*2. What is the total number of accounts in the Accounts table?*/

select count(account_id) as Total_number_of_accounts
from accounts;

/*3. What is the total balance of all checking accounts?*/

select sum(balance) as Total_balance_amount_Checking_type
from accounts
where acct_type='Checking';

/*4. What is the total balance of all accounts associated with customers who live in Los Angeles?*/

select c.city,sum(a.balance) as Total_balance
from accounts a 
join customers c 
using(c_id)
where c.city='Los Angeles'
group by c.city;

/*5. Which branch has the highest average account balance?*/

select b.branch_id as Branch_ID,b.branch_name as Branch_name,round(avg(a.balance)) as Average_Account_Balance
from branches b 
join accounts a 
using(branch_id)
group by b.branch_id,b.branch_name
order by Average_Account_Balance desc
limit 1;

/*SUBQUERY*/
SELECT branch_id, AVG(balance) as avg_balance
FROM accounts
GROUP BY branch_id
HAVING AVG(balance) = (SELECT MAX(avg_balance)
                      FROM (SELECT branch_id, AVG(balance) as avg_balance
                            FROM accounts
                            GROUP BY branch_id) AS branch_avg);


/*6. Which customer has the highest current balance in their accounts?*/

select c.c_id,sum(a.balance) as Current_Balance
from accounts a 
join customers c 
using(c_id)
group by c.c_id
order by Current_Balance DESC
limit 1;

/*7. Which customer has made the most transactions in the Transactions table?*/

/*USE RANK to get the same count as output*/
with cte1 AS (
select a.c_id,CONCAT(c.f_name,c.l_name) as Customer_Name,count(t.t_id) as T_count
from transactions t 
join accounts a 
using(account_id)
join customers c 
using(c_id)
group by a.c_id,CONCAT(c.f_name,c.l_name)
)
select *
from ( Select *,
		dense_rank() over(order by T_count desc) as drnk
        from cte1
      )ranked
where drnk =1;      

/*8.Which branch has the highest total balance across all of its accounts?*/

select b.branch_id,sum(a.balance) as total
from accounts a 
join branches b 
using(branch_id)
group by b.branch_id
order by total desc
limit 1;

/*SUBQUERY*/

select a.branch_id,b.branch_name,sum(a.balance) as total_balance
from accounts a 
join branches b 
using(branch_id)
group by a.branch_id 
having sum(a.balance) = ( Select max(branch_total_balance)
						   from (	select branch_id,sum(balance) as branch_total_balance
									from accounts
									group by branch_id
                          ) as branch_totals
                      );    


/*9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?*/

select a.c_id,c.f_name,sum(balance) as total
from accounts a 
join customers c 
using(c_id)
group by a.c_id
order by total desc
limit 1;

/*SUBQUERY*/

select a.c_id,c.f_name,sum(a.balance) as total
from accounts a 
join customers c 
using(c_id)
group by a.c_id
having sum(balance) = ( Select max(customer_total_balance)
						   from (	select c_id,sum(balance) as customer_total_balance
									from accounts
									group by c_id
                          ) as customer_totals
                      );

/*10. Which branch has the highest number of transactions in the Transactions table?*/

select a.branch_id,b.branch_name,count(t.t_id) as Number_of_transaction
from accounts a 
join transactions t
using(account_id)
join branches b 
using(branch_id)
group by a.branch_id
order by Number_of_transaction desc
limit 1;

/*CTE and dense_Rank()*/
with cte1 AS (
select a.branch_id,b.branch_name,count(t.t_id) as Number_of_transaction
from accounts a 
join transactions t
using(account_id)
join branches b 
using(branch_id)
group by a.branch_id
)

select *
from (select *,
        dense_rank() over(order by Number_of_transaction desc) as drnk
        from cte1
	)ranked
where drnk=1;    



