require '/Users/saritaradia/Desktop/Projects/social_network/lib/useraccountrepo.rb'

def reset_useraccounts_table
  seed_sql = File.read('spec/seeds_useraccounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do
    reset_useraccounts_table
  end

  # (your tests will go here).
  it "gets all user accounts" do
    repo = UserAccountRepository.new
    useraccounts = repo.all

    expect(useraccounts.length).to eq(2)

    expect(useraccounts[0].id).to eq('1')
    expect(useraccounts[0].email_address).to eq('anne@gmail.com')
    expect(useraccounts[0].username).to eq('anne21')

    expect(useraccounts[1].id).to eq('2')
    expect(useraccounts[1].email_address).to eq('sara@gmail.com')
    expect(useraccounts[1].username).to eq('sara03')
  end

  it "Gets a single user account" do
    repo = UserAccountRepository.new

    useraccounts = repo.find(1)

    expect(useraccounts.id).to eq('1')
    expect(useraccounts.email_address).to eq('anne@gmail.com')
    expect(useraccounts.username).to eq('anne21')
  end

  it "Creates a single useraccount" do
    repo = UserAccountRepository.new
    useraccount = UserAccount.new
    useraccount.email_address = "newemail@gmail.com"
    useraccount.username = "newusername"

    repo.create(useraccount)
    useraccounts = repo.all
    last_useraccount = useraccounts.last
    expect(last_useraccount.email_address).to eq("newemail@gmail.com")
    expect(last_useraccount.username).to eq("newusername")
  end

  it "Deletes a useraccount" do
    repo = UserAccountRepository.new
    id_to_delete = 1
    repo.delete(id_to_delete)

    all_useraccounts = repo.all
    expect(all_useraccounts.length).to eq(1)
    expect(all_useraccounts.first.id).to eq('2')
  end

  it "Updates a useraccount" do
    repo = UserAccountRepository.new
    useraccount = repo.find(1)

    useraccount.email_address = 'updated@gmail.com'
    useraccount.username = 'updated username'

    repo.update(useraccount)

    updated_useraccount = repo.find(1)

    expect(updated_useraccount.email_address).to eq('updated@gmail.com')
    expect(updated_useraccount.username).to eq('updated username')
  end
end