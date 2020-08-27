
namespace :setup do
  require_relative '../data/counties'

  desc "Build multiple query objects from a list of counties"
  task add_user_one: :environment do
    @user = User.first
    if !@user
      User.create!(name: "admin", email: "ganch.project@gmail.com", password: "GaNCH!", password_confirmation: "GaNCH!")
      Rails.logger.info("Admin user created.")
    else
      Rails.logger.info("Skipping create user. Other users found in database.")
    end
  end

end