require 'rails_helper'

RSpec.describe 'User Session', type: :system do
  let!(:user) { create(:user, password: 'password123') }

  describe 'signing in' do
    before do
      visit new_session_path
    end

    it 'allows a user to sign in with valid credentials' do
      fill_in 'Email address', with: user.email_address
      fill_in 'Password', with: 'password123'
      click_button 'Sign In'

      expect(page).to have_current_path(meals_path)

      # Verify user is logged in
      expect(page).to have_content('Logout')
      expect(page).not_to have_content('Sign In')
    end

    it 'shows error with invalid credentials' do
      fill_in 'Email address', with: user.email_address
      fill_in 'Password', with: 'wrong_password'
      click_button 'Sign In'

      expect(page).to have_current_path(new_session_path)
      expect(page).to have_content('Try another email address or password.')
    end

    it 'shows error when account does not exist' do
      fill_in 'Email address', with: 'nonexistent@example.com'
      fill_in 'Password', with: 'password123'
      click_button 'Sign In'

      expect(page).to have_current_path(new_session_path)
      expect(page).to have_content('Try another email address or password.')
    end

    it 'normalizes email address during login' do
      user.update!(email_address: 'test@example.com')

      fill_in 'Email address', with: '  Test@EXAMPLE.com  '
      fill_in 'Password', with: 'password123'
      click_button 'Sign In'

      expect(page).to have_current_path(meals_path)
    end
  end

  describe 'navigation' do
    it 'allows access to login page when logged out' do
      visit new_session_path
      expect(page).to have_current_path(new_session_path)
    end
  end

  describe 'signing out' do
    it 'allows a user to sign out' do
      login_as(user)

      click_on 'Logout'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content('You have been logged out')
      expect(page).not_to have_content('Logout')
    end
  end
end
