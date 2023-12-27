# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'
require 'pg'

configure do
  result = connection.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  connection.exec('CREATE TABLE memos (id serial, title text, content text)') if result.values.empty?
end

helpers do
  include Rack::Utils
  alias_method :escape_proccesing, :escape_html
end

def connection
  PG.connect(dbname: 'fbc_memo_app')
end

get '/' do
  @page_title = 'top'
  @memos = connection.exec('SELECT * FROM memos')
  erb :index
end

get '/memos/new' do
  @page_title = 'new'
  erb :new
end

get '/memos/:id' do
  @page_title = 'show'
  memo = connection.exec_params('SELECT * FROM memos WHERE id = $1;', [params[:id]]).values[0]
  @title = memo[1]
  @content = memo[2]
  erb :show
end

get '/memos/:id/edit' do
  @page_title = 'edit'
  memo = connection.exec_params('SELECT * FROM memos WHERE id = $1;', [params[:id]]).values[0]
  @title = memo[1]
  @content = memo[2]
  erb :edit
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  connection.exec_params('INSERT INTO memos(title, content) VALUES($1, $2)', [title, content])

  redirect '/'
end

patch '/memos/:id' do
  id = params[:id]
  title = params[:title]
  content = params[:content]
  connection.exec_params('UPDATE memos SET title=$2, content=$3 WHERE id=$1', [id, title, content])

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  connection.exec_params('DELETE FROM memos WHERE id=$1', [params[:id]])

  redirect '/'
end
