require '/Users/saritaradia/Desktop/Projects/social_network/lib/postrepository.rb'

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do
    reset_posts_table
  end

  it "Gets all posts" do
    repo = PostRepository.new

    posts = repo.all

    expect(posts.length).to eq(2)

    expect(posts[0].id).to eq('1')
    expect(posts[0].title).to eq('Tina')
    expect(posts[0].content).to eq('Life update')
    expect(posts[0].views).to eq('100')
    expect(posts[0].useraccount_id).to eq('1')

    expect(posts[1].id).to eq('2')
    expect(posts[1].title).to eq('Carrie')
    expect(posts[1].content).to eq('Cat update')
    expect(posts[1].views).to eq('21')
    expect(posts[1].useraccount_id).to eq('2')
  end

  it " Gets a single post" do
    repo = PostRepository.new

    post = repo.find(1)

    expect(post.id).to eq('1')
    expect(post.title).to eq('Tina')
    expect(post.content).to eq('Life update')
    expect(post.views).to eq('100')
    expect(post.useraccount_id).to eq('1')
  end

  it "Creates a new post" do
    repo = PostRepository.new

    post = Post.new
    post.title = 'New name'
    post.content = 'New content'
    post.views = 2
    post.useraccount_id = 2

    repo.create(post)
    posts = repo.all
    last_post = posts.last
    expect(last_post.title).to eq('New name')
    expect(last_post.content).to eq('New content')
    expect(last_post.views).to eq('2')
    expect(last_post.useraccount_id).to eq('2')
  end

  it "deletes a post" do
    repo = PostRepository.new
    id_to_delete = 1
    repo.delete(id_to_delete)

    all_posts = repo.all
    expect(all_posts.length).to eq(1)
    expect(all_posts.first.id).to eq('2')
  end

  it "updates a post" do
    repo = PostRepository.new
    post = repo.find(1)

    post.title = 'Updated name'
    post.content = 'Updated content'
    post.views = 10
    post.useraccount_id = 2

    repo.update(post)
    updated_post = repo.find(1)

    expect(updated_post.title).to eq('Updated name')
    expect(updated_post.content).to eq('Updated content')
    expect(updated_post.views).to eq('10')
    expect(updated_post.useraccount_id).to eq('2')
  end
end