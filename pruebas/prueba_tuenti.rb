require 'base'
require 'tuenti'

t = Tuenti.new(SMS_RECEIVER_MAIL, SMS_RECEIVER_PASS)
t.set_status("Cambiando estado #{Time.now.to_s}")
#t.upload_img("/Users/hydrus/Pictures/Imagen 3.png")
#t.upload_img("/Users/hydrus/Pictures/saturno.jpg")
#t.upload_img("/Users/hydrus/Pictures/Ichigo_by_JojoRatonLaveur.png")
