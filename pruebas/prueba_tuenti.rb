require 'lib/tuenti'

USER = "test.openmovilforum@gmail.com"
PASSWORD = "12341234"

t = Tuenti.new(USER, PASSWORD)
t.set_status("Cambiando estado #{Time.now.to_s}")
#t.upload_img("/Users/hydrus/Pictures/Imagen 3.png")
#t.upload_img("/Users/hydrus/Pictures/saturno.jpg")
#t.upload_img("/Users/hydrus/Pictures/Ichigo_by_JojoRatonLaveur.png")
