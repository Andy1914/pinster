# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.where(:name=>"Home & Personal",:image=>"home-pers-icon.png").first_or_create
Category.where(:name=>"Work & Ofice",:image=>"work-office-icon.png").first_or_create
Category.where(:name=>"Food & Restaurant",:image=>"food-restu-icon.png").first_or_create
Category.where(:name=>"Outdoors",:image=>"outdoors-icon.png").first_or_create
Category.where(:name=>"NightLife",:image=>"night-life-icon.png").first_or_create
Category.where(:name=>"Shoping",:image=>"shopping-icon.png").first_or_create