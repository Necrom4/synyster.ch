<center>

# Synyster Website

[<img src="https://img.shields.io/badge/website-link-blue">](https://synyster.ch)

Small personal project intended to teach myself the structure of a simple website and train my front end skills.

</center>

![ezgif com-resize](https://github.com/user-attachments/assets/39635fcb-da16-4492-af24-33c463312141)

## TODO

- [ ] Add tests for CI
- [ ] Default language depending on IP location
- [ ] Add contact form
- [ ] Add mail list
- [ ] Add web push notifications
- [ ] Add files (logos, tech rider)
- [X] Use hybrid ActiveRecord-(Postgre)SQL_query for `FilteredTraffic`
- [X] Use Postgres for Dev and Test environments
- [x] Add `.justfile`
- [x] Add visit/event tracker using `ahoy`
- [ ] `Visitor Count`
  - [ ] Movement Event tracking (JS)
  - [x] Add bot blocking using `rack-attack`
  - [x] Add Hostname, Organization_name and Location to Ahoy::Visit using `resolv` and `geocoder` (without `SolidQueue`, synchronous)
  - [x] Print DB tables as json in hidden path
  - [x] Add front-end human visits counter
- [x] Add static DB
  - [x] Implement translation
  - [x] Add controllers to sort media
  - [x] Add pictures in CDN and add links to `data.yml`
- [x] Use `Bootstrap` and `Hotwire`
  - [ ] Fix `sass` deprecated warning
  - [ ] Add notifications (server-side and client-side)
    - [x] Move `Visitor Count` to random notification
    - [x] Add 'Show this week' notification
  - [x] Implement galleries (dynamic picture grids)
