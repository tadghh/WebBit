# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(
  {
    email: 'test@email.com',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    username: 'testbuddy'
  }
)
#   end
user_admin = User.create!(
  {
    email: 'admin@email.com',
    password: 'rootpassword',
    password_confirmation: 'rootpassword',
    admin: false,
    username: 'adminbuddy'
  }
)
community1 = Community.create!(
  {
    name: 'TestCommunity',
    title: 'Test Community',
    description: 'All things testing',
    sidebar: 'All things testing sidebar',
    user_id: user_admin.id
  }
)

community2 = Community.create!(
  {
    name: 'TestCommunity1',
    title: 'Test Community',
    description: 'All things testing',
    sidebar: 'All things testing sidebar',
    user_id: user_admin.id
  }
)

Submission.create!(
  {
    title: 'Breaking news Pink man goes crazy',
    body: 'Drops album talking about nicklodian',
    community: community1,
    user: user_admin
  }
)
