require 'cgi'
require 'json'
require 'net/http'
require 'uri'

class Thesaurus
  API_TOKEN = 'Q3bmRZdQmvvxVP7lpOkJ'
  BASE_URL = "http://thesaurus.altervista.org/thesaurus/v1?key=#{API_TOKEN}&language=en_US&output=json"

  def initialize(word)
    @word = word
    @url = "#{BASE_URL}&word=#{word}"
    @results = []
  end

  def get_synonyms
    raw_response = Net::HTTP.get(URI(@url))
    results = JSON.parse(raw_response)['response'] rescue []

    @results = results.map { |result| result['list'] }

    self
  end

  def to_alfred
    "<?xml version='1.0'?><items>\n%s\n</items>" %
    @results.map do |result|
      formatItem(result['synonyms'], result['category'])
    end.join("\n")
  end

  private

  def formatItem(title, subtitle)
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

puts Thesaurus.new("{query}")
  .get_synonyms
  .to_alfred
