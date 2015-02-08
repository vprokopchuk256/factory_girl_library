require 'spec_helper'

require 'factory_girl_library/library'

describe FactoryGirlLibrary::Library do
  before { described_class.clear }

  describe '#get' do
    subject { described_class.get(:post, title: :new_title) }

    describe "when object is registered" do
      before { described_class.register(:post, FactoryGirl.create(:post)) }
      
      it { is_expected.not_to be_blank }
      its(:title) { is_expected.to eq('new_title') }
    end

    describe "when object is not registered" do
      it { is_expected.to be_blank }
    end
  end

  describe '#reload' do
    let(:post) { FactoryGirl.create(:post) }

    before { described_class.register(:post, post) }

    it 'reloads registered object' do
      expect(post).to receive(:reload)
      described_class.reload(:post)
    end
  end

  describe '#registered?' do
    subject { described_class.registered?(:post) }

    describe "when object is registered" do
      before { described_class.register(:post, FactoryGirl.create(:post)) }
      
      it { is_expected.to be_truthy }
    end

    describe "when object is not registered" do
      it { is_expected.to be_falsey }
    end
  end

  describe '#clear' do
    let(:post) { FactoryGirl.create(:post) }
    let(:post_1) { FactoryGirl.create(:post) }

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

  # describe '#create' do
  #   def create opts = {}
  #     described_class.create(:post, opts)
  #   end

  #   subject { create(title: 'title') }

  #   before do
  #     expect(::FactoryGirl).to receive(:create).with(:post).once.and_call_original
  #   end

  #   it { is_expected.to be_a_kind_of(Post) }
  #   its(:title) { is_expected.to eq('title') }

  #   it 'does not create send instance' do
  #     2.times { create }
  #   end

  #   describe 'with transaction' do
  #     describe 'inside transaction' do
  #       it 'creates visible instance' do
  #         ActiveRecord::Base.connection.transaction(isolation: :read_committed) do
  #           expect { create }.to change(Post, :count).from(0).to(1)
  #         end
  #       end
  #     end

  #     describe 'when transaction is rolled back' do
  #       it 'remains in database' do
  #         expect {
  #           ActiveRecord::Base.connection.transaction do
  #             create
  #             raise ActiveRecord::Rollback
  #           end
  #         }.to change(Post, :count).by(1)
  #       end

  #       it 'reverts updated property back' do
  #         ActiveRecord::Base.connection.transaction do
  #           expect(create(title: 'updated_title').title). to eq('updated_title')
  #           expect(Post.first.title).to eq('updated_title')

  #           raise ActiveRecord::Rollback
  #         end
          
  #         expect(create.title). to eq('Some Interesting title')
  #         expect(Post.first.title).to eq('Some Interesting title')
  #       end
  #     end
  #   end
  # end
end