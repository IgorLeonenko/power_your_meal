require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }
    let(:meal) { create(:meal) }
    subject { build(:favorite, user: user, meal: meal) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:meal_id) }

    it 'prevents duplicate favorites for the same user and meal' do
      create(:favorite, user: user, meal: meal)
      duplicate_favorite = build(:favorite, user: user, meal: meal)
      expect(duplicate_favorite).not_to be_valid
      expect(duplicate_favorite.errors[:user_id]).to include('has already been taken')
    end

    it 'allows different users to favorite the same meal' do
      create(:favorite, user: user, meal: meal)
      other_user = create(:user)
      other_favorite = build(:favorite, user: other_user, meal: meal)
      expect(other_favorite).to be_valid
    end

    it 'allows the same user to favorite different meals' do
      create(:favorite, user: user, meal: meal)
      other_meal = create(:meal)
      other_favorite = build(:favorite, user: user, meal: other_meal)
      expect(other_favorite).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:meal) }
  end
end
