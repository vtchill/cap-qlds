require 'erb'

def template(filename)
  File.read("config/templates/#{filename}")
end

def config(filename)
  File.read("config/#{filename}")
end

def erb_file(file)
  ERB.new(template(file)).result(binding)
end

def upload_file(contents, upload_path)
  upload! StringIO.new(contents), upload_path
end

def put_sudo(contents, upload_path)
  filename = File.basename(upload_path)
  tmp_filename = "/tmp/#{filename}"
  put StringIO.new(contents), tmp_filename
  run :sudo, :mv, tmp_filename, upload_path
end
