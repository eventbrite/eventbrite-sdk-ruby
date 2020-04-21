require 'spec_helper'

module EventbriteSDK
  RSpec.describe Organization do
    describe '#discounts' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/discounts/?page=2",
          body: {
            discounts: [{ id: 'd' }]
          }
        )

        list = org.discounts.page(2)

        expect(list.first.id).to eq('d')
      end
    end

    describe '#events' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/events/?page=1",
          body: {
            events: [{ id: 'e' }]
          }
        )

        list = org.events.page(1)

        expect(list.first.id).to eq('e')
      end
    end

    describe '#orders' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/orders/?page=1",
          body: {
            orders: [{ id: 'o' }]
          }
        )

        list = org.orders.page(1)

        expect(list.first.id).to eq('o')
      end
    end

    describe '#organizers' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/organizers/?page=1",
          body: {
            organizers: [{ id: 'o' }]
          }
        )

        list = org.organizers.page(1)

        expect(list.first.id).to eq('o')
      end
    end

    describe '#owned_events' do
      it 'returns the response for #events' do
        org = described_class.new(id: 'id')

        allow(org).to receive(:events).and_return('yay')

        result = org.owned_events

        expect(result).to eq('yay')
      end
    end

    describe '#search_orders' do
      it 'returns correctly instantiated ResourceList' do
        subject = described_class.new(id: 'id')

        allow(EventbriteSDK::ResourceList).
          to receive(:new).and_call_original

        subject.search_orders('whoa')

        expect(EventbriteSDK::ResourceList).
          to have_received(:new).
          with({
            url_base: 'organizations/id/orders/search',
            object_class: EventbriteSDK::Order,
            key: :orders,
            query: {
              search_term: 'whoa'
            }
          })
      end
    end

    describe '#ticket_classes' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/ticket_classes/?page=1",
          body: {
            ticket_classes: [{ id: 't' }]
          }
        )

        list = org.ticket_classes.page(1)

        expect(list.first.id).to eq('t')
      end
    end

    describe '#ticket_groups' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/ticket_groups/?page=1",
          body: {
            ticket_groups: [{ id: 't' }]
          }
        )

        list = org.ticket_groups.page(1)

        expect(list.first.id).to eq('t')
      end
    end

    describe '#upcoming_events' do
      it 'returns a ResourceList hydrated with the correct path' do
        org = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{org.id}/events/?page=1&order_by=#{described_class::START_OLDEST_FIRST}&status=#{described_class::ALL}",
          body: {
            events: [{ id: 'e' }]
          }
        )

        list = org.upcoming_events.page(1)

        expect(list.first.id).to eq('e')
      end

      it 'accepts a custom order_by value' do
        subject = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{subject.id}/events/?page=1&order_by=my_order&status=#{described_class::ALL}",
          body: {
            events: [{ id: 'e' }]
          }
        )

        subject.upcoming_events(order_by: 'my_order').page(1)
      end

      it 'accepts a custom status value' do
        subject = described_class.new(id: 'id')

        stub_get(
          path: "organizations/#{subject.id}/events/?page=1&order_by=#{described_class::START_OLDEST_FIRST}&status=my_status",
          body: {
            events: [{ id: 'e' }]
          }
        )

        subject.upcoming_events(status: 'my_status').page(1)
      end
    end
  end
end
