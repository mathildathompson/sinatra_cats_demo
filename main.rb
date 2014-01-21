require 'pry'
require 'sinatra'
# require 'sinatra/reloader' if development? 
require 'active_support/all'
require 'pg'

#We need routes, submit post request and stores in the database
#

#The before block runs everytime, for example before each route I need to grab something, 
get '/' do 
    sql = "SELECT * FROM cats;"
    @row = run_sql(sql)
    erb :home
    
end

get '/new' do
#Shows the actual form
    erb :new
end

post '/create' do
    sql = "INSERT INTO CATS (name, photo, breed) values('#{params[:name]}', '#{params[:photo]}', '#{params[:breed]}');"
    run_sql(sql)

    redirect to '/'
end

get '/cats/:id/edit' do
    # @id = params[:id]
    sql = "SELECT * FROM cats WHERE id=#{params[:id]}"
    @records = run_sql(sql)
    #This is because it is returning a collection
    @cat = @records[0]
    erb :edit
end

post '/cats/:id/delete' do
    sql = "DELETE * FROM cats WHERE id=#{params[:id]}"
    run_sql(sql)
    redirect to '/'
end

#There is not 100% support for delete on all browsers

post '/cats/:id/edit' do
    sql = "UPDATE cats set name='#{params[:name]}', photo='#{params[:photo]}', breed='#{params[:breed]}' WHERE id=#{params[:id]}"
    run_sql(sql)
    redirect to '/'
end





def run_sql(sql)
    # conn = PG.connect(:dbname => 'Blogosphere')
    conn = PG::Connection.open(:dbname => 'Blogosphere')
    # conn = psql Blogosphere
    binding.pry

    res = conn.exec(sql)

    conn.close

    res

    puts res
    #connect to the cats database
    #execute the SQL in the argument
    #close the database connection
    #return the result of the SQL
    #This would be bette in the helper block, but you can write it here
    #Helper allows you to use it in the view, like generating a link method
end

