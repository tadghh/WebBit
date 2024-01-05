# frozen_string_literal: true # rubocop:disable Layout/EndOfLine

module ApplicationHelper # rubocop:disable Style/Documentation
  def render_svg(name, options = {})
    options[:title] ||= name.underscore.humanize
    options[:aria] = true
    options[:nocomment] = true
    options[:class] = options.fetch(:styles, 'fill-current text-gray-500')
    filename = "#{name}.svg"
    inline_svg_tag(filename, options)
  end

  def nav
    render 'partials/nav'
  end
end