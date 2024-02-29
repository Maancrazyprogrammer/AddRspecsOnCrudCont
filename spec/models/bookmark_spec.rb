require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  context "when creating a bookmark" do
    let(:bookmark) {build :bookmark}
    it "should be a valid" do
      expect(bookmark.valid?).to eq(true)
    end
  end
  scenario 'invalid bookmark attributes' do
    post '/bookmarks', params: {
      bookmark: {
        url: '',
        title: 'RubyYagi blog'
      }
    }

    expect(response.status).to eq(422)

    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq(["can't be blank"])
    expect(Bookmark.count).to eq(0)
  end

  describe 'factory' do
    # Assuming you are using FactoryBot for creating test data
    it 'has a valid factory' do
      expect(build(:bookmark)).to be_valid
    end
  end


  # describe 'associations' do
  #   # Assuming you have associations with User or other models
  #   # Adjust these based on your actual associations
  #   it { should belong_to(:user).optional }
  #   # Add other associations if applicable
  # end

# check validation
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
    it { should_not allow_value('').for(:title) }
    it { should_not allow_value('').for(:url) }
  end
end
