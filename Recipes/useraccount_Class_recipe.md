# Useraccounts Model and Repository Classes Design Recipe

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: useraccounts

Columns:
id | email_address | username
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_useraccounts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE useraccounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO useraccounts (email_address, username) VALUES ('anne@gmail.com', 'anne21');
INSERT INTO useraccounts (email_address, username) VALUES ('sara@gmail.com', 'sara03');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

***IMPORTANT**: CHANGE INTO THE SPEC FOLDER BEFORE RUNNING THIS COMMAND*
```bash
psql -h 127.0.0.1 social_network < seeds_useraccounts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/useraccount.rb)
class UserAccount
end

# Repository class
# (in lib/useraccount_repository.rb)
class UserAccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class UserAccount

  # Replace the attributes by your own columns.
  attr_accessor :id, :email_address, :username
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

class UserAccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # sql = 'SELECT id, email_address, username FROM useraccounts;'

    # Returns an array of Useraccount objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # sql = 'SELECT id, email_address, username FROM useraccounts WHERE id = $1;'

    # Returns a single Useraccount object.
  end

  # Add more methods below for each operation you'd like to implement.

  # def create(useraccount)
  # sql = 'INSERT INTO useraccounts (email_address, username) VALUES($1, $2);'
  # sql_params = [useraccount.email_address, useraccount.username]
  # end

  # def update(useraccount)
  # sql = 'UPDATE useraccounts SET email_address = $1, username = $2 WHERE id = $3;'
  # sql_params = [useraccount.email_address, useraccount.username, useraccount.id]
  # end

  # def delete(useraccount)
  # sql = 'DELETE FROM useraccounts WHERE id = $1'
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
# Get all useraccounts

repo = UserAccountRepository.new

useraccounts = repo.all

expect(useraccounts.length).to eq(2)

expect(useraccounts[0].id).to eq('1') 
expect(useraccounts[0].email_address).to eq('anne@gmail.com')
expect(useraccounts[0].username).to eq('anne21')

expect(useraccounts[1].id).to eq('2')
expect(useraccounts[1].email_address).to eq('sara@gmail.com')
expect(useraccounts[1].username).to eq('sara03')


# 2
# Get a single useraccount
repo = UserAccountRepository.new

useraccounts = repo.find(1)

expect(useraccounts.id).to eq('1')
expect(useraccounts.email_address).to eq('anne@gmail.com')
expect(useraccounts.username).to eq('anne21')


#3 Create a single useraccount
repo = UserAccountRepository.new
useraccount = UserAccount.new 
useraccount.email_address = "newemail@gmail.com"
useraccount.username = "newusername"

repo.create(useraccount)
useraccounts = repo.all 
last_useraccount = useraccounts.last 
expect(last_useraccount.email_address).to eq("newemail@gmail.com")
expect(last_useraccount.username).to eq("newusername")

#4 Delete a useraccount
repo = UserAccountRepository.new
id_to_delete = 1
repo.delete(id_to_delete)

all_useraccounts = repo.all
expect(all_useraccounts.length).to eq(1)
expect(all_useraccounts.first.id).to eq('2')

#5 Update a useraccount
repo = UserAccountRepository.new
useraccount = repo.find(1)

useraccount.email_address = 'updated@gmail.com'
useraccount.username = 'updated username'

repo.update(useraccount)

updated_useraccount = repo.find(1)

expect(updated_useraccount.email_address).to eq('updated@gmail.com')
expect(updated_useraccount.username).to eq('updated username')






# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_useraccounts_table
  seed_sql = File.read('spec/seeds_useraccounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do
    reset_useraccounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._