# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Item.destroy_all
Category.destroy_all
Order.destroy_all
User.destroy_all

# Create categories
categories = [
  { name: "Appetizers" },
  { name: "Main Courses" },
  { name: "Desserts" },
  { name: "Beverages" },
  { name: "Specials" }
]

Category.create(categories)

# Create items
items = [
  { title: "Garlic Bread", description: "Toasted bread with garlic butter", price: 5.99, category_ids: [Category.find_by(name: "Appetizers").id] },
  { title: "Margherita Pizza", description: "Classic pizza with tomato sauce, mozzarella cheese, and basil", price: 12.99, category_ids: [Category.find_by(name: "Main Courses").id] },
  { title: "Chocolate Brownie", description: "Rich and fudgy chocolate brownie with a scoop of vanilla ice cream", price: 6.99, category_ids: [Category.find_by(name: "Desserts").id] },
  { title: "Coke", description: "Carbonated soft drink", price: 1.99, category_ids: [Category.find_by(name: "Beverages").id] },
  { title: "Chef's Special", description: "A unique dish prepared by our chef using the freshest ingredients", price: 15.99, category_ids: [Category.find_by(name: "Specials").id] }
]

Item.create(items)


#create users
users = [
  { first_name: "Jeff", last_name: "Casimir", email: "demo+jeff@jumpstartlab.com", password: "password",password_confirmation:"password"},
  { first_name: "Jorge", last_name: "Tellez", email: "demo+jorge@jumpstartlab.com", password: "password",password_confirmation:"password"},
  { first_name: "Josh", last_name: "Cheek", email: "demo+josh@jumpstartlab.com", password: "password",password_confirmation:"password"}
 
]

User.create(users)


#Create orders

user = User.first
order = Order.create(status: "completed", user_id: user.id)

order_item = OrderItem.create(quantity: 3, item_id: Item.first.id, order_id: order.id)

user = User.first
cart = user.create_cart
cart.cart_items.create(item: Item.first, quantity: 2)
cart.cart_items.create(item: Item.last, quantity: 1)

puts "Seed data created successfully!" 