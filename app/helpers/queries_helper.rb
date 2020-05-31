module QueriesHelper
  def get_user(query)
    @user = User.find(query.user_id)
  end

  def get_row_label(row)
    field = row.keys.detect { |k| k =~ /Label/i }
    if row[field]
      row[field]['value'].to_s
    else
      ''
    end
  end
end
