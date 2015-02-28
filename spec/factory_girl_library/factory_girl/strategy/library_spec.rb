require 'spec_helper'

describe FactoryGirlLibrary::FactoryGirl::Strategy::Library do
  self.use_transactional_fixtures = false

  subject{ library(:comment, title: :title) }

  before do
    FactoryGirlLibrary::Library.clear
    Comment.delete_all
    Post.delete_all

    expect(FactoryGirlLibrary::Library).to receive(:register)
                                          .ordered
                                          .with(:post, instance_of(Post))
                                          .once
                                          .and_call_original
    expect(FactoryGirlLibrary::Library).to receive(:register)
                                          .ordered
                                          .with(:comment, instance_of(Comment))
                                          .once
                                          .and_call_original
  end

  its(:title) { is_expected.to eq(:title) }

  it 'is available inside transaction and stays outside' do
    ActiveRecord::Base.connection.transaction(isolation: :read_committed) do
      expect{ subject }.to change(Comment, :count).by(1)
      expect(Comment.first.title).to eq("title")

      raise ActiveRecord::Rollback
    end

    expect(Comment.first).not_to be_blank
    expect(Comment.first.title).to eq('Some Interesting title')
    expect(library(:comment).title).to eq('Some Interesting title')
  end
end