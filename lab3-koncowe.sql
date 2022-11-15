-- SQL 2 - grupowanie
-- Ćwiczenia końcowe

-- Ćwiczenie 1

-- 1.
select Orders.OrderID as Id_zamówienia,
       sum(Quantity) as Liczba_towarów,
       C.CompanyName as Nazwa_klienta
from orders
inner join [Order Details] [O D]
    on Orders.OrderID = [O D].OrderID
inner join Customers C
    on Orders.CustomerID = C.CustomerID
group by Orders.OrderID, C.CompanyName
order by Id_zamówienia

-- 2.
select Orders.OrderID as Id_zamówienia,
       sum(Quantity) as Liczba_towarów,
       C.CompanyName as Nazwa_klienta
from orders
inner join [Order Details] [O D]
    on Orders.OrderID = [O D].OrderID
inner join Customers C
    on Orders.CustomerID = C.CustomerID
group by Orders.OrderID, C.CompanyName
having sum(Quantity) > 250
order by Id_zamówienia

-- 3.
select Orders.OrderID as Id_zamówienia,
       convert(
           decimal(10,2),sum(
               Quantity * UnitPrice * (1 - Discount)
           )) as Wartość_zamówienia,
       C.CompanyName as Nazwa_klienta
from orders
inner join [Order Details] [O D]
    on Orders.OrderID = [O D].OrderID
inner join Customers C
    on Orders.CustomerID = C.CustomerID
group by Orders.OrderID, C.CompanyName
order by Id_zamówienia

-- 4.
select Orders.OrderID as Id_zamówienia,
       convert(
           decimal(10,2),sum(
               Quantity * UnitPrice * (1 - Discount)
           )) as Wartość_zamówienia,
       C.CompanyName as Nazwa_klienta
from orders
inner join [Order Details] [O D]
    on Orders.OrderID = [O D].OrderID
inner join Customers C
    on Orders.CustomerID = C.CustomerID

group by Orders.OrderID, C.CompanyName
having sum(Quantity * UnitPrice * (1 - Discount)) > 250
order by Id_zamówienia

-- 5.
select Orders.OrderID as Id_zamówienia,
       convert(
           decimal(10,2),sum(
               Quantity * UnitPrice * (1 - Discount)
           )) as Wartość_zamówienia,
       C.CompanyName as Nazwa_klienta,
       E.FirstName + ' ' + E.LastName as 'Obsługujący_zamówienie'
from orders
inner join [Order Details] [O D]
    on Orders.OrderID = [O D].OrderID
inner join Customers C
    on Orders.CustomerID = C.CustomerID
inner join Employees E
    on E.EmployeeID = Orders.EmployeeID

group by Orders.OrderID, C.CompanyName, E.FirstName + ' ' + E.LastName
having sum(Quantity * UnitPrice * (1 - Discount)) > 250
order by Id_zamówienia


-- Ćwiczenie 2

-- 1.
select CategoryName as Kategoria,
       sum(Quantity) as Zamówiono
from Categories
inner join Products P
    on Categories.CategoryID = P.CategoryID
inner join [Order Details] [O D]
    on P.ProductID = [O D].ProductID

group by Categories.CategoryID, CategoryName
order by Zamówiono desc

-- 2.
select CategoryName as Kategoria,
       sum(Quantity) as Zamówiono,
       convert(
           decimal(10,2), sum(
               Quantity * [O D].UnitPrice * (1 - Discount)
           )) as Łączna_wartość
from Categories
inner join Products P
    on Categories.CategoryID = P.CategoryID
inner join [Order Details] [O D]
    on P.ProductID = [O D].ProductID

group by Categories.CategoryID, CategoryName
order by Łączna_wartość desc

-- 3. jw.

-- 4.
select Orders.OrderID as Id_zamówienia,
       convert(
           decimal(10,2), sum(
               Quantity * UnitPrice * (1 - Discount)
           )) as Wartość_zamówienia,
       convert(
           decimal(10,2), Freight + sum(
               Quantity * UnitPrice * (1 - Discount)
            )) as Wartość_z_przesyłką
from orders
inner join [Order Details] [O D]
    on Orders.OrderID = [O D].OrderID
inner join Customers C
    on Orders.CustomerID = C.CustomerID
group by Orders.OrderID, C.CompanyName, Freight
order by Wartość_z_przesyłką desc


-- Ćwiczenie 3

-- 1.
select CompanyName as Przewoźnik,
       count(*) as Zamówienia_w_1997
from Shippers
inner join Orders O
    on Shippers.ShipperID = O.ShipVia
where year(ShippedDate) = 1997
group by ShipperID, CompanyName

-- 2.
select top 1 CompanyName as Przewoźnik
from Shippers
inner join Orders O
    on Shippers.ShipperID = O.ShipVia
where year(ShippedDate) = 1997
group by ShipperID, CompanyName
order by count(*) desc

-- 3.
select FirstName + ' ' + LastName as Imię_i_nazwisko,
       convert(
           decimal(10,2), sum(
               Quantity * UnitPrice * (1 - Discount)
           )) as Wartość_zamówień
from Employees
inner join Orders O
    on Employees.EmployeeID = O.EmployeeID
inner join [Order Details] [O D]
    on O.OrderID = [O D].OrderID
group by Employees.EmployeeID, FirstName + ' ' + LastName
order by Wartość_zamówień desc

-- 4.
select top 1
    FirstName + ' ' + LastName as Imię_i_nazwisko
from Employees
inner join Orders O
    on Employees.EmployeeID = O.EmployeeID
where year(OrderDate) = 1997
group by Employees.EmployeeID, FirstName + ' ' + LastName
order by count(*) desc

-- 5.
select top 1
    FirstName + ' ' + LastName as Imię_i_nazwisko
from Employees
inner join Orders O
    on Employees.EmployeeID = O.EmployeeID
inner join [Order Details] [O D]
    on O.OrderID = [O D].OrderID
group by Employees.EmployeeID, FirstName + ' ' + LastName
order by sum(
               Quantity * UnitPrice * (1 - Discount)
           ) desc


-- Ćwiczenie 3

-- 1. a)
select distinct E.EmployeeID as ID,
                E.FirstName + ' ' + E.LastName as Imię_i_nazwisko,
       convert(
           decimal(10,2), sum(
               Quantity * UnitPrice * (1 - Discount)
           )) as Wartość_zamówień
from Employees E
left outer join Employees Sub
    on Sub.ReportsTo = E.EmployeeID
inner join Orders O
    on E.EmployeeID = O.EmployeeID
inner join [Order Details] [O D]
    on O.OrderID = [O D].OrderID
where Sub.EmployeeID is not null
group by E.EmployeeID, E.FirstName + ' ' + E.LastName, Sub.EmployeeID


-- 1. b)
select E.EmployeeID as ID,
                E.FirstName + ' ' + E.LastName as Imię_i_nazwisko,
       convert(
           decimal(10,2), sum(
               Quantity * UnitPrice * (1 - Discount)
           )) as Wartość_zamówień
from Employees E
left outer join Employees Sub
    on Sub.ReportsTo = E.EmployeeID
inner join Orders O
    on E.EmployeeID = O.EmployeeID
inner join [Order Details] [O D]
    on O.OrderID = [O D].OrderID
where Sub.EmployeeID is null
group by E.EmployeeID, E.FirstName, E.LastName
order by ID
