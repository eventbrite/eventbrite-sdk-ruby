# EventbriteSdk

[![Code Climate](https://codeclimate.com/github/eventbrite/eventbrite-sdk-ruby/badges/gpa.svg)](https://codeclimate.com/github/eventbrite/eventbrite-sdk-ruby) [![Issue Count](https://codeclimate.com/github/eventbrite/eventbrite-sdk-ruby/badges/issue_count.svg)](https://codeclimate.com/github/eventbrite/eventbrite-sdk-ruby) [![Build Status](https://travis-ci.org/eventbrite/eventbrite-sdk-ruby.svg?branch=master)](https://travis-ci.org/eventbrite/eventbrite-sdk-ruby) [![Test Coverage](https://codeclimate.com/github/eventbrite/eventbrite-sdk-ruby/badges/coverage.svg)](https://codeclimate.com/github/eventbrite/eventbrite-sdk-ruby/coverage) [![Dependency Status](https://gemnasium.com/badges/github.com/eventbrite/eventbrite-sdk-ruby.svg)](https://gemnasium.com/github.com/eventbrite/eventbrite-sdk-ruby) [![Gem Version](https://badge.fury.io/rb/eventbrite_sdk.svg)](https://badge.fury.io/rb/eventbrite_sdk)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eventbrite_sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eventbrite_sdk

## Usage

The library needs to be configured with your account's personal OAuth token which is available in your [App Management][app management] page. Assign it's value to `EventbriteSDK.token` and the library will send it along automatically with every request.

# Basic usage for creating/retrieving/updating/publishing an event:

``` ruby

EventbriteSDK.token = "TOKEN"

# create an event draft
your_event = EventbriteSDK::Event.build('name.html' => 'Event Name', 'start.utc' => '2018-01-31T13:00:00Z', 'start.timezone' => 'America/Los_Angeles', 'end.utc' => '2018-02-01T13:00:00Z', 'end.timezone' => 'America/Los_Angeles', 'currency' => 'USD')

your_event.save
# => true

# retrieve your event
your_event

# retrieve one field on the object
your_event.id

# retrieve any event by id
EventbriteSDK::Event.retrieve(id: 20955468370)

# update the event
your_event.assign_attributes('name.html' => 'A new name', 'description.html' => 'A new description')

your_event.save
# =>true

# add ticket classes to the event
event_ticket = EventbriteSDK::TicketClass.new(event_id: your_event.id)
event_ticket.assign_attributes('name'=>'Ticket Name', 'cost'=>'USD,3400', 'quantity_total'=>'378')

event_ticket.save

# to see if the event is 'dirty' (i.e. has unsaved changes)
your_event.changed?
# =>true

# save the changes
your_event.save

# publish the event
your_event.publish

```

# Navigating paginated responses:

``` ruby

EventbriteSDK.token = "TOKEN"

# one feature of the Eventbrite API is that you can pass in the string 'me' in place of a
# user id and it will evaluate to the id of the user associated with the oauth token.
user = EventbriteSDK::User.retrieve(id: 'me')

# or fetch a new user record using the Eventbrite user id
user = EventbriteSDK::User.retrieve(id: 163054428874)

# you can now fetch events per organization
organization = user.organizations.page(1).first
events = organization.events.page(1)

# not providing a page number will default to page one
events = organization.events.page(1) => events = organization.events

# events is now an enumerable object that you can access using bracket notation or first/last
events.first => events[0]
events.last => events[-1]

# endpoints that support continuations: will be inferred from the current payload
# you can tell if a paginated result set supports continuations by checking for a non-nil #continuation

example.continuation #=> "dGhpcyBpcyBwYWdlIDE"

# you can continue until the example returns nil, which means there are no more items
example.continue

# you can also provide a token if you choose to do so
example.continue(continuation_token: 'my_token')
```

# Use `#retrieve` to build up arbitrary queries

``` ruby

# For example, to use the 'status' parameter seen here: https://www.eventbrite.com/developer/v3/endpoints/events/#ebapi-id78

user = EventbriteSDK::User.retrieve(id: 163054428874)
organization = user.organizations.first
organization.events.retrieve(query: { status: 'live' })

```

# Construct endpoint paths:

``` ruby

EventbriteSDK.token = "TOKEN"

# access this endpoint www.eventbriteapi.com/v3/events/:id/ticket_classes/:id/
ticket = EventbriteSDK::TicketClass.retrieve(event_id: 20928651159, id: 43892783)

```
# Use expansions

``` ruby

EventbriteSDK.token = "TOKEN"

# get an order with attendees expanded

order = EventbriteSDK::Order.retrieve(id: id, expand: [:attendees])

# include multiple expansions in one request

order = EventbriteSDK::Order.retrieve(id: id, expand: [:attendees, :event])

```

# Per-request Configuration

For apps that need to use multiple tokens during the lifetime of a process, it is
possible to set a per-request token:

``` ruby

# Retrieving

EventbriteSDK::Order.retrieve(
  id: id,
  api_token: YOUR_REQUEST_TOKEN
)

# Retrieving lists

events = EventbriteSDK::User.me.owned_events.page(1, api_token: YOUR_REQUEST_TOKEN)

events.next_page(api_token: YOUR_REQUEST_TOKEN)

# Saving/Deleting

event.save(api_token: YOUR_REQUEST_TOKEN)

order.delete(api_token: YOUR_REQUEST_TOKEN)

```

If you forget to provide the api_token key and `EventbriteSDK.token` is set, the request
will fall-back on the global token for the action called.

# Shallow resource list endpoints

Some paginated lists are available at the base of the resource url, webhooks and
categories for example. The resources that have this trait will include the `Operations::List` module

``` ruby

# Retrieving

categories = EventbriteSDK::Category.list.page(1) #=> GET /v3/categories/?page=1
webhooks = EventbriteSDK::Webhook.list.page(1) #=> GET /v3/webhooks/?page=1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eventbrite/eventbrite-sdk-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
