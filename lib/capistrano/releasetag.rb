require 'capistrano'
require 'capistrano/deploy'

load File.expand_path("../lib/capistrano/tasks/releasetag.rake", __FILE__)

module Capistrano
  module Releasetag
  end
end
