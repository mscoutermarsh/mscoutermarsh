require_relative "html_css_to_image.rb"

module TweetToImage
  def self.url(tweet_id)
    html = "<div style='display: inline-block'>
  <div class=\"tweet\" id='#{tweet_id}'></div>
</div>
<script src='https://code.jquery.com/jquery-3.4.0.slim.min.js'
  integrity='sha256-ZaXnYkHGqIhqTbJ6MB4l9Frs/r7U4jlx7ir8PJYBqbI='
  crossorigin=\"anonymous\"></script>
<script src=\"http://platform.twitter.com/widgets.js\"></script>
<script>
  var tweets = $(\".tweet\");
  $(tweets).each( function( t, tweet ) {
    var id = $(this).attr('id');
    twttr.widgets.createTweet(
      id, tweet,
      {
        conversation : 'none',
        cards        : 'hidden',
        linkColor    : '#cc0000',
        theme        : 'light'
      });
    });
</script>"

    HtmlCssToImage.url(html: html, css: "stuff", google_fonts: "Roboto")
  end
end
