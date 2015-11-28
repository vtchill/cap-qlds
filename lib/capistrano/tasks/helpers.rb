require 'erb'

def home_path
  capture('$HOME')
end

def steam_path
  "#{home_path}/steamcmd"
end

def template(filename)
  File.read("config/templates/#{filename}")
end

def config(filename)
  File.read("config/#{filename}")
end

def erb_file(file, custom_binding = nil)
  ERB.new(file).result(custom_binding || binding)
end

def upload_file(contents, upload_path)
  upload! StringIO.new(contents), upload_path
end

def put_sudo(contents, upload_path)
  filename = File.basename(upload_path)
  tmp_filename = "/tmp/#{filename}"
  upload_file(contents, tmp_filename)
  execute :sudo, :mv, tmp_filename, upload_path
end
