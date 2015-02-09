require 'spec_helper'

require 'factory_girl_library/library'

describe FactoryGirlLibrary::Library do
  before { described_class.clear }

  describe '#get' do
    subject { described_class.get(:post, title: :new_title) }

    describe "when object is registered" do
      before { described_class.register(:post, create(:post)) }
      
      it { is_expected.not_to be_blank }
      its(:title) { is_expected.to eq('new_title') }
    end

    describe "when object is not registered" do
      it { is_expected.to be_blank }
    end
  end

  describe '#reload' do
    let(:post) { create(:post) }

    before { described_class.register(:post, post) }

    it 'reloads registered object' do
      expect(post).to receive(:reload)
      described_class.reload(:post)
    end
  end

  describe '#registered?' do
    subject { described_class.registered?(:post) }

    describe "when object is registered" do
      before { described_class.register(:post, create(:post)) }
      
      it { is_expected.to be_truthy }
    end

    describe "when object is not registered" do
      it { is_expected.to be_falsey }
    end
  end

  describe '#clear' do
    let(:post) { create(:post) }
    let(:post_1) { create(:post) }

    before do
      described_class.register(:post, post)
      described_class.register(:post_1, post_1)
    end

    it 'destroys registered object in reverse to registration order' do
      expect(post_1).to receive(:destroy).ordered
      expect(post).to receive(:destroy).ordered

      described_class.clear
    end
  end
end