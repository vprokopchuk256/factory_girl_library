require 'spec_helper'

require 'factory_girl_library/library'

Post = Class.new(ActiveRecord::Base) do
  self.table_name = 'posts'
end

FactoryGirl.define do
  factory :post do
    title 'Some Interesting title'
  end
end

describe FactoryGirlLibrary::Library do
  before  do
    db.drop_table(:posts) if db.table_exists?(:posts) 

    db.create_table(:posts) do |t|
      t.string :title
    end

    described_class.clear 
  end

  describe '#create' do
    def create opts = {}
      described_class.create(:post, opts)
    end

    subject { create(title: 'title') }

    before do
      expect(::FactoryGirl).to receive(:create).with(:post).once.and_call_original
    end

    it { is_expected.to be_a_kind_of(Post) }
    its(:title) { is_expected.to eq('title') }

    it 'does not create send instance' do
      2.times { create }
    end

    describe 'with transaction' do
      describe 'inside transaction' do
        it 'creates visible instance' do
          ActiveRecord::Base.connection.transaction(isolation: :read_committed) do
            expect { create }.to change(Post, :count).from(0).to(1)
          end
        end
      end

      describe 'when transaction is rolled back' do
        it 'remains in database' do
          expect {
            ActiveRecord::Base.connection.transaction do
              create
              raise ActiveRecord::Rollback
            end
          }.to change(Post, :count).by(1)
        end

        it 'reverts updated property back' do
          ActiveRecord::Base.connection.transaction do
            expect(create(title: 'updated_title').title). to eq('updated_title')
            expect(Post.first.title).to eq('updated_title')

            raise ActiveRecord::Rollback
          end
          
          expect(create.title). to eq('Some Interesting title')
          expect(Post.first.title).to eq('Some Interesting title')
        end
      end
    end
  end
end