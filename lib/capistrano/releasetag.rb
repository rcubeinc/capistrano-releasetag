require 'capistrano'

module Capistrano
  module Releasetag
    def self.extended(configuration)

      configuration.load do

        namespace :releasetag do

          namespace :repo do

            task :clone do
              on release_roles fetch(:release_repo_role) do
                if test(" [ -d #{fetch(:release_repo_path)}/.git ]")
                  info "all ready repo"
                else
                  within fetch(:release_repo_root_path) do
                    execute 'git', 'clone', fetch(:repo_url)
                  end
                  within fetch(:release_repo_path) do
                    execute 'git', 'config', 'user.email', 'nobody@rcubeinc.com'
                    execute 'git', 'config', 'user.name', 'capistrano'
                  end
                end

              end
            end

            task :sync => ["clone"] do
              on release_roles fetch(:release_repo_role) do
                within fetch(:release_repo_path) do
                  execute 'git', 'fetch', fetch(:git_remote, 'origin')
                  execute 'git', 'reset', '--hard'
                  execute 'git', 'checkout', fetch(:current_revision)
                end
              end
            end

          end

          namespace :tag do

            def formatted_time
              now = if fetch(:deploytag_utc, true)
                      Time.now.utc
                    else
                      Time.now
                    end
              now.strftime(fetch(:release_tag_time_format, "%Y-%m-%d-%H%M%S-#{now.zone.downcase}"))
            end

            task :list => ["repo:sync"] do
              on release_roles fetch(:release_repo_role) do
                within fetch(:release_repo_path) do
                  execute 'git', 'tag', '-l' " '#{fetch(:release_tag_prefix)}*'"
                end
              end
            end

            task :set_tag_name => ['repo:sync', 'git:set_current_revision'] do
              on release_roles fetch(:release_repo_role) do
                within fetch(:release_repo_path) do
                  current_revision = fetch(:current_revision)

                  tag_name = fetch(:release_tag_name,
                                   "#{fetch(:release_tag_prefix)}#{formatted_time}#{fetch(:release_tag_suffix)}")
                  tag_user = fetch(:release_tag_user, (ENV['USER'] || ENV['USERNAME'] || 'deployer').strip)

                  last_tag_name_str = capture('git', 'tag', '-l' " '#{fetch(:release_tag_prefix, '')}*#{fetch(:release_tag_suffix, '')}'")
                  last_tag_names = []
                  last_tag_name_str.each_line { |name|
                    last_tag_names.push(name)
                  }
                  last_tag_name = last_tag_names.first


                  tag_messages = ["#{tag_user} deployed #{fetch(:current_revision)} to #{fetch(:stage)}"]
                  if last_tag_name and current_revision
                    tag_messages << capture('git',
                                            'log',
                                            '--pretty=format:"%h - %an, %ad : %s"',
                                            '--no-merges',
                                            ' -- ',
                                            "#{fetch(:current_revision)}...#{last_tag_name}")
                  end
                  tag_message = tag_messages.join('\n')

                  set :release_tag_name, tag_name
                  set :release_tag_user, tag_user
                  set :release_tag_message, tag_messages.join('\n')
                end
              end
            end

            task :create => ["repo:sync", 'set_tag_name'] do
              on release_roles fetch(:release_repo_role) do
                within fetch(:release_repo_path) do
                  tag_name = fetch(:release_tag_name)
                  tag_user = fetch(:release_tag_user)
                  commit_message = fetch(:release_tag_message)
                  execute('git', 'tag', '-a', tag_name, '-m', '"#{commit_message} #{current_revision}"')
                  execute('git', 'push', fetch(:git_remote, 'origin'), tag_name)
                end
              end
            end
          end
        end

        before 'deploy:starting', 'releasetag:tag:set_tag_name'
        after 'deploy:finishing', 'releasetag:tag:create'

      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.extend(Capistrano::Releasetag)
end
