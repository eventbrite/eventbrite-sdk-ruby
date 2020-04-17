module EventbriteSDK
  class Organization < Resource
    ALL_DISCOUNTS = 'user',
    SINGLE_EVENT_DISCOUNTS = 'event',
    MULTI_EVENT_DISCOUNTS = 'multi_events',

    # Event search "order_by" values
    CREATED_NEWEST_FIRST = 'created_desc',
    CREATED_OLDEST_FIRST = 'created_asc',
    START_NEWEST_FIRST = 'start_desc',
    START_OLDEST_FIRST = 'start_asc',

    # Event search "status" values
    # ALL will cause the search to return any of the following:
    #   canceled
    #   ended
    #   finalized
    #   incomplete
    #   live
    #   started
    #   payout_issued
    ALL = 'all',
    CANCELED = 'canceled',
    DRAFT = 'draft',
    # ENDED will return any of the following:
    #   ended
    #   finalized
    #   payout_issued
    ENDED = 'ended',
    LIVE = 'live',
    STARTED = 'started'

    resource_path 'organizations/:id'

    has_many :discounts, object_class: 'OrgDiscount'
    has_many :organizers, object_class: 'Organizer', key: :organizers
    # Previously :owned_event_orders
    has_many :orders, object_class: 'Order', key: :orders
    # Previously :owned_events
    has_many :events, object_class: 'OrgEvent', key: :events
    has_many :ticket_classes, object_class: 'TicketClass'
    has_many :ticket_groups, object_class: 'TicketGroup'
    # Query for all events, ordered by start date in ascending order.
    #
    #   order_by: Change the order they are returned. Supports:
    #     created_asc
    #     created_desc
    #     start_asc
    #     start_desc
    #
    #   status: Status(es) of events you want. Supports single values or CSV:
    #     all      - all available statuses. Includes:
    #     canceled - only canceled.
    #     draft    - only draft
    #     ended    - all ended statuses. Includes:
    #     live     - only live
    #     started  - only started
    #
    def upcoming_events(order_by: self.class::START_OLDEST_FIRST,
                        status: self.class::ALL)
      EventbriteSDK::ResourceList.new(
        url_base: "#{path}/events",
        object_class: EventbriteSDK::Event,
        key: 'events',
        query: {
          order_by: order_by,
          status: status
        }
      )
    end

    def search_orders(query)
      EventbriteSDK::ResourceList.new(
        url_base: "#{path}/orders/search",
        object_class: EventbriteSDK::Order,
        key: :orders,
        query: {
          search_term: query
        }
      )
    end

    # NOTE Shim to normalize API between a user/organization
    def owned_events
      events
    end
  end
end
