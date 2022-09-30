# Two Tables Design Recipe Template

_Copy this recipe template to design and create two related database tables from a specification._

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.
```

```
Nouns:
UserAccount
email_address, username

Posts
title, content, views 
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record      | Properties              |
|-------------|-------------------------|
| useraccount | email_address, username |
| posts       | title, content, views   |

1. Name of the first table (always plural): `useraccounts`

   Column names: `email_address`, `username`

2. Name of the second table (always plural): `posts`

   Column names: `title`, `content`, `views`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: useraccounts
id: SERIAL
email_address: text
username: text

Table: posts
id: SERIAL
title: text
content: text
views: int
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [useraccounts] have many [posts]? (Yes)
2. Can one [posts] have many [useraccounts]? (No)

You'll then be able to say that:

1. **[useraccounts] has many [posts]**
2. And on the other side, **[posts] belongs to [useraccounts]**
3. In that case, the foreign key is in the table [posts]

Replace the relevant bits in this example with your own:

```
# EXAMPLE

1. Can one useraccount have many posts? YES
2. Can one post have many useraccounts? NO

-> Therefore,
-> An useraccount HAS MANY posts
-> An posts BELONGS TO a useraccount

-> Therefore, the foreign key is on the posts table.
```

*If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).*

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: albums_table.sql

-- Replace the table name, column names and types.

-- Create the table without the foreign key first.
CREATE TABLE useraccounts (
  id SERIAL PRIMARY KEY,
  email_address text,
  username text
);

-- Then the table with the foreign key.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
  useraccount_id int,
  constraint fk_useraccount foreign key(useraccount_id)
    references useraccounts(id)
);

-- Previously added ON DELETE CASCADE at the end of posts 
```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < albums_table.sql
```