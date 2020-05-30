module QueriesHelper
  def get_user(query)
    @user = User.find(query.user_id)
  end
end
