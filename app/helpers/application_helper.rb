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
end
