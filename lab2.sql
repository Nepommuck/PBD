use Northwind

select CustomerID, EmployeeID, count(*) as 'Count'
from Orders
group by CustomerID, EmployeeID
with cube
order by CustomerID

select *
from Orders