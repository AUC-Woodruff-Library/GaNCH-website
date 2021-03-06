module ApplicationHelper

  def nav_link(text,path)
    if current_page?(path)
      content_tag :li, class: "nav-items active" do
        link_to(path, class: "nav-link") do
          sanitize(text) + content_tag(:span, "(current)", class: "sr-only")
        end
      end
    else
      content_tag :li, class: "nav-items" do
        link_to(text, path, class: "nav-link")
      end
    end
  end

  # open link in new tab
  def external_link(label, url = nil, options = {})
    link_url = url || label
    options[:target] = '_new' unless options[:target]
    return link_to(label, link_url, options)
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  def title(name, show_title = true)
    @show_title = show_title
    if @show_title
      content_for(:title) do
        name
      end
    end
  end

  def to_kebab_case(str)
    return str.downcase.gsub(/\s+/, '-')
  end
end
