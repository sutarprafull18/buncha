-- Database 'buncha' created
create database buncha;

-- Database is in use
use buncha;

--create Users table

create table Users (Id INT PRIMARY KEY,
    UserName VARCHAR(255) NOT NULL,CreatedAt DATETIME NOT NULL);

--create Orders table

create table Orders (Id INT PRIMARY KEY,BuyerId INT FOREIGN KEY REFERENCES Users(Id),
    CreatedAt DATETIME NOT NULL,Cancelled VARCHAR(5) NOT NULL);

-- Insert Data into Users Table

INSERT INTO Users (Id, UserName, CreatedAt) VALUES
(24280, 'Kayla Evans', '2023-03-06 23:42:00'),
(24603, 'Nichole Robinson', '2023-06-21 11:04:00'),
(24812, 'Amanda Luedtke', '2024-03-07 14:01:00'),
(25039, 'Cassandra Nelson', '2023-03-17 20:41:00'),
(25040, 'Deena Hougard', '2023-03-17 20:45:00'),
(25851, 'John Horihan', '2023-04-02 17:49:00'),
(25953, 'Katie Cvelbar', '2023-04-03 07:04:00');

-- Insert Data into Orders Table

INSERT INTO Orders (Id, BuyerId, CreatedAt, Cancelled) VALUES
(67507, 24280, '2023-03-08 23:42:00', 'False'),
(67618, 25039, '2023-03-29 13:08:00', 'False'),
(68660, 24603, '2023-07-05 09:09:00', 'True'),
(68750, 24280, '2023-04-02 17:55:00', 'False'),
(69645, 25851, '2023-04-07 16:01:00', 'True'),
(70264, 24603, '2023-07-08 12:45:00', 'False'),
(70390, 25953, '2023-04-10 10:28:00', 'False');

select * from Users;
select * from Orders;

/* 
Question : Consider you are working with an online grocery delivery business
and you want to know the average time from 1st order placed to next order
placed until 10th order placed.
 */ 

with ranked_orders as (
    Select 
        o.BuyerId,
        o.CreatedAt,
        ROW_NUMBER() over (Partition by o.BuyerId order by o.CreatedAt) as order_rank
    from Orders o
    where o.Cancelled = 'False'  -- Use string comparison with quotes
),
time_between_orders as (
    select 
        r1.BuyerId,
        r1.order_rank as current_order_num,
        DATEDIFF(Hour, r1.CreatedAt, r2.CreatedAt) AS hours_between_orders
    from ranked_orders r1
    Join ranked_orders r2 
        On r1.BuyerId = r2.BuyerId 
        And r1.order_rank + 1 = r2.order_rank
    Where r1.order_rank < 10
)

Select avg(cast(hours_between_orders as float))/24 as "Average Days Between Consecutive Orders"
from time_between_orders;