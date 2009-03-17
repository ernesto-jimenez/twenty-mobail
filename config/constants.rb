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

# Amount of seconds MMSs are keeped waiting for credentials
MMS_TIME_WAITING_FOR_CREDENTIALS = 86400 # 24 hours

# Daemon sleep times
MMS_RECEIVER_SLEEP = 60
SMS_RECEIVER_SLEEP = 60
IMG_PUBLISH_SLEEP  = 10

# Database config
DB_TABLE = "tuenti_credentials"
DB_CONFIG = {
  :adapter  => "mysql",
  :host     => "localhost",
  :database => "twenty_mobile",
  :username => "root",
  :password => ""
}

# Options for daemons
DAEMON_OPTIONS = {
  :log_output => true,
  :backtrace  => true,
  :dir_mode => :normal,
  :dir => File.join(File.dirname(File.expand_path(__FILE__)), '../logs'),
  :multiple => false
}
