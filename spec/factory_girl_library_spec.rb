require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FactoryGirlLibrary" do
  before :all do
    FactoryGirlLibrary::Library.clear
    Comment.delete_all
    Post.delete_all
  end

  before do
    library(:comment, title: :title) 
  end

  subject { Comment.first }

  its(:title) { is_expected.to eq('title') }
  its(:post) { is_expected.to be_present }

  after :all do
    expect(Comment.count).to eq(1)
    expect(Post.count).to eq(1)
    expect(Comment.first.title).to eq('Some Interesting title')
  end
end
