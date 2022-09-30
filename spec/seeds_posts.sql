TRUNCATE TABLE useraccounts, posts RESTART IDENTITY CASCADE; -- replace with your own table name.
-- TRUNCATE TABLE posts RESTART IDENTITY CASCADE;
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO useraccounts (email_address, username) VALUES ('katie@gmail.com', 'katie09');
INSERT INTO useraccounts (email_address, username) VALUES ('dave@gmail.com', 'dave3');

-- Only Katie present in test

INSERT INTO posts (title, content, views, useraccount_id) VALUES ('Tina', 'Life update', 100, 1);
INSERT INTO posts (title, content, views, useraccount_id) VALUES ('Carrie', 'Cat update', 21, 2);

-- If tests fail, move useraccounts ABOVE posts
