# frozen_string_literal: true

User.create(full_name: 'Admin', email: 'admin@email', password: 'sekret', role: :admin)
User.create(full_name: 'Mehroz Muzaffar', email: 'mehroz@email', password: 'secret')
User.create(full_name: 'Test User', email: 'testuser@email', password: 'password')

Restaurant.create(
  [
    { name: 'Savour Foods' },
    { name: 'Lahore Broast' },
    { name: 'Yasir Broast' }
  ]
)
restaurants = Restaurant.all

Category.create(
  [
    { name: 'Cousine' },
    { name: 'Dinner' },
    { name: 'Fast Food' },
    { name: 'Lunch' }
  ]
)

categories = Category.all

Item.create!(
  [
    {
      restaurant: restaurants[0],
      title: 'Pulao Kabab',
      description: 'Tasty Pulao',
      price: 250,
      categories: categories
    },
    {
      restaurant: restaurants[0],
      title: 'Chicken Burger',
      description: 'Tasty Burger',
      price: 320,
      categories: categories
    },
    {
      restaurant: restaurants[1],
      title: 'Shawarma',
      description: 'Tasty Food',
      price: 150,
      categories: categories
    },
    {
      restaurant: restaurants[2],
      title: 'Chicken Broast',
      description: 'Tasty',
      price: 900,
      categories: categories
    },
    {
      restaurant: restaurants[2],
      title: 'Fish Broast',
      description: 'Tasty',
      price: 1100,
      categories: categories
    },
    {
      restaurant: restaurants[1],
      title: 'Fish Fry',
      description: 'Tasty',
      price: 500,
      categories: categories
    }
  ]
)
