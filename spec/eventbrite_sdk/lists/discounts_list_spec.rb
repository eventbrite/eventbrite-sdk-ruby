require 'spec_helper'

module EventbriteSDK
  module Lists
    RSpec.describe DiscountsList do
      describe '#search' do
        it 'defines the discount_scope param and returns itself' do
          request = double(get: {})
          subject = described_class.new(
            key: 'discounts',
            request: request,
            url_base: 'discounts/'
          )

          subject.search(scope: 'minty').retrieve

          expect(request).to have_received(:get).with(
            url: 'discounts/',
            query: {
              discount_scope: 'minty',
            },
            api_token: nil
          )
        end

        context 'when event_id is given' do
          it 'also defines event_id' do
            request = double(get: {})
            subject = described_class.new(
              key: 'discounts',
              request: request,
              url_base: 'discounts/'
            )

            subject.search(event_id: 12, scope: 'minty').retrieve

            expect(request).to have_received(:get).with(
              url: 'discounts/',
              query: {
                discount_scope: 'minty',
                event_id: 12,
              },
              api_token: nil
            )
          end
        end

        context 'when term is given' do
          it 'also defines code_filter' do
            request = double(get: {})
            subject = described_class.new(
              key: 'discounts',
              request: request,
              url_base: 'discounts/'
            )

            subject.search(scope: 'minty', term: 'foo').retrieve

            expect(request).to have_received(:get).with(
              url: 'discounts/',
              query: {
                code_filter: 'foo',
                discount_scope: 'minty',
              },
              api_token: nil
            )
          end
        end

        context 'when type is given' do
          it 'also defines type' do
            request = double(get: {})
            subject = described_class.new(
              key: 'discounts',
              request: request,
              url_base: 'discounts/'
            )

            subject.search(scope: 'minty', type: 'foo').retrieve

            expect(request).to have_received(:get).with(
              url: 'discounts/',
              query: {
                discount_scope: 'minty',
                type: 'foo'
              },
              api_token: nil
            )
          end

          context 'and the value is an array' do
            it 'defines it as a simple CSV' do
              request = double(get: {})
              subject = described_class.new(
                key: 'discounts',
                request: request,
                url_base: 'discounts/'
              )

              subject.search(scope: 'minty', type: %w(a b c d)).retrieve

              expect(request).to have_received(:get).with(
                url: 'discounts/',
                query: {
                  discount_scope: 'minty',
                  type: 'a,b,c,d'
                },
                api_token: nil
              )
            end
          end
        end
      end
    end
  end
end
