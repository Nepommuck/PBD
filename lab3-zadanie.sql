use joindb

select B1.buyer_name,
       B2.buyer_name,
       P.prod_name
from Sales S1
inner join Sales S2
    on S1.prod_id = S2.prod_id
inner join Buyers B1
    on B1.buyer_id = S1.buyer_id
inner join Buyers B2
    on B2.buyer_id = S2.buyer_id
inner join Produce P
    on P.prod_id = S1.prod_id
where S1.buyer_id < S2.buyer_id


use Northwind2

select E1.FirstName + ' ' + E1.LastName,
       E2.FirstName + ' ' + E2.LastName,
       E1.Title
from Employees E1
inner join Employees E2
    on E2.Title = E1.Title
where E1.EmployeeID < E2.EmployeeID
