# frozen_string_literal: true

# To use this you should define a before hook that creates items to list
#   before { create_list(:vehicle, number_of_vehicles, :with_vin) }
# number_of_TYPE will be provided
#
# You also need to define endpoint_call and pass it parameters through
# request_params
#   let(:endpoint_call) { get '/api/business/v1/vehicles', params: request_params }
RSpec.shared_examples 'paginated endpoint' do |type|
  subject do
    request_params.merge! paginate_params
    endpoint_call
    JSON.parse(response.body)['data']
  end

  let(:number_of_items_to_create) { 7 }
  let("number_of_#{type}".to_sym) { number_of_items_to_create }
  let(:paginate_params) { {} }

  describe 'no parameters' do
    it { is_expected.to respond_with :success }
    it { is_expected.to have_at_least(number_of_items_to_create).items }
    it { is_expected.to all(include('type' => type)) } if type
  end

  describe 'limit results' do
    let(:request_params) { paginate_params.merge(per_page: 3) }

    it { is_expected.to have(3).items }
    it { is_expected.to all(include('type' => type)) } if type
  end
end
