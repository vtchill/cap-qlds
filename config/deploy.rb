# config valid only for current version of Capistrano
lock '3.4.0'

Dotenv.load(
  File.join(Dir.pwd, ".env.#{fetch(:stage)}"),
  File.join(Dir.pwd, '.env')
)

set :application, 'qlds'
set :repo_url, fetch(:repo_url)

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to, -> { ENV.fetch('DEPLOY_PATH', "/home/#{fetch(:user)}/qlds") }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('.env', 'config/qlds.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :repo_url, -> { ENV.fetch('REPOSITORY_URL', 'git@github.com:vtchill/cap-qlds.git') }
set :supervisor, -> { ENV.fetch('SUPERVISOR', '/usr/local/bin/supervisord') }
set :supervisor_conf_path, -> { ENV.fetch('SUPERVISOR_CONF', '/etc/supervisord.conf') }
set :supervisor_upstart_conf, -> { ENV.fetch('SUPERVISOR_UPSTART_CONF', '/etc/init/supervisord.conf') }
set :supervisor_process_name, -> { ENV.fetch('SUPERVISOR_PROCESS_NAME', 'qzeroded') }
set :supervisor_num_processes, -> { ENV.fetch('SUPERVISOR_NUM_PROCESSES', 5).to_i }

set :qlds_dir, -> { ENV.fetch('QLDS_DIR', "/home/steam/steamcmd/steamapps/common/qlds") }
set :qlds_x86, -> { ENV.fetch('QLDS_X86', "#{fetch(:qlds_dir)}/run_server_x86.sh")}
set :qlds_server_path, -> { ENV.fetch('QLDS_SERVER_PATH', "#{shared_path}/servers")}
set :qlds_gameport_start, -> { ENV.fetch('QLDS_GAMEPORT_START', 27960).to_i }
set :qlds_bot_enable, -> { ENV.fetch('QLDS_BOT_ENABLE', 1) }
set :qlds_bot_nochat, -> { ENV.fetch('QLDS_BOT_NOCHAT', 1) }
set :qlds_vote_flags, -> { ENV.fetch('QLDS_VOTE_FLAGS', '') }
set :qlds_spec_vote, -> { ENV.fetch('QLDS_SPEC_VOTE', 0) }
set :qlds_mid_game_vot, -> { ENV.fetch('QLDS_MID_GAME_VOTE', 0) }
set :qlds_access_file, -> { ENV.fetch('QLDS_ACCESS_FILE', 'access.txt') }
set :qlds_rcon_enable, -> { ENV.fetch('QLDS_RCON_ENABLE', 1) }
set :qlds_rcon_password, -> { ENV.fetch('QLDS_RCON_PASSWORD', '') }

set :user, -> { ENV.fetch('SSH_USER', 'steam') }
set :ssh_key, -> { ENV.fetch('SSH_KEY', '~/.ssh/vtchill_github') }
set :ssh_user, -> { fetch(:user) }

set :ssh_options, {
  keys: [fetch(:ssh_key)],
  forward_agent: true,
  auth_methods: %w(publickey password)
}

namespace :deploy do

end

before 'deploy:check:linked_files', 'config:push'
before 'deploy:publishing', 'qlds:install'
before 'deploy:publishing', 'supervisor:upstart'
before 'deploy:publishing', 'supervisor:config'
before 'deploy:publishing', 'supervisor:restart'
before 'deploy:publishing', 'qlds:restart'
after 'deploy:publishing', 'deploy:restart'
