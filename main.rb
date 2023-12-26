# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'

helpers do
  include Rack::Utils
  alias_method :escape_proccesing, :escape_html
end

FILE_PATH = 'public/memo.json'

def get_memos(file_path)
  File.open(file_path) do |file|
    JSON.parse(file.read)
  end
end

def add_memos(file_path, memos)
  File.open(file_path, 'w') do |f|
    JSON.dump(memos, f)
  end
end

get '/' do
  @page_title = 'top'
  @memos = get_memos(FILE_PATH)
  erb :index
end

get '/memos/new' do
  @page_title = 'new'
  erb :new
end

get '/memos/:id' do
  @page_title = 'show'
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :show
end

get '/memos/:id/edit' do
  @page_title = 'edit'
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :edit
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(FILE_PATH)
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  add_memos(FILE_PATH, memos)

  redirect '/'
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(FILE_PATH)
  memos[params[:id]] = { 'title' => title, 'content' => content }
  add_memos(FILE_PATH, memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  add_memos(FILE_PATH, memos)

  redirect '/'
end
