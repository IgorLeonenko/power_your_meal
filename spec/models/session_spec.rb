require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'creation' do
    let(:user) { create(:user) }

    it 'creates a valid session for a user' do
      session = create(:session, user: user)
      expect(session).to be_valid
      expect(session.user).to eq(user)
    end
  end
end
