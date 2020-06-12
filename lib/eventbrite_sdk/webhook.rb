module EventbriteSDK
  class Webhook < Resource
    extend Operations::List

    resource_path 'organizations/:organization_id/webhooks/:id'

    belongs_to :organization, object_class: 'Organization'

    schema_definition do
      string 'endpoint_url'
      string 'event_id'
      string 'actions'
    end
  end
end
