# MMS receiver credentials
MMS_RECEIVER_PHONE = "630348665"
MMS_RECEIVER_PASS  = "566843"

# SMS receiver credentials
SMS_RECEIVER_PHONE = "630348665"
SMS_RECEIVER_MAIL  = "test.openmovilforum@gmail.com"
SMS_RECEIVER_PASS  = "12341234"

# SMS sender credentials
SMS_SENDER_PHONE   = MMS_RECEIVER_PHONE
SMS_SENDER_PASS    = MMS_RECEIVER_PASS

# Directory where incoming MMSs will be stored
MMS_QUEUE_DIR      = File.expand_path(File.join(File.dirname(__FILE__), "../received_mms"))

# Daemon sleep times
MMS_RECEIVER_SLEEP = 60
SMS_RECEIVER_SLEEP = 60
IMG_PUBLISH_SLEEP  = 10

# Database config
DB_HOST = "localhost"
DB_NAME = "twenty_mobile"
DB_USER = "root"
DB_PASS = ""
DB_TABLE = "tuenti_credentials"
DB_CONFIG = {
  :adapter  => "mysql",
  :host     => DB_HOST,
  :database => DB_NAME,
  :username => DB_USER,
  :password => DB_PASS
}

# Options for daemons
DAEMON_OPTIONS = {
  :log_output => true,
  :backtrace  => true,
  :dir_mode => :normal,
  :dir => File.join(File.dirname(File.expand_path(__FILE__)), '../logs'),
  :multiple => false
}
