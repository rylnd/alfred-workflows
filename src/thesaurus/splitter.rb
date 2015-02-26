require 'cgi'

class ResultSplitter
  def initialize(result)
    @results = result.split(', ')
  end

  def to_alfred
    "<?xml version='1.0'?><items>\n%s\n</items>" %
    @results.map do |result|
      formatItem(result)
    end.join("\n")
  end

  private

  def formatItem(title, subtitle='')
    title = escape(title)
    subtitle = escape(subtitle)

    """
    <item uid='#{title}' arg='#{title}' valid='yes' autocomplete='#{title}'>
      <title>#{title}</title>
      <subtitle>#{subtitle}</subtitle>
      <icon>icon.png</icon>
    </item>
    """
  end

  def escape(string)
    CGI.escapeHTML(string)
  end
end

puts ResultSplitter.new("{query}").to_alfred
