require 'spec_helper'

module EventbriteSDK
  class Resource
    RSpec.describe ValueChange do
      describe '#key' do
        context 'when prefix is provided' do
          it 'prefixes #key' do
            changeset = described_class.new('key', 'value', prefix: 'prefix')

            expect(changeset.key).to eq('prefix.key')
          end
        end

        context 'when prefix is ommited' do
          it 'does not prefix #key' do
            changeset = described_class.new('key', 'value')

            expect(changeset.key).to eq('key')
          end
        end
      end

      describe '#diff' do
        context 'when key given has a sibling' do
          context 'and the sibling exists in given attrs' do
            it 'does not add the sibling to returned diff' do
              attrs = {
                'exist' => {
                  'timezone' => 'old value'
                }
              }
              existing_changes = {
                'exist.utc' => ['old', 'new']
              }
              changeset = described_class.new('exist.timezone', 'new value')

              diff = changeset.diff(attrs, existing_changes)

              expect(diff).to eq(
                'exist.timezone' => ['old value', 'new value']
              )
            end
          end

          context 'and the sibling does not exist in given attrs' do
            it 'adds the sibling to returned diff' do
              attrs = {
                'exist' => {
                  'utc' => 'old value',
                  'timezone' => 'dupe me'
                }
              }
              existing_changes = {}
              changeset = described_class.new('exist.utc', 'new value')

              diff = changeset.diff(attrs, existing_changes)

              expect(diff).to eq(
                'exist.timezone' => ['dupe me', 'dupe me'],
                'exist.utc' => ['old value', 'new value']
              )
            end
          end
        end

        context 'when key contains dot notation' do
          it 'digs into given attrs returning (old, new) value tuple' do
            attrs = {
              'one' => {
                'two' => 'old value'
              }
            }
            changeset = described_class.new('one.two', 'new value')

            diff = changeset.diff(attrs, {})

            expect(diff).to eq('one.two' => ['old value', 'new value'])
          end
        end
      end
    end
  end
end
