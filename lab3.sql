-- Ćwiczenie (1) - inner join, left outer join
use Northwind

-- 1.
select ProductName,
       convert(decimal(10, 2), UnitPrice) as 'UnitPrice', CompanyName,
       Address + ', ' + City + ', ' + isnull(Region + ', ', '') + Country as 'Address'
from Products
inner join Suppliers on Suppliers.SupplierID = Products.SupplierID
where UnitPrice between 20 and 30

-- 2.
select ProductName, UnitsInStock
from Products
inner join Suppliers on Products.SupplierID = Suppliers.SupplierID
where CompanyName = 'Tokyo Traders'

-- 3.
select CompanyName,
       Address + ', ' + City + ', ' + isnull(Region + ', ', '') + Country as 'Address'
from Customers
left outer join Orders on Customers.CustomerID = Orders.CustomerID and year(OrderDate) = 1997
where OrderID is null and CompanyName != 'Test'

-- 4.
select ProductName, CompanyName, Phone
from Products
inner join Suppliers on Products.SupplierID = Suppliers.SupplierID
where isnull(UnitsInStock, 0) = 0


-- Ćwiczenie (2) - inner join, left outer join
use library

-- 1.
select firstname as 'Imię',
       lastname as 'Nazwisko',
       convert(date, birth_date) as 'Data_urodzenia'
from juvenile
inner join member on juvenile.member_no = member.member_no
order by Nazwisko, Imię, Data_urodzenia

-- 2.
select distinct title
from loan
inner join title on loan.title_no = title.title_no

-- 3.
select convert(date, in_date) as 'Data_oddania',
       datediff(day, out_date, in_date) as 'Przetrzymywano_dni',
       convert(decimal(10, 2), fine_paid) as 'Zapłacona_kara'
from loanhist
inner join title on loanhist.title_no = title.title_no
where title = 'Tao Teh King' and isnull(fine_paid, 0) > 0
order by Data_oddania desc, Przetrzymywano_dni, Zapłacona_kara

select isbn
from reservation
inner join member on reservation.member_no = member.member_no
where firstname + ' ' + middleinitial + '. ' + lastname = 'Stephen A. Graff'


-- Ćwiczenie (3) - inner join, left outer join, cross join, łączenie trzech tabel
use Northwind

-- 1.
select ProductName,
       convert(decimal(10, 2), UnitPrice) as 'UnitPrice',
       Address + ', ' + City + ', ' + isnull(Region + ', ', '') + Country as 'Address'
from Products
inner join Suppliers S
    on S.SupplierID = Products.SupplierID
inner join Categories C
    on C.CategoryID = Products.CategoryID
where UnitPrice between 20 and 30 and
      CategoryName = 'Meat/Poultry'

-- 2.
select ProductName,
       convert(decimal(10, 2), UnitPrice) as 'UnitPrice',
       CompanyName as 'SupplierName'
from Products
inner join Suppliers S
    on S.SupplierID = Products.SupplierID
inner join Categories C
    on C.CategoryID = Products.CategoryID
where CategoryName = 'Confections'


-- 3.
select distinct C.CompanyName, C.Phone
from orders
inner join Customers C
    on Orders.CustomerID = C.CustomerID
inner join Shippers S
    on S.ShipperID = Orders.ShipVia
where S.CompanyName = 'United Package' and
      year(ShippedDate) = 1997
order by C.CompanyName

-- 4.
select distinct CompanyName, Phone
from Customers
inner join Orders O on
    Customers.CustomerID = O.CustomerID
inner join [Order Details] OD
    on O.OrderID = OD.OrderID
inner join Products P
    on OD.ProductID = P.ProductID
inner join Categories C
    on C.CategoryID = P.CategoryID

where CategoryName = 'Confections'
order by CompanyName


-- Ćwiczenie (4) - inner join, left outer join, cross join, łączenie trzech tabel
use library

-- 1.
select m.firstname + ' ' + m.middleinitial + '.' as 'Imię',
       m.lastname as 'Nazwisko',
       convert(date, birth_date) as 'Data_urodzenia',
       street + ', ' + city + ', ' + state + ', USA' as 'Adres'
from juvenile
inner join member m
    on juvenile.member_no = m.member_no
inner join adult a
    on a.member_no = juvenile.adult_member_no

order by Nazwisko, Imię, Data_urodzenia, Adres

-- 1.
select m.firstname as 'Imię',
       m.lastname as 'Nazwisko',
       parent.firstname + ' ' + parent.middleinitial + '. ' + parent.lastname as 'Rodzic',
       convert(date, birth_date) as 'Data_urodzenia',
       street + ', ' + city + ', ' + state + ', USA' as 'Adres'
from juvenile
inner join member m
    on juvenile.member_no = m.member_no
inner join adult a
    on a.member_no = juvenile.adult_member_no
inner join member parent
    on parent.member_no = a.member_no

order by Nazwisko, Imię, parent.lastname, Rodzic, Data_urodzenia, Adres


-- Ćwiczenia (5) self join
use Northwind

-- 1.
select Supervisor.EmployeeID as 'EmployeeID',
       Supervisor.FirstName,
       Supervisor.LastName,
       Employees.FirstName + ' ' + Employees.LastName as 'Subordinate',
       Employees.EmployeeID as 'SubordinateID'
from Employees
inner join Employees Supervisor
    on Supervisor.EmployeeID = Employees.ReportsTo
order by EmployeeID

-- 2.
select Employees.EmployeeID as 'EmployeeID',
       Employees.FirstName,
       Employees.LastName
from Employees
left outer join Employees Subordinate
    on Subordinate.ReportsTo = Employees.EmployeeID
where Subordinate.EmployeeID is null


use library
-- 3.
select zip + ' ' + street + ', ' + city + ', ' + state + ', USA' as 'Adres',
       count(distinct adult.member_no) as 'Liczba_członków'
from adult
inner join juvenile j
    on adult.member_no = j.adult_member_no
where year(j.birth_date) < 1996
group by zip + ' ' + street + ', ' + city + ', ' + state + ', USA'

-- 4.
select distinct zip + ' ' + street + ', ' + city + ', ' + state + ', USA' as 'Adres',
       count(distinct adult.member_no) as 'Liczba_członków'
from adult
inner join juvenile j
    on adult.member_no = j.adult_member_no
left outer join loan l
    on adult.member_no = l.member_no
where year(j.birth_date) < 1996 and
      (due_date is null or due_date > getdate())
group by zip + ' ' + street + ', ' + city + ', ' + state + ', USA'


select * from loan
