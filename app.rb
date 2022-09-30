# file: app.rb

require_relative 'lib/database_connection'
require '/Users/saritaradia/Desktop/Projects/social_network/lib/useraccountrepo.rb'
require '/Users/saritaradia/Desktop/Projects/social_network/lib/postrepository.rb'

#Model Classes may not be needed here
# # require '/Users/saritaradia/Desktop/Projects/social_network/lib/useraccount.rb'
# #  require '/Users/saritaradia/Desktop/Projects/social_network/lib/post.rb'


#Add all of the other Classes (model and repo)
# We need to give the database name to the method `connect`.
DatabaseConnection.connect('social_network')

# Perform a SQL query on the database and get the result set.
sql = 'SELECT id, email_address, username FROM useraccounts;'
result = DatabaseConnection.exec_params(sql, [])

# Print out each record from the result set .
# result.each do |record|
#   p record
# end
