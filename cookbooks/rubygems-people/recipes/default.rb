include_recipe "user"

users = data_bag("users")
sysadmins = []
users.each do |user_name|
  user = data_bag_item("users", user_name)
  sysadmins << user['username'] if user['admin']
  user_account user["username"] do
    comment   user["comment"]
    password  user["password"]
    ssh_keys  user["ssh_keys"]
    shell     user["shell"] ? user["shell"] : "/bin/bash"
  end

  # If a user does stuff like setting up their $HOME via a custom recipe then
  # their data bag should have 'has_recipe' set to true. Then they can have
  # a recipe in this cookbook which matches their username.
  include_recipe "rubygems-people::#{user['username']}" if user['has_recipe']
end

group "sysadmin" do
  gid 2300
  members sysadmins
end