create table customer (
    customer_id serial primary key,
    full_name varchar(100),
    region varchar(50)
);

create table orders (
    order_id serial primary key,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date,
    status varchar(20)
);

create table product (
    product_id serial primary key,
    name varchar(100),
    price decimal(10,2),
    category varchar(50)
);

create table order_detail (
    order_id int references orders(order_id),
    product_id int references product(product_id),
    quantity int
);

insert into customer (full_name, region) values
('nguyen van a', 'north'),
('tran thi b', 'south'),
('le van c', 'central'),
('pham van d', 'north'),
('hoang thi e', 'south');

insert into orders (customer_id, total_amount, order_date, status) values
(1, 500.00, '2024-01-10', 'completed'),
(2, 1200.00, '2024-01-15', 'completed'),
(3, 800.00, '2024-02-01', 'completed'),
(4, 300.00, '2024-02-10', 'completed'),
(5, 1500.00, '2024-03-05', 'completed');

insert into product (name, price, category) values
('laptop', 1000.00, 'electronics'),
('mouse', 20.00, 'electronics'),
('phone', 500.00, 'electronics');

insert into order_detail (order_id, product_id, quantity) values
(1, 3, 1),
(2, 1, 1),
(2, 2, 10);

create view v_revenue_by_region as
select c.region, sum(o.total_amount) as total_revenue
from customer c
join orders o on c.customer_id = o.customer_id
group by c.region;

select * from v_revenue_by_region
order by total_revenue desc
limit 3;

create view v_revenue_above_avg as
select * from v_revenue_by_region
where total_revenue > (select avg(total_revenue) from v_revenue_by_region);

select * from v_revenue_above_avg;
