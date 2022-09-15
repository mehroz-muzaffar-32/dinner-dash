# frozen_string_literal: true

User.find_or_create_by(full_name: 'Admin', email: 'admin@email', role: :admin) { |user| user.password = 'password' }
User.find_or_create_by(full_name: 'Mehroz Muzaffar', email: 'mehroz@email') { |user| user.password = 'password' }
User.find_or_create_by(full_name: 'Test User', email: 'testuser@email') { |user| user.password = 'password' }
