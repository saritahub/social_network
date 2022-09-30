require '/Users/saritaradia/Desktop/Projects/social_network/lib/useraccount.rb'

class UserAccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
     sql = 'SELECT id, email_address, username FROM useraccounts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    useraccounts = []

    result_set.each do |record|
      useraccount = UserAccount.new
      useraccount.id = record['id']
      useraccount.email_address = record['email_address']
      useraccount.username = record['username']
      useraccounts << useraccount
    end
    return useraccounts
  end


  def find(id)
    # Executes the SQL query:
    sql = 'SELECT id, email_address, username FROM useraccounts WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]

    useraccount = UserAccount.new
    useraccount.id = record['id']
    useraccount.email_address = record['email_address']
    useraccount.username = record['username']

    return useraccount
  end

  # Add more methods below for each operation you'd like to implement.

  def create(useraccount)
    sql = 'INSERT INTO useraccounts (email_address, username) VALUES($1, $2);'
    sql_params = [useraccount.email_address, useraccount.username]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def update(useraccount)
    sql = 'UPDATE useraccounts SET email_address = $1, username = $2 WHERE id = $3;'
    sql_params = [useraccount.email_address, useraccount.username, useraccount.id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def delete(id)
    sql = 'DELETE FROM useraccounts WHERE id = $1;'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)
  end
end