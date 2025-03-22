require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email_address) }
    it { should validate_uniqueness_of(:email_address).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should have_secure_password }
  end

  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorite_meals).through(:favorites).source(:meal) }
  end

  describe 'email normalization' do
    it 'normalizes email address by stripping and downcasing' do
      user = build(:user, email_address: '  Test@Example.com  ')
      user.valid?
      expect(user.email_address).to eq('test@example.com')
    end
  end
end
