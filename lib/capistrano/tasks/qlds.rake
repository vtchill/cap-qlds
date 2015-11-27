namespace :qlds do
  task :install do
    on roles(:app) do
      within release_path do
        num_processes = fetch(:supervisor_num_processes)
        start_port = fetch(:qlds_gameport_start)
        end_port = start_port + num_processes - 1
        start_port.upto(end_port) do |port|
          destination = "$HOME/qlds/servers/#{port}/baseq3"
          execute :mkdir, '-p', destination
          execute :cp, '-R', 'qlds_files/baseq3', destination
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
          destination = "$HOME/qlds/servers/#{port}"
          execute :rm, '-rf', destination
        end
      end
    end
  end

  task :copy_config do
    on roles(:app) do
      within release_path do
        settings_file = File.read('config/qlds.yml')
        settings = YAML.load(ERB.new(settings_file).result)

        num_processes = fetch(:supervisor_num_processes)
        start_port = fetch(:qlds_gameport_start)
        end_port = start_port + num_processes - 1
        start_port.upto(end_port).with_index(1) do |port, index|
          server_settings = OpenStruct.new(settings['servers'][index])
          server_num = index
          server_config_example = "config/templates/server.cfg.erb"
          server_config = "$HOME/qlds/servers/#{port}/baseq3/server.cfg"
          File.open(server_config, 'w') do |f|
            f.write ERB.new(server_config_example).result(binding)
          end
        end
      end
    end
  end
end
