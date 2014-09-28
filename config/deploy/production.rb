# -*- encoding : utf-8 -*-
require "rvm/capistrano"
#set unicorn support
require 'capistrano3/unicorn'
set :rails_env,   "production"
set :unicorn_env, "production"
set :app_env,     "production"

set :application, "il_dashboard"
set :repo_url,  "git@github.com:chengdh/il_dashboard.git"
#
set :scm, :git

set :password, ask('Server password', nil)
server 'zz.yanzhaowuliu.com', user: 'lmis', port: 22, password: fetch(:password), roles: %w{app web db}

set :deploy_to,"~/app/il_dashboard"

#set rvm support
set :rvm_ruby_string, '1.9.3@rails32_gemset'
#若rvm以system wide安装,则rvm设置如下
set :rvm_path, "/usr/local/rvm"
set :rvm_bin_path, "/usr/local/rvm/bin"

after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)
set :unicorn_bin,'r193_unicorn_rails'
