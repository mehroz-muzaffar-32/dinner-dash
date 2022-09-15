# Dinner Dash v2.0

## Deployment Link
* dinner-dash-v2-test-project: http://dinner-dash-v2-test-project.herokuapp.com/

## Ruby version

* ruby 2.7.2

## Rails version

* rails 5.2

## System dependencies

* bootstrap
* devise
* google-cloud-storage
* jquery-rails

## Configuration
* bundle install

## Database creation
* rake db:migrate

## Database initialization
* rake db:seed

## Deployment instructions
* heroku create dinner-dash-v2-test-project
* heroku stack:set heroku-22
* git push heroku bootstrap-frontend:master
* heroku run rake db:migrate
* heroku run rake db:seed
