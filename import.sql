DROP TABLE IF EXISTS users cascade;
DROP TABLE IF EXISTS posts cascade;
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