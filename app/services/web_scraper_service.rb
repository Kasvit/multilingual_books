class WebScraperService
  PARSER_MAPPING = {
    /xn--80ac9aeh6f\.xn--p1ai/ => Parsers::RanoberfParser,
    /tl\.rulate\.ru/ => Parsers::TirulateParser
  }.freeze

  def initialize(url)
    @url = url
    @parser = select_parser(url)
  end

  def fetch_and_parse
    @parser.fetch_and_parse(@url)
  end

  private

  def select_parser(url)
    parser_class = PARSER_MAPPING.find { |domain, _| url.match?(domain) }&.last
    (parser_class || Parsers::BaseParser).new
  end
end
