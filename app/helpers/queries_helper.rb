require 'erb'
module QueriesHelper
  def get_user(query)
    @user = User.find(query.user_id)
  end

  # display label for a map pin
  def get_marker_pin_label(row)
    field = row.keys.detect { |k| k =~ /Label/i }
    if row[field]
      row[field]['value'].to_s
    else
      ''
    end
  end

  # wikidata link for a map pin
  def get_marker_pin_url(row)
    field = row.keys.detect { |k| k =~ /library/i }
    if row[field]
      row[field]['value'].to_s
    else
      ''
    end
  end

  def render_pin(row)
    label = get_marker_pin_label(row)
    url = get_marker_pin_url(row)
    template = tag.span do |span|
      label
    end
    template += tag.br
    template += link_to(url, url, { target: '_new' })
    template
  end

  #
  # If the query is configured with a pair of fields in a pattern like
  # {name}, {nameLabel}, this will take add a link to the name object
  # using the label as the link text. It will also remove nameLabel from
  # the head array
  #
  def merge_first_and_label(head = [], body = [])
    # get index of label element
    labelField = head.detect { |k| k =~ /Label/i }
    labelIndex = head.find_index(labelField)
    # delete that element from both arrays
    head.delete_at labelIndex

    # get key of field the label refers to
    position = labelField =~ /Label/i
    ref = labelField.slice(0, position)
    # transform each body row[0] into linked label
    body.each do |row|
      targetKey = row.keys.detect { |f| f == ref }
      if targetKey
        # turn exstinging data (url) into link and append to hash
        link = link_to(row[labelField]['value'], row[targetKey]['value'], { target: '_new' })
        row[targetKey]["as_link"] = link
      end
    end
    [head, body]
  end

  def url_encode_query(str)
    ERB::Util.url_encode(str)
  end
end
