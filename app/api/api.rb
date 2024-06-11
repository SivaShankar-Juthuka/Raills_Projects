# app/api/api.rb
class Api < Grape::API
    format :json
    mount Api::V1::Root
end