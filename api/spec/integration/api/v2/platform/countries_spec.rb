require 'swagger_helper'

describe 'Countries API' do
  include_context 'Platform API v2'

  let(:Authorization) { valid_authorization }

  path '/api/v2/platform/countries' do
    get 'Returns a list of Countries' do
      tags 'Countries'
      security [ bearer_auth: [] ]

      response '200', 'countries returned' do
        before { create_list(:country, 2) }

        schema '$ref' => '#/components/schemas/resources_list'
        run_test!
      end

      response '401', 'authentication failed' do
        let(:Authorization) { bogus_authorization }
        run_test!
      end
    end
  end

  path '/api/v2/platform/countries/{id}' do
    let(:id) { create(:country).id }

    get 'Returns a Country' do
      tags 'Countries'
      security [ bearer_auth: [] ]
      parameter name: :id, in: :path, type: :string

      response '200', 'Country found' do
        schema '$ref' => '#/components/schemas/resource'
        run_test!
      end

      response '404', 'Country not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'authentication failed' do
        let(:Authorization) { bogus_authorization }
        run_test!
      end
    end
  end
end
