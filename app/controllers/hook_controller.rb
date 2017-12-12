class HookController < ApplicationController
  def create
    data_json = JSON.parse request.body.read
    token = 'YOUR_TOKEN' # Your API token

    customer = RestClient::Request.execute(method: :get,
                                           url: "https://capi.storyblok.com/v1/customers/#{data_json['id']}",
                                           headers: {
                                             authentication: "Token token=#{token}"
                                           })

    if Customer.find_by_id(customer['id'])
      Customer.update!(customer)
    else
      Customer.create!(customer)
    end
  end
end
