
require 'capistrano/deploy'
require 'releasetag/version'

load File.expand_path("../lib/capistrano/tasks/release_tag.rake", __FILE__)

module Capistrano
  module Releasetag
  end
end
