class WebScraperService
  PARSER_MAPPING = {
    /xn--80ac9aeh6f\.xn--p1ai/ => '.overflow-hidden.text-base.leading-5',
    /tl\.rulate\.ru/ => 'div.content-text'
  }.freeze

  def initialize(url)
    @url = url
    @selector = select_selector(url)
  end

  def fetch_and_parse
    html = URI.open(@url)
    raw_content = html.read

    detected_encoding = CharlockHolmes::EncodingDetector.detect(raw_content)
    content = raw_content.force_encoding(detected_encoding[:encoding])

    doc = Nokogiri::HTML(content)
    doc = decode_text(doc)

    extract_content(doc)
  rescue StandardError => e
    raise "Parsing error: #{e.message}"
  end

  private

  def select_selector(url)
    PARSER_MAPPING.find { |domain, _| url.match?(domain) }&.last
  end

  def extract_content(doc)
    content = doc.at(@selector) || doc.at('body')
    raise 'Content not found' if content.nil? || content.inner_html.blank?

    decode_html_entities(content.inner_html)
  end

  def decode_html_entities(content)
    encoder = HTMLEntities.new
    encoder.decode(content)
  end

  def decode_text(doc)
    doc.encoding = 'UTF-8'
    text = doc.to_s
    charlock = CharlockHolmes::EncodingDetector.detect(text)
    if charlock[:encoding] && charlock[:encoding] != 'UTF-8'
      doc.encoding = charlock[:encoding]
      doc = Nokogiri::HTML(doc.to_s.encode('UTF-8', charlock[:encoding]))
    end
    doc
  end
end
