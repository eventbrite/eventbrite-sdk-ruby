module EventbriteSDK
  class Attendee < Resource
    resource_path 'events/:event_id/attendees/:id'

    belongs_to :event, object_class: 'Event'
    belongs_to :order, object_class: 'Order'

    has_many :attendees, object_class: 'Attendee'

    schema_definition do
      string 'event_id'
      string 'order_id'
      string 'ticket_class_id'
      string 'ticket_class_name'
      string 'status'
      boolean 'refunded'
      boolean 'cancelled'
      boolean 'checked_in'
      integer 'quantity'
      string 'profile'
      string 'costs'
      utc 'created', read_only: true
      utc 'changed', read_only: true
      string 'resource_uri', read_only: true
    end
  end
end
