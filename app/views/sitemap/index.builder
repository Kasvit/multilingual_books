xml.instruct! :xml, version: "1.0"

xml.urlset "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
           "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
           "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 " \
                 "http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" do
  xml.url do
    xml.loc root_url
    xml.lastmod Time.zone.now.strftime("%Y-%m-%dT%H:%M:%S%:z")
    xml.changefreq "daily" # because of it can be changed daily with new books
    xml.priority "1.0"
  end

  Book.find_each do |book|
    xml.url do
      xml.loc book_url(book)
      xml.lastmod book.updated_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
      xml.changefreq "monthly"
      xml.priority "0.8"
    end
  end
end
