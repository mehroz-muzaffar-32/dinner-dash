# frozen_string_literal: true

categories_data = [
  { name: 'Cousine' },
  { name: 'Dinner' },
  { name: 'Fast Food' },
  { name: 'Lunch' }
]

categories_data.each do |category|
  Category.find_or_create_by(category)
end
