# spec/models/ability_spec.rb
require 'rails_helper'
require 'cancan/matchers'
require_relative '../../app/models/ability'
RSpec.describe Ability, type: :model do
  puts Ability.inspect # Output the loaded class
  subject(:ability) { Ability.new(user) }

  describe 'abilities' do
    context 'when user is an admin' do
      let(:user) { create(:user, role: 'admin') }

      it { is_expected.to be_able_to(:manage, Bookmark.new) }
    end

    context 'when user is a student' do
      let(:user) { create(:user, role: 'student') }

      it { is_expected.to be_able_to(:read, Bookmark.new) }
      it { is_expected.not_to be_able_to(:manage, Bookmark.new) }
    end
    context 'when user has an unknown or unauthorized role' do
      let(:user) { create(:user, role: ' ') }

      # Define the behavior for the unknown role, for example, should not be able to do anything
      it { is_expected.not_to be_able_to(:manage, Bookmark.new) }
      it { is_expected.not_to be_able_to(:read, Bookmark.new) }
      # Add more expectations based on the desired behavior for the unknown role
    end
  end
end
