require 'rails_helper'

RSpec.describe Meal, type: :model do
  describe 'validations' do
    subject { build(:meal) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:external_id) }
  end

  describe 'associations' do
    it { should belong_to(:category).optional }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorited_by).through(:favorites).source(:user) }
  end

  describe 'scopes' do
    let!(:pizza) { create(:meal, name: 'Pizza Margherita') }
    let!(:pasta) { create(:meal, name: 'Pasta Carbonara') }
    let!(:burger) { create(:meal, name: 'Cheeseburger') }

    describe '.by_name' do
      it 'finds meals matching the name pattern' do
        expect(described_class.by_name('pizza')).to contain_exactly(pizza)
        expect(described_class.by_name('pa')).to contain_exactly(pasta)
      end

      it 'is case insensitive' do
        expect(described_class.by_name('PIZZA')).to contain_exactly(pizza)
        expect(described_class.by_name('pizza')).to contain_exactly(pizza)
      end
    end

    describe '.by_category' do
      let!(:italian) { create(:category, name: 'Italian') }
      let!(:american) { create(:category, name: 'American') }

      before do
        pizza.update!(category: italian)
        pasta.update!(category: italian)
        burger.update!(category: american)
      end

      it 'finds meals in the specified categories' do
        expect(described_class.by_category(italian.id)).to contain_exactly(pizza, pasta)
        expect(described_class.by_category(american.id)).to contain_exactly(burger)
      end

      it 'handles multiple category ids' do
        expect(described_class.by_category([ italian.id, american.id ]))
          .to contain_exactly(pizza, pasta, burger)
      end
    end
  end
end
