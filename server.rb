require 'sinatra'
set :public_folder, Proc.new { File.join(root, "lib") }

get '/' do
  haml :index
end

