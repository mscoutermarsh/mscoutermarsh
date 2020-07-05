require "httparty"

module HtmlCssToImage
  AUTH = { username: ENV["HCTI_API_USER_ID"],
           password: ENV["HCTI_API_KEY"] }.freeze

  def self.url(html:, css: nil, google_fonts: nil, ms_delay: nil, selector: nil, viewport_height: nil, viewport_width: nil)
    image = HTTParty.post("https://hcti.io/v1/image",
                          body: { html: html, css: css, google_fonts: google_fonts, ms_delay: ms_delay, selector: selector },
                          basic_auth: AUTH)

    url = image["url"]

    HTTParty.get(url)

    url
  end
end
