require 'activerecord'

ActiveRecord::Base.establish_connection(DB_CONFIG)

# create your AR class
class TuentiCredential < ActiveRecord::Base
  set_table_name DB_TABLE
  validates_presence_of :phone
  validates_uniqueness_of :phone
  
  validates_presence_of :email
  
  validates_presence_of :password
end

