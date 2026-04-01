create table customer (
    customer_id serial primary key,
    full_name varchar(100),
    email varchar(100),
    phone varchar(15)
);

create table orders (
    order_id serial primary key,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date
);

insert into customer (full_name, email, phone) values
('nguyen van a', 'a@gmail.com', '0912345678'),
('tran thi b', 'b@gmail.com', '0987654321'),
('le van c', 'c@gmail.com', '0905123456');

insert into orders (customer_id, total_amount, order_date) values
(1, 1500000.00, '2024-03-01'),
(1, 500000.00, '2024-03-15'),
(2, 2000000.00, '2024-03-10'),
(3, 300000.00, '2024-04-05'),
(2, 1200000.00, '2024-04-12');

create view v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c
join orders o on c.customer_id = o.customer_id;

select * from v_order_summary;

create view v_high_value_orders as
select * from orders 
where total_amount > 1000000;

select * from v_high_value_orders;

update v_high_value_orders 
set total_amount = 1100000 
where order_id = 1;

create view v_monthly_sales as
select 
    to_char(order_date, 'yyyy-mm') as month,
    sum(total_amount) as total_revenue
from orders
group by to_char(order_date, 'yyyy-mm');

select * from v_monthly_sales;

drop view v_order_summary;
