create schema kha1;

create table  kha1.book(
    book_id serial primary key ,
    title varchar(255),
    author varchar(100),
    genre varchar(50),
    price decimal(10,2),
    description text,
    created_at timestamp default current_timestamp
);

insert into kha1.book (title, author, genre, price, description)
select
    (array['the secret of', 'journey to', 'the chronicles of', 'legend of', 'beyond the'])[floor(random() * 5 + 1)] || ' ' ||
    (array['darkness', 'emerald city', 'lost world', 'time master', 'silent echo'])[floor(random() * 5 + 1)] || ' vol.' || i,
    (array['j.k. rowling', 'george r.r. martin', 'j.r.r. tolkien', 'agatha christie', 'stephen king', 'haruki murakami', 'ernest hemingway', 'dan brown'])[floor(random() * 8 + 1)],
    (array['fantasy', 'mystery', 'horror', 'sci-fi', 'romance', 'historical', 'thriller', 'adventure'])[floor(random() * 8 + 1)],
    (random() * (200 - 5) + 5)::numeric(10,2),
    'a breathtaking ' || lower((array['masterpiece', 'adventure', 'tale', 'tragedy'])[floor(random() * 4 + 1)]) ||
    ' written by author ' || i || '. this book explores the themes of ' ||
    (array['bravery', 'betrayal', 'eternal love', 'galactic wars', 'ancient secrets'])[floor(random() * 5 + 1)]
from generate_series(1, 500000) as i;

analyze kha1.book;

create index idx_book_genre on kha1.book(genre);

create extension if not exists pg_trgm;
create index idx_book_author_trgm on kha1.book using gin (author gin_trgm_ops);

explain analyse select * from kha1.book where genre = 'Fantasy';
explain analyse select * from kha1.book where author ilike '%Rowling%';


CLUSTER book USING idx_book_genre;
