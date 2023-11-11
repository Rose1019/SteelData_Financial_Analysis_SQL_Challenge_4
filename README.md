# SteelData_Financial_Analysis_SQL_Challenge_4


### Introduction
You are a Finance Analyst working for 'The Big Bank'
You have been tasked with finding out about your customers and their banking behaviour. 
Examine the accounts they hold and the type of transactions they make to develop greater insight into your customers.

Sharing the link to [SteelData-SQL Challenge 4](https://www.steeldata.org.uk/sql4.html)

-----------------------------------------------------------------------------------------------------------------------------------------

## Table Details

| Table Name | Column Name |
| ---------- | ----------- |
| Customers | Customer_ID,First_Name,Last_Name,City,State |
| Transactions | Transactions_ID,Account_ID,TransactionDate,Amount |
| Branches | Branch_ID,Branch_name,City,State |
| Accounts | Account_ID,Customer_ID,Branch_ID,Account_Type,Balance |

---------------------------------------------------------------------------------------------------------------------------------------------

## Code

*1. What are the names of all the customers who live in New York?*

``` js
select concat(f_name,l_name) as Customer_Name,city as City
from customers
where city='New York';
``` 
 
```
                                 Output
Fetches the names of all the customers who live in New York

                              Concepts learned
1.CONCAT()
2.COMPARISION OPERATOR
```
-----------------------------------------------------------------------------------------------------

*2. What is the total number of accounts in the Accounts table?*

``` js
select count(account_id) as Total_number_of_accounts
from accounts;
``` 

```
                                 Output
There are total 15 number of accounts in the Accounts table 

                              Concepts learned
1.COUNT()

```
-----------------------------------------------------------------------------------------------------

*3. What is the total balance of all checking accounts?*

``` js
select sum(balance) as Total_balance_amount_Checking_type
from accounts
where acct_type='Checking';
``` 

```
                                 Output
The total balance of all checking accounts is $31000.00
                              Concepts learned
1.SUM()
```
-----------------------------------------------------------------------------------------------------


*4. What is the total balance of all accounts associated with customers who live in Los Angeles?*

``` js
select c.city,sum(a.balance) as Total_balance
from accounts a 
join customers c 
using(c_id)
where c.city='Los Angeles'
group by c.city;
``` 

```
                                 Output
The total balance of all accounts associated with customers who live in Los Angeles is $75000.00

                              Concepts learned
1.JOIN
2.USING()
3.GROUP BY
4.SUM()

```
-----------------------------------------------------------------------------------------------------

*5. Which branch has the highest average account balance?*

``` js

/*SUBQUERY*/
SELECT branch_id,b.branch_name, AVG(balance) as avg_balance
FROM branches b
JOIN accounts a 
using(branch_id)
GROUP BY branch_id,b.branch_name
HAVING AVG(balance) = (SELECT MAX(avg_balance)
                      FROM (SELECT branch_id, AVG(balance) as avg_balance
                            FROM accounts
                            GROUP BY branch_id) AS branch_avg);

``` 

```
                                 Output
Retrieves the branch that has the highest average account balance, which is North Beach with $30000

                              Concepts learned
1.SUBQUERY
2.HAVING()
3.JOIN
4.USING()
5.GROUP BY
6.MAX()
7.AVG()

```
-----------------------------------------------------------------------------------------------------

*6. Which customer has the highest current balance in their accounts?*

``` js
select c.c_id,concat(c.f_name,c.l_name) as customer_name,sum(a.balance) as Current_Balance
from accounts a 
join customers c 
using(c_id)
group by c.c_id
order by Current_Balance DESC
limit 1;
``` 

```
                                 Output
Retrieves the customer name who has the highest current balance in their accounts.
MichaelLee with current balance $60000.00

                              Concepts learned
1.JOIN
2.USING()
3.GROUP BY
4.ORDER BY
5.CONCAT()
 
```
-----------------------------------------------------------------------------------------------------

*7. Which customer has made the most transactions in the Transactions table?*

``` js
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
``` 

```
                                 Output
Retrieves the customers who has made the most transactions in the Transactions table.

                              Concepts learned
1.CTE
2.JOIN
3.USING()
4.CONCAT()
5.DENSE_RANK()
6.GROUP BY
7.COUNT()
```
-----------------------------------------------------------------------------------------------------

*8.Which branch has the highest total balance across all of its accounts?*

``` js
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
``` 

```
                                 Output
Retrieves the branch name has the highest total balance across all of its accounts

                              Concepts learned
1.JOIN
2.USING()
3.GROUP BY
4.HAVING
5.SUM()
6.MAX()
```
-----------------------------------------------------------------------------------------------------

*9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?*

``` js
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
``` 

```
                                 Output
Retreives the customer name has the highest total balance across all of their accounts

                              Concepts learned
1.JOIN
2.USING()
3.GROUP BY
4.HAVING
5.SUM()
6.MAX()
```
-----------------------------------------------------------------------------------------------------

*10. Which branch has the highest number of transactions in the Transactions table?*

``` js
/*CTE and dense_Rank() is used to get those ranks when number of transactions are same*/

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
``` 

```
                               Output
 There are 2 branches that has the highest number of transactions in the Transactions table

                              Concepts learned
1.CTE
2.JOIN
3.USING()
4.CONCAT()
5.DENSE_RANK()
6.GROUP BY
7.COUNT()
```
-----------------------------------------------------------------------------------------------------

