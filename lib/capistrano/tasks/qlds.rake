require_relative 'helpers'

namespace :qlds do
  desc 'top level script for qlds installation'
  task :install => [:install_startup_script, :install_server_files, :install_config]

  desc 'installs the startup script used by supervisor'
  task :install_startup_script do
    on roles(:app) do
      within release_path do
        script_path = "#{shared_path}/scripts"
        log_path = "#{fetch(:qlds_server_path)}/logs"
        script_file = "#{script_path}/qlds.sh"
        script_contents = erb_file(template('qlds.sh.erb'))
        execute :mkdir, '-p', script_path
        execute :chmod, '744', script_file
        execute :mkdir, '-p', log_path
        upload_file(script_contents, script_file)
      end
    end
  end

  desc 'installs server files in each server directory'
  task :install_server_files do
    on roles(:app) do
      within release_path do
        num_processes = fetch(:supervisor_num_processes)
        start_port = fetch(:qlds_gameport_start)
        end_port = start_port + num_processes - 1
        start_port.upto(end_port) do |port|
          destination = "#{fetch(:qlds_server_path)}/#{port}"
          execute :mkdir, '-p', destination
          execute :cp, '-R', 'qlds_files/baseq3', destination
        end
      end
    end
  end

  task :install_config do
    on roles(:app) do
      within release_path do
        settings_erb = ERB.new(capture("cat #{release_path}/config/qlds.yml"))
        settings = YAML.load(settings_erb.result)
        num_processes = fetch(:supervisor_num_processes)
        start_port = fetch(:qlds_gameport_start)
        end_port = start_port + num_processes - 1
        start_port.upto(end_port).with_index(1) do |port, index|
          server_settings = OpenStruct.new(settings['servers'][index])
          server_num = index
          server_config = erb_file(template('server.cfg.erb'), binding)
          server_config_path = "#{fetch(:qlds_server_path)}/#{port}/baseq3/server.cfg"
          upload_file(server_config, server_config_path)
        end
      end
    end
  end

  %w(start stop restart).each do |command|
    desc "supervisorctl #{command} quakelive processes"
    task "#{command}" do
      on roles(:app) do
        within release_path do
          sudo :supervisorctl, "#{command}", 'quakelive:*'
        end
      end
    end
  end

  task :uninstall do
    on roles(:app) do
      within release_path do
        num_processes = fetch(:supervisor_num_processes)
        start_port = fetch(:qlds_gameport_start)
        end_port = start_port + num_processes - 1
        start_port.upto(end_port) do |port|
          destination = "#{fetch(:qlds_server_path)}"
          execute :rm, '-rf', destination
        end
      end
    end
  end
end
