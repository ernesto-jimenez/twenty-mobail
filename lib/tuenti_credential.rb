#require 'rubygems'
require 'sqlite3'
require 'activerecord'

# connect to database.  This will create one if it doesn't exist
MY_DB_NAME = "tuenti_credentials.db"
MY_DB = SQLite3::Database.new(MY_DB_NAME)

# get active record set up
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => MY_DB_NAME)

# create your AR class
class TuentiCredential < ActiveRecord::Base
  validates_presence_of :phone
  validates_uniqueness_of :phone
  
  validates_presence_of :email
  
  validates_presence_of :password
end

# do a quick pseudo migration.  This should only get executed on the first run
if !TuentiCredential.table_exists?
  ActiveRecord::Base.connection.create_table(:tuenti_credentials) do |t|
    t.column :phone, :string
    t.column :email, :string
    t.column :password, :string
  end
end
