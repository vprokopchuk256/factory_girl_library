require 'spec_helper'

describe FactoryGirlLibrary::FactoryGirl::FactoryDecorator do
  before do
    FactoryGirlLibrary::Library.clear
    Comment.delete_all
    Post.delete_all
  end
  
  describe '#last_run_factory' do
    subject do 
      create(:post)
      ::FactoryGirl::Factory.last_run_factory
    end

    it { is_expected.to eq(:post) }

    it 'still created post object'  do
      expect{ subject }.to change(Post, :count).by(1)
    end
  end
end