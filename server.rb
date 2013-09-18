require 'sinatra'
set :public_folder, Proc.new { File.join(root) }
set :views, Proc.new { File.join(root, "src", "app") }

get '/' do
  erb :index
end

