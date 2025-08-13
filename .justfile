default:
  just --list

assets-reset:
  bin/rails assets:clobber
  bin/rails assets:precompile

KEY := `read -p "Enter the access key: " KEY; echo $KEY`
db-check:
    @curl https://synyster.ch/admin/db-check?key={{KEY}} | jless

db-reset:
  bin/rails db:drop db:create db:migrate db:seed

dev:
  bin/dev -p 3000

lint:
  bundle exec rubocop
  yarn eslint .

lint-fix:
  bundle exec rubocop -A
  yarn eslint . --fix

server:
  bin/rails server

setup:
  bundle install
  yarn install

update:
  bundle update
  yarn upgrade
