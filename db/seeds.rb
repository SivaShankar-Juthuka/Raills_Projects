# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# add some users with admin roles
User.create!(email: 'admin001@task.com', password: '123456789', password_confirmation: '123456789',role: 'admin')
User.create!(email: 'admin002@task.com', password: '123456789', password_confirmation: '123456789',role: 'admin')
User.create!(email: 'admin003@task.com', password: '123456789', password_confirmation: '123456789',role: 'admin')
User.create!(email: 'admin004@task.com', password: '123456789', password_confirmation: '123456789',role: 'admin')
