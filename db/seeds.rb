# Data to seed the database with.
# Includes three communities
#   - 'Test Community'
#   - 'Wrench Lovers Community'
#   - 'Nut Community'
#
# And two user accounts (Username, Password)
#   - U: "testbuddy" P: "password"
#   - U" "adminbuddy" P: "rootpassword"
#
# frozen_string_literal: true

User.create!(
  {
    admin: false,
    email: 'test@email.com',
    password_confirmation: 'password',
    password: 'password',
    username: 'testbuddy'
  }
)

user_wrench = User.create!(
  {
    admin: false,
    email: 'wrench@email.com',
    password_confirmation: 'wrenches123',
    password: 'wrenches123',
    username: 'WrenchFellow'
  }
)

user_admin = User.create!(
  {
    admin: true,
    email: 'admin@email.com',
    password_confirmation: 'rootpassword',
    password: 'rootpassword',
    username: 'adminbuddy'
  }
)

# Bland test community

community1 = Community.create!(
  {
    description: 'All things testing',
    name: 'TestCommunity',
    sidebar: 'All things testing sidebar',
    title: 'Test Community',
    user_id: user_admin.id
  }
)

Submission.create!(
  {
    body: 'Drops album talking about nicklodian',
    community: community1,
    title: 'Breaking news Pink man goes crazy',
    user: user_admin
  }
)

# Nut Community

community2 = Community.create!(
  {
    description: 'All things nutty',
    name: 'TestNutCommunity',
    sidebar: 'All things legume like',
    title: 'Nut Community',
    user_id: user_admin.id
  }
)

submission_nut = Submission.create!(
  {
    body: 'Whenever I eat a handful of peanuts my throat get really tight and scratchy. Does this happen for anyone else?', # rubocop:disable Layout/LineLength
    community: community2,
    title: 'Anyone having issues when eating nuts?',
    user: user_admin
  }
)

Comment.create(
  {
    submission: submission_nut,
    user: user_wrench,
    reply: 'Wrenches solve this issue.'
  }
)

# Wrench community

Community.create!(
  {
    description: 'If you love sockets or spanners this is the place to be',
    name: 'TestWrenchCommunity',
    sidebar: 'All things Wrench-y and bendy',
    title: 'Wrench Lovers Community',
    user_id: user_wrench.id
  }
)
