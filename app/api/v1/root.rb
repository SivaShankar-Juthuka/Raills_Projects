class Api::V1::Root < Grape::API
    helpers AuthHelper
    helpers PaginationHelper
    helpers UserHelpers

    mount Api::V1::Tasks
    mount Api::V1::Users
    mount Api::V1::UserTasks
end