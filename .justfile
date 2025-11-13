default:
    just --list

assets-reset:
    bin/rails assets:clobber
    bin/rails assets:precompile

db-snapshot:
    @read -p "Enter the access key: " KEY && \
    curl https://synyster.ch/admin/db_tables_snapshot?key=${KEY} | \
    (command -v vd >/dev/null 2>&1 && vd || \
     command -v jless >/dev/null 2>&1 && jless || \
     command -v jq >/dev/null 2>&1 && jq | less || \
     cat)

db-reset:
    bin/rails db:drop db:create db:migrate db:seed

dev:
    bin/dev -p 3000

install:
    bundle install
    bin/importmap pristine
    yarn install

lint:
    bundle exec rubocop --color
    yarn eslint . --color

lint-fix:
    bundle exec rubocop -A --color
    yarn eslint . --fix --color

server:
    bin/rails server

setup:
    bundle install
    yarn install

update:
    bundle update
    bin/importmap update
    yarn upgrade
