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
      customer_in_your_db = Customer.update!(customer)
    else
      customer_in_your_db = Customer.create!(customer)
    end

    # 4 Enrich the customer data with the EUID which is the ID of your system
    RestClient::Request.execute(method: :post,
                                url: "https://capi.storyblok.com/v1/customers/#{data_json['id']}",
                                headers: {
                                  authentication: "Token token=#{token}"
                                },
                                payload: {euid: customer_in_your_db.id})
  end
end
