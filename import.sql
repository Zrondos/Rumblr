DROP TABLE IF EXISTS users cascade;
DROP TABLE IF EXISTS posts cascade;
DROP TABLE IF EXISTS tags cascade;
DROP TABLE IF EXISTS posts_tags cascade;
DROP TABLE IF EXISTS user_posts cascade;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(50),
    username VARCHAR(50),
    password VARCHAR(50),
    email VARCHAR(50),
    birthday TIMESTAMP,
    profile_picture_url TEXT

);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50),
    content VARCHAR(50),
    image_url TEXT,
    video_url TEXT,
    hashtags TEXT,
    user_id integer
);

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE posts_tags (
    id SERIAL PRIMARY KEY,
    post_id INTEGER,
    tag_id INTEGER
);