create table post (
    post_id serial primary key,
    user_id int not null,
    content text,
    tags text[],
    created_at timestamp default current_timestamp,
    is_public boolean default true
);

create table post_like (
    user_id int not null,
    post_id int not null,
    liked_at timestamp default current_timestamp,
    primary key (user_id, post_id)
);

insert into post (user_id, content, tags, created_at, is_public)
select 
    floor(random() * 100 + 1),
    case 
        when i % 3 = 0 then 'đi du lịch biển nha trang'
        when i % 3 = 1 then 'chia sẻ kinh nghiệm học sql'
        else 'hôm nay trời đẹp quá'
    end,
    case 
        when i % 2 = 0 then array['du lịch', 'vui vẻ']
        else array['học tập', 'database']
    end,
    now() - (random() * interval '30 days'),
    case when i % 10 = 0 then false else true end
from generate_series(1, 10000) as i;

insert into post_like (user_id, post_id, liked_at)
select 
    floor(random() * 100 + 1),
    floor(random() * 10000 + 1),
    now()
from generate_series(1, 5000)
on conflict do nothing;

analyze post;

explain analyze select * from post
where is_public = true and content ilike '%du lịch%';

create index idx_post_content_lower on post (lower(content));

explain analyze select * from post
where is_public = true and lower(content) like lower('%du lịch%');

create extension if not exists pg_trgm;
create index idx_post_content_trgm on post using gin (content gin_trgm_ops);

explain analyze select * from post
where is_public = true and content ilike '%du lịch%';

create index idx_post_tags_gin on post using gin (tags);

explain analyze select * from post
where tags @> array['du lịch'];

create index idx_post_recent_public
on post (created_at desc)
where is_public = true;

explain analyze select * from post
where is_public = true and created_at >= now() - interval '7 days';

create index idx_post_user_recent on post (user_id, created_at desc);

explain analyze select * from post
where user_id = 1
order by created_at desc;
