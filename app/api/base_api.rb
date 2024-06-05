# app/api/base_api.rb
module BaseAPI
  class API < Grape::API
    format :json

    # Mount your versioned APIs here
    mount V1::Tasks
  end
end
  