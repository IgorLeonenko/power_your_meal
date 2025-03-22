require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    subject { build(:category) }

    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:meals) }
  end
end
