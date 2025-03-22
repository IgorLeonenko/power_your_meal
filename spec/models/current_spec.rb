require 'rails_helper'

RSpec.describe Current, type: :model do
  describe 'attributes' do
    it 'has session attribute' do
      expect(Current.new).to respond_to(:session)
      expect(Current.new).to respond_to(:session=)
    end
  end

  describe 'delegations' do
    let(:user) { create(:user) }
    let(:session) { create(:session, user: user) }

    it 'delegates user to session' do
      Current.session = session
      expect(Current.user).to eq(user)
    end

    it 'allows nil session when accessing user' do
      Current.session = nil
      expect(Current.user).to be_nil
    end
  end

  describe 'thread isolation' do
    let(:user) { create(:user) }
    let(:session) { create(:session, user: user) }

    it 'maintains separate values per thread' do
      Current.session = session

      # Value in current thread
      expect(Current.session).to eq(session)
      expect(Current.user).to eq(user)

      # Value in another thread should be nil
      Thread.new do
        expect(Current.session).to be_nil
        expect(Current.user).to be_nil
      end.join
    end

    it 'resets after the block' do
      Current.session = session

      expect {
        Current.set(session: nil) do
          expect(Current.session).to be_nil
          expect(Current.user).to be_nil
          raise "error"
        end
      }.to raise_error("error")

      expect(Current.session).to eq(session)
      expect(Current.user).to eq(user)
    end
  end
end
