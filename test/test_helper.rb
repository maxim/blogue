# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'pry'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!
Blogue.posts_path = File.expand_path('../fixtures/posts', __FILE__)
