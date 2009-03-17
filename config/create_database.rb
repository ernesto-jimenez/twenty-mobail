require File.join(File.dirname(__FILE__), '../base')
require 'activerecord'


# Snippet adapted from Rails database tasks
begin
  ActiveRecord::Base.establish_connection(DB_CONFIG)
  ActiveRecord::Base.connection
rescue
  @charset = ENV['CHARSET'] || 'utf8'
  @collation = ENV['COLLATION'] || 'utf8_general_ci'
  begin
    ActiveRecord::Base.establish_connection(DB_CONFIG.merge('database' => nil))
    ActiveRecord::Base.connection.create_database(DB_CONFIG[:database], :charset => (DB_CONFIG[:charset] || @charset), :collation => (DB_CONFIG[:collation] || @collation))
    ActiveRecord::Base.establish_connection(DB_CONFIG)
  rescue
    $stderr.puts "Couldn't create database for #{DB_CONFIG.inspect}, charset: #{DB_CONFIG[:charset] || @charset}, collation: #{DB_CONFIG[:collation] || @collation} (if you set the charset manually, make sure you have a matching collation)"
  else
    $stdout.puts "#{DB_CONFIG[:database]} database created"
  end
else
  $stderr.puts "#{DB_CONFIG[:database]} database already exists"
end

begin
  require 'tuenti_credential'
  if !TuentiCredential.table_exists?
    ActiveRecord::Base.connection.create_table(DB_TABLE) do |t|
      t.column :phone, :string
      t.column :email, :string
      t.column :password, :string
    end
    $stdout.puts "#{DB_TABLE} database created"
  else
    $stdout.puts "#{DB_TABLE} table already exists"
  end
rescue  
  $stderr.puts "Couldn't create table for #{DB_TABLE}"
end
