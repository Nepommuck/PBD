-- SQL 1 - podstawowe polecenia

use library


-- Ćwiczenie 1 - wybieranie danych

-- 1.
select title as 'Tytuł', title_no as 'Numer'
from title

-- 2.
select title as 'Rezultat'
from title
where title_no = 10

-- 3.
select member_no as 'Numer_czytelnika', fine_assessed as 'Kara'
from loanhist
where fine_assessed between 8 and 9
order by Numer_czytelnika

-- 4.
select title_no as 'Numer_książki', author as 'Autor'
from title
where author in ('Charles Dickens', 'Jane Austen')
order by author

-- 5.
select title_no as 'Numer_tytułu', title as 'Tytuł'
from title
where title like '%adventures%'

-- 6.
select member_no as 'Number_czytelnika', fine_assessed as 'Kara', fine_paid as 'Zapłacono'
from loanhist
where fine_assessed > 0
and (fine_paid is null or fine_paid = 0)
and (fine_waived is null or fine_waived = 0)
order by member_no

-- 7.
select distinct city as 'Miasto', state as 'Stan'
from adult
order by state, city


-- Ćwiczenie 2 - manipulowanie wynikowym zbiorem

-- 1.
select title as 'Tytuł'
from title
order by title

-- 2.
select member_no as 'Member_number', isbn as 'ISBN',
       fine_assessed as 'fine', 2 * fine_assessed as 'double fine'
from loanhist
where fine_assessed != 0
order by member_no, isbn, fine

-- 3.
select lower(replace(
    firstname + middleinitial + substring(lastname, 1, 2),
    ' ', '')
    ) as 'email_name'
from member
where lastname = 'Anderson'
order by email_name

-- 4.
select 'The title is: ' + title + ', title number ' + trim(str(title_no)) as 'Result'
from title