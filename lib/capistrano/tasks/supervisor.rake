require_relative 'helpers'

namespace :supervisor do
  desc 'upload supervisor upstart config'
  task :upstart do
    on roles(:app) do
      within release_path do
        supervisor_upstart_conf = erb_file(template('supervisor-upstart.conf.erb'))
        put_sudo(supervisor_upstart_conf, fetch(:upstart_path))
      end
    end
  end

  desc 'upload supervisor config'
  task :config do
    on roles(:app) do
      within release_path do
        supervisor_conf = erb_file(template('supervisor.conf.erb'))
        put_sudo(supervisor_conf, fetch(:supervisor_conf_path))
      end
    end
  end

  %w(start stop restart status).each do |command|
    desc "supervisor #{command} service task"
    task "#{command}" do
      on roles(:app) do
        within release_path do
          sudo :service, :supervisord, "#{command}"
        end
      end
    end
  end
end
