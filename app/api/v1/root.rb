class Api::V1::Root < Grape::API
    helpers AuthHelper
    helpers PaginationHelper

    mount Api::V1::Tasks
    mount Api::V1::Users
    mount Api::V1::UserTasks
end