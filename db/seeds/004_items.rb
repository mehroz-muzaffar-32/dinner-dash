# frozen_string_literal: true

restaurants = Restaurant.all

categories = Category.all

items_data = [
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

items_data.each do |item|
  Item.find_or_create_by(item) do |new_item|
    new_item.categories = categories
  end
end
