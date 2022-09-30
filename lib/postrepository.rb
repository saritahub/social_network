require '/Users/saritaradia/Desktop/Projects/social_network/lib/post.rb'

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    sql = 'SELECT id, title, content, views, useraccount_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    posts = []

    result_set.each do |record|
      post = Post.new
      post.id = record['id']
      post.title = record['title']
      post.content = record['content']
      post.views = record['views']
      post.useraccount_id = record['useraccount_id']
      posts << post
    end
    return posts
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
     sql = 'SELECT id, title, content, views, useraccount_id FROM posts WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]

    post = Post.new
    post.id = record['id']
    post.title = record['title']
    post.content = record['content']
    post.views = record['views']
    post.useraccount_id = record['useraccount_id']

    return post

  end

  # Add more methods below for each operation you'd like to implement.

  def create(post)
    sql = 'INSERT INTO posts (title, content, views, useraccount_id) VALUES($1, $2, $3, $4)'
    sql_params = [post.title, post.content, post.views, post.useraccount_id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def update(post)
    sql = 'UPDATE posts SET title = $1, content = $2, views = $3, useraccount_id = $4 WHERE id = $5'
    sql_params = [post.title, post.content, post.views, post.useraccount_id, post.id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)
  end
end