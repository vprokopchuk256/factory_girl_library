require 'spec_helper'

describe FactoryGirlLibrary::FactoryGirl::FactoryGirlClassDecorator do
  before do
    FactoryGirlLibrary::Library.clear
    Comment.delete_all
    Post.delete_all
  end
  
  subject { library(:post, title: :title) }

  it 'calls original method and create post' do
    expect{ subject }.to change(Post, :count).by(1)
  end

  it 'calls get on library' do
    expect(FactoryGirlLibrary::Library).to receive(:get).ordered
    expect(FactoryGirlLibrary::Library).to receive(:get).ordered.with(:post, title: :title)
    subject
  end  
end