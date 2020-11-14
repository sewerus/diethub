class AdminsController < UsersController
  before_action :admin_only
end
