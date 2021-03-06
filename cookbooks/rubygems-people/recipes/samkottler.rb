#
# Cookbook Name:: rubygems-people
# Recipe:: samkottler
#

home = '/home/samkottler'

directory "#{home}/src" do
  owner 'samkottler'
  group 'samkottler'
end

package 'tmux' do
  action :install
end

git "#{home}/src/dotfiles" do
  repository 'https://github.com/skottler/dotfiles'
  revision 'master'
  action :sync
  user 'samkottler'
end

%w( .gitconfig .pryrc .tmux.conf .gemrc .ackrc ).each do |file|
  link "#{home}/#{file}" do
    to "#{home}/src/dotfiles/#{file}"
  end
end
