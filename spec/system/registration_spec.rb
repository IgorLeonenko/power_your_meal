require 'rails_helper'

RSpec.describe 'User Registration', type: :system do
  describe 'signing up' do
    before do
      visit new_registration_path
    end

    it 'allows a visitor to sign up with valid information' do
      fill_in 'Email address', with: 'test@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'

      expect {
        click_button 'Sign Up'
      }.to change(User, :count).by(1)

      expect(page).to have_current_path(meals_path)
      expect(page).to have_content("You've successfully signed up! Welcome!")

      # Verify user is logged in
      user = User.last
      expect(user.email_address).to eq('test@example.com')
      expect(Session.count).to eq(1)
      expect(Session.last.user).to eq(user)
    end

    it 'shows validation errors with invalid information' do
      fill_in 'Email address', with: 'invalid-email'
      fill_in 'Password', with: 'short'
      fill_in 'Password confirmation', with: 'different'

      expect {
        click_button 'Sign Up'
      }.not_to change(User, :count)

      expect(page).to have_current_path(new_registration_path)
    end

    it 'shows error when email is already taken' do
      create(:user, email_address: 'taken@example.com')

      fill_in 'Email address', with: 'taken@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'

      expect {
        click_button 'Sign Up'
      }.not_to change(User, :count)

      expect(page).to have_content('Email address has already been taken')
    end

    it 'normalizes email address during registration' do
      fill_in 'Email address', with: '  Test@EXAMPLE.com  '
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'
      click_button 'Sign Up'

      expect(page).to have_current_path(meals_path)
      expect(User.last.email_address).to eq('test@example.com')
    end
  end

  describe 'navigation' do
    it 'allows access to registration page when logged out' do
      visit new_registration_path

      expect(page).to have_current_path(new_registration_path)
    end

    it 'redirects to root when trying to access registration page while logged in' do
      user = create(:user)
      login_as(user)
      visit new_registration_path

      expect(page).to have_current_path(meals_path)
    end
  end
end
