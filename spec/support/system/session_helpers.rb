module System
  module SessionHelpers
    def login_as(user, password: 'password123')
      # Create user with known password if not exists
      user.update!(password: password) unless user.authenticate(password)

      visit new_session_path
      fill_in 'Email address', with: user.email_address
      fill_in 'Password', with: password
      click_button 'Sign In'
    end
  end
end

RSpec.configure do |config|
  config.include System::SessionHelpers, type: :system
end
