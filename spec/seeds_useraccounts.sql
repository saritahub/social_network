TRUNCATE TABLE useraccounts, posts RESTART IDENTITY CASCADE; -- replace with your own table name.
-- TRUNCATE TABLE posts RESTART IDENTITY CASCADE;
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO useraccounts (email_address, username) VALUES ('anne@gmail.com', 'anne21');
INSERT INTO useraccounts (email_address, username) VALUES ('sara@gmail.com', 'sara03');

-- INSERT INTO posts (title, content, views, useraccount_id) VALUES ('Anne', 'Cat update', 25, 1);
INSERT INTO posts (title, content, views, useraccount_id) VALUES ('Sara', 'Dog update', 10, 2);

-- Moved under useraccounts, RSpec passed (video paused to ask Coach for help)