shared_context 'Platform API v2' do
  let(:admin_app) { Doorkeeper::Application.find_or_create_by!(name: 'Admin Panel', scopes: 'admin write read', redirect_uri: '') }
  let(:oauth_token) do
    Doorkeeper::AccessToken.create!(
      application_id: admin_app.id,
      scopes: admin_app.scopes
    )
  end

  let(:valid_authorization) { "Bearer #{oauth_token.token}" }
  let(:bogus_authorization) { "Bearer #{::Base64.strict_encode64('bogus:bogus')}" }
end
