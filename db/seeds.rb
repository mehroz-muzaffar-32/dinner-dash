# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(full_name: 'Admin', email: 'admin@email', password: 'sekret', role: :admin)
User.create(full_name: 'Mehroz Muzaffar', email: 'mehroz@email', password: 'secret')

Restaurant.create(
  [
    { name: 'Savour Foods' },
    { name: 'Lahore Broast' },
    { name: 'Yasir Broast' }
  ]
)
restaurants = Restaurant.all

Item.create!(
  [
    {
      restaurant: restaurants[0],
      title: 'Pulao Kabab',
      description: 'Tasty Pulao',
      price: 250
    },
    {
      restaurant: restaurants[0],
      title: 'Chicken Burger',
      description: 'Tasty Burger',
      price: 320
    },
    {
      restaurant: restaurants[1],
      title: 'Shawarma',
      description: 'Tasty Food',
      price: 150
    },
    {
      restaurant: restaurants[2],
      title: 'Chicken Broast',
      description: 'Tasty',
      price: 900
    },
    {
      restaurant: restaurants[2],
      title: 'Fish Broast',
      description: 'Tasty',
      price: 1100
    },
    {
      restaurant: restaurants[1],
      title: 'Fish Fry',
      description: 'Tasty',
      price: 500
    }
  ]
)
