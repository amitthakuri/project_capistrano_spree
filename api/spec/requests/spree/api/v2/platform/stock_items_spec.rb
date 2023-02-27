require 'spec_helper'

describe 'Platform API v2 Stock Items API' do
  include_context 'Platform API v2'

  let(:bearer_token) { { 'Authorization' => valid_authorization } }

  let(:product_1) { create(:product, stores: [store]) }
  let(:product_2) { create(:product, stores: [store]) }
  let!(:stock_location_1) { create(:stock_location) }
  let!(:stock_location_2) { create(:stock_location) }

  describe 'stock_items#index' do
    let!(:variants) { create_list(:variant, 2, product: product_1) }
    let!(:variants) { create_list(:variant, 2, product: product_2) }

    context 'filtering by stock location id' do
      before { get "/api/v2/platform/stock_items?filter[stock_location_id_eq]=#{stock_location_1.id}", headers: bearer_token }

      it 'returns stock_items with matching stock location ids' do
        expect(json_response['data'].count).to eq 3
        expect(json_response['data'].first).to have_type('stock_item')
      end
    end

    context 'filtering by variant product name or sku' do
      before { get "/api/v2/platform/stock_items?filter[variant_product_name_or_variant_sku_cont]=#{product_2.name}", headers: bearer_token }

      it 'returns stock_items with matching stock location ids' do
        expect(json_response['data'].count).to eq 2
        expect(json_response['data'].first).to have_type('stock_item')
      end
    end
  end
end

