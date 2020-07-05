require_relative "html_css_to_image.rb"

module TweetToImage
  def self.url(tweet_id)
    html = "<blockquote class='twitter-tweet' style='width: 400px;' data-dnt='true'>
<p lang='en' dir='ltr'></p>

<a href='https://twitter.com/fortnitegame/status/#{tweet_id}'></a>

</blockquote> <script async src='https://platform.twitter.com/widgets.js' charset='utf-8'></script>"

    HtmlCssToImage.url(html: html, ms_delay: 1500, selector: ".twitter-tweet")
  end
end
