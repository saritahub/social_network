# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: posts

Columns:
id | title | content | views | useraccount_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_posts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, views, useraccount_id) VALUES ('Tina', 'Life update', 21, 1);
INSERT INTO posts (title, content, views, useraccount_id) VALUES ('Carrie', 'Cat update', 21, 2);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network < seeds_posts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/posts.rb)
class Post
end

# Repository class
# (in lib/postrepository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class Post

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :views, :useraccount_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: students

# Repository class
# (in lib/student_repository.rb)

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # sql = 'SELECT id, title, content, views, useraccount_id FROM posts;'

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # sql = 'SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;'
    # sql_params = [id]
    

    # Returns a single Post object.
  end

  # Add more methods below for each operation you'd like to implement.

  # def create(post)
  # sql = 'INSERT INTO posts (title, content, views, user_account_id) VALUES($1, $2, $3, $4)'
  # sql_params = [post.title, post.content, post.views, post.user_account_id]
  # end

  # def update(post)
  # sql = 'UPDATE posts SET title = $1, content = $2, views = $3, user_account_id = $4 WHERE id = $5'
  # sql_params = [post.title, post.content, post.views, post.user_account_id, post.id]
  # end

  # def delete(post)
  # sql = 'DELETE FROM posts WHERE id = $1'
  # sql_params = [id]
  # end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Gets all posts

repo = PostRepository.new

posts = repo.all

expect(posts.length).to eq(2)

expect(posts[0].id).to eq(1)
expect(posts[0].title).to eq('Tina') 
expect(posts[0].content).to eq('Life update')
expect(posts[0].views).to eq(100)
expect(posts[0].useraccount_id).to eq(1)

expect(posts[1].id).to eq(2)
expect(posts[1].title).to eq('Carrie')
expect(posts[1].content).to eq('Cat update')
expect(posts[1].views).to eq(21)
expect(posts[1].useraccount_id).to eq(1)


# 2
# Get a single post

repo = PostRepository.new

post = repo.find(1)

expect(post.id).to eq(1)
expect(posts.title).to eq('Tina')
expect(posts.content).to eq('Life update')
expect(posts.views).to eq(100)
expect(posts.useraccount_id).to eq(1)

#3 Creates a new post
repo = PostRepository.new

post = Post.new
post.title = 'New name'
post.content = 'New content'
post.views = 2
post.useraccount_id = 3

repo.create(post)
posts = repo.all 
last_post = posts.last
expect(post.title).to eq('New name')
expect(post.content).to eq('New content')
expect(post.views).to eq(2)
expect(post.useraccount_id).to eq(3)


#4 Deletes a post
repo = PostRepository.new
id_to_delete = 1
repo.delete(id_to_delete)

all_posts = repo.all
expect(all_posts.length).to eq(1)
expect(all_posts.first.id).to eq('2')

#5 Update a post
repo = PostRepository.new
post = repo.find(1)

post.title = 'Updated name'
post.content = 'Updated content'
post.views = 10
post.useraccount_id = 3

repo.update(post)
updated_post = repo.find(1)

expect(updated_post.title).to eq('Updated name')
expect(updated_post.content).to eq('Updated content')
expect(updated_post.views).to eq(10)
expect(updated_post.useraccount_id).to eq(3)




```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/postrepository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._