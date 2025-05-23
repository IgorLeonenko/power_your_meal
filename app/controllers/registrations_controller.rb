class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  resume_session only: %i[new create]

  def new
    return redirect_to root_path, notice: "You are already registered" if Current.session.present?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "You've successfully signed up! Welcome!"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [ :email_address, :password, :password_confirmation ])
  end
end
