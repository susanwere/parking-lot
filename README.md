[![Coverage Status](https://coveralls.io/repos/github/susanwere/parking-lot/badge.svg)](https://coveralls.io/github/susanwere/parking-lot)  [![Build Status](https://travis-ci.org/susanwere/parking-lot.svg?branch=master)](https://travis-ci.org/susanwere/parking-lot)  [![Maintainability](https://api.codeclimate.com/v1/badges/25d7c3525ac474e96289/maintainability)](https://codeclimate.com/github/susanwere/parking-lot/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/25d7c3525ac474e96289/test_coverage)](https://codeclimate.com/github/susanwere/parking-lot/test_coverage)

# PARKING LOT

  Parking Lot Company

### Ruby version

  Ruby 2.7.0

### Database creation

  Add the following environment variables in your `~/.bashrc` file

    1. export POSTGRES_USERNAME=POSTGRES_USERNAME
    2. export POSTGRES_PASSWORD=POSTGRES_PASSWORD
    3. export RUBYOPT='-W:no-deprecated -W:no-experimental' //to surpress ruby 2.7.0 warnings

### APIS

  #### Post a new ticket

      `https://app-parking-lot.herokuapp.com/api/tickets`

  #### Get all tickets

      `https://app-parking-lot.herokuapp.com/api/tickets`

  #### Get ticket by barcode

      `https://app-parking-lot.herokuapp.com/api/tickets/{barcode}`

  #### Post to mark ticket as paid

      `https://app-parking-lot.herokuapp.com/api/tickets/{barcode}/payments`

  #### Get paid state of the ticket

      `https://app-parking-lot.herokuapp.com/api/tickets/{barcode}/state`
