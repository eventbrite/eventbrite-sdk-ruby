module EventbriteSDK
  class Venue < Resource
    resource_path 'venues/:id'

    attributes_prefix 'venue'

    schema_definition do
      string 'address.address_1'
      string 'address.address_2'
      string 'address.city'
      string 'address.country'
      string 'address.latitude' # decimal, passed as string.
      string 'address.localized_address_display'
      string 'address.localized_area_display'
      string 'address.longitude' # decimal, passed as string.
      string 'address.postal_code'
      string 'address.region'
      string 'age_restriction'
      string 'capacity'
      string 'latitude'
      string 'longitude'
      string 'name'
    end
  end
end
