require 'spec_helper'


describe FactoryGirlLibrary::FactoryGirl::Strategy::Library do
  subject do
    FactoryGirl.library(:post, title: :title)
  end

  before do
    expect(FactoryGirlLibrary::Library).to receive(:create)
                                          .with(:post, title: :title)
                                          .and_call_original
  end

  its(:title) { is_expected.to eq("title") }
end