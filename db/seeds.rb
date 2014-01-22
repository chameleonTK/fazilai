# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([email: "admin@fazilai.curve.in.th",password: "admin"])
User.create([email: "kramatk@gmail.com",password: "kramatk"])
User.create([email: "narutoct@gmail.com",password: "narutoct"])
User.create([email: "nrokappet@gmail.com",password: "nrokappet"])

Server.create([ name: "curve", domain: "ftp.curve.in.th",user:"curveinth",password:"2curveTK"])

