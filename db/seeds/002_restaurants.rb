# frozen_string_literal: true

restaurants_data = [
  { name: 'Savour Foods' },
  { name: 'Lahore Broast' },
  { name: 'Yasir Broast' }
]

restaurants_data.each do |restaurant|
  Restaurant.find_or_create_by(restaurant)
end
