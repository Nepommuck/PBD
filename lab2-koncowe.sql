-- SQL 2 - grupowanie
-- Ćwiczenia końcowe

-- Ćwiczenie 1

-- 1.
select OrderID as 'Numer_zamówienia',
convert(
    decimal(10,2), sum(
    Quantity * UnitPrice * (1 - Discount)
    )) as 'Wartość_sprzedaży'
from [Order Details]
group by OrderID
order by Wartość_sprzedaży desc

-- 2.
select top 10 OrderID as 'Numer_zamówienia',
convert(
    decimal(10,2), sum(
    Quantity * (UnitPrice - Discount)
    )) as 'Wartość_sprzedaży'
from [Order Details]
group by OrderID
order by Wartość_sprzedaży desc


-- Ćwiczenie 2

--Interpretacja I: Zamawiane przez klientów
-- 1.
select ProductID as 'ID_produktu', sum(Quantity) as 'Liczba_zamówionych'
from [Order Details]
where ProductID < 3
group by ProductID

-- 2.
select ProductID as 'ID_produktu', sum(Quantity) as 'Liczba_zamówionych'
from [Order Details]
group by ProductID
order by ProductID

--Interpretacja II: Zamawiane do magazynu
-- 1.
select ProductID as 'ID_produktu', sum(UnitsOnOrder) as 'Liczba_zamówionych'
from Products
where ProductID < 3
group by ProductID

-- 2.
select ProductID as 'ID_produktu', sum(UnitsOnOrder) as 'Liczba_zamówionych'
from Products
group by ProductID
having sum(UnitsOnOrder) > 0

-- 3.
select OrderID,
       convert(decimal(10,2), sum(
           Quantity * UnitPrice * (1 - Discount)
        )) as 'Wartość_zamówienia',
       sum(Quantity) as 'Liczba_zamówionych_jednostek'
from [Order Details]
group by OrderID
having sum(Quantity) > 250


-- Ćwiczenie 3

-- 1.
select Orders.EmployeeID, count(*)
from Orders
group by EmployeeID

-- 1+.
select Orders.EmployeeID as 'ID_pracownika',
       FirstName as 'Imię',
       LastName as 'Nazwisko',
       count(*) as 'Liczba_obsługiwanych_zamówień'
from Orders
inner join Employees
    on Employees.EmployeeID = Orders.EmployeeID
group by Orders.EmployeeID, FirstName, LastName

-- 2.
select ShipVia,
       convert(decimal(10,2), sum(Freight)) as 'Opłata_za_przesyłkę'
from orders
group by ShipVia

-- 2+.
select ShipVia as 'ID_spedytkora', CompanyName as 'Nazwa_spedytora',
       convert(decimal(10,2), sum(Freight)) as 'Opłata_za_przesyłkę'
from orders
inner join Shippers on Shippers.ShipperID = Orders.ShipVia
group by ShipVia, CompanyName
order by ShipVia

-- 3.
select ShipVia as 'ID_spedytkora',
       convert(decimal(10,2), sum(Freight)) as 'Opłata_za_przesyłkę'
from orders
where year(ShippedDate) between 1996 and 1997
group by ShipVia

-- 3+.
select ShipVia as 'ID_spedytkora', CompanyName as 'Nazwa_spedytora',
       convert(decimal(10,2), sum(Freight)) as 'Opłata_za_przesyłkę'
from orders
inner join Shippers on Shippers.ShipperID = Orders.ShipVia
where year(ShippedDate) between 1996 and 1997
group by ShipVia, CompanyName


-- Ćwiczenie 4

-- 1.
select EmployeeID as 'ID_pracownika',
    replace(
        str(month(OrderDate)) + '-' + str(year(OrderDate)),
           ' ', '') as 'Data',
    count(OrderID) as 'Liczba_zamówień'
from orders
group by EmployeeID, year(OrderDate), month(OrderDate)
order by EmployeeID, year(OrderDate), month(OrderDate)

-- 1+.
select Orders.EmployeeID as 'ID_pracownika',
       FirstName as 'Imię', LastName as 'Nazwisko',
       replace(
           str(month(OrderDate)) + '-' + str(year(OrderDate)),
           ' ', '') as 'Data',
       count(OrderID) as 'Liczba_zamówień'
from orders
inner join Employees on Employees.EmployeeID = Orders.EmployeeID
group by Orders.EmployeeID, FirstName, LastName, year(OrderDate), month(OrderDate)
order by Orders.EmployeeID, year(OrderDate), month(OrderDate)

-- 1. with rollup
select EmployeeID as 'ID_pracownika',
    month(OrderDate) as 'Miesiąc',
    year(OrderDate) as 'Rok',
    count(OrderID) as 'Liczba_zamówień'
from orders
group by EmployeeID, year(OrderDate), month(OrderDate)
with rollup
order by EmployeeID, year(OrderDate), month(OrderDate)

-- 2.
select CategoryID as 'ID_kategorii',
       convert(decimal(10, 2),
           min(UnitPrice)) as 'Cena_minimalna',
       convert(decimal(10, 2),
           max(UnitPrice)) as 'Cena_maksymalna'
from Products
group by CategoryID
with cube

-- 2+.
select Categories.CategoryID as 'ID_kategorii',
       CategoryName as 'Nazwa_kategorii',
       convert(decimal(10, 2),
           min(UnitPrice)) as 'Cena_minimalna',
       convert(decimal(10, 2),
           max(UnitPrice)) as 'Cena_maksymalna'
from Products
inner join Categories on Categories.CategoryID = Products.CategoryID
group by Categories.CategoryID, CategoryName

select * from Categories