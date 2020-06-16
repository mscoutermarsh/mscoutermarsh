# fetch("https://api-7.whoop.com/users/84081/cycles?end=2020-06-16T06:59:59.999Z&start=2020-06-14T07:00:00.000Z", {
#   "headers": {
#     "accept": "application/json, text/plain, */*",
#     "accept-language": "en-US,en;q=0.9",
#     "authorization": "bearer +lJJsLMSMYV9w8fm7G4n/p2v2MT2zZvvD2honMNI3qjnrRU532lpWxFuk4STY5sC",
#     "cache-control": "no-cache",
#     "pragma": "no-cache",
#     "sec-fetch-dest": "empty",
#     "sec-fetch-mode": "cors",
#     "sec-fetch-site": "same-site"
#   },
#   "referrer": "https://app.whoop.com/athlete/84081/1d/today",
#   "referrerPolicy": "no-referrer-when-downgrade",
#   "body": null,
#   "method": "GET",
#   "mode": "cors"
# });

require "httparty"
require "pry"

require 'markdown-tables'

module Whoop
  def self.get_duration_hrs_and_mins(duration)
    hours = duration / (1000 * 60 * 60)
    minutes = duration / (1000 * 60) % 60
    "#{hours}h #{minutes}m"
  rescue
    ""
  end

  def self.stats
    now =  (DateTime.now).iso8601.gsub("+00:00", "Z")
    week_ago = (DateTime.now - 6).iso8601.gsub("+00:00", "Z")
    puts now
    puts week_ago

    response = HTTParty.get("https://api-7.whoop.com/users/84081/cycles?end=#{now}&start=#{week_ago}",{
      headers: {"authorization" => "bearer #{ENV["WHOOP_KEY"]}" }
    })

    labels = ["Day", "Hours of sleep", "Resting heart rate"]

    data = []

    response.each do |day|
      if day["sleep"]
        sleep = day["sleep"]["sleeps"].sum { |s| s["qualityDuration"] }
        sleep = get_duration_hrs_and_mins(sleep)
        data << [day["days"].first, sleep, day["recovery"]["restingHeartRate"]]
      end
    end

    MarkdownTables.make_table(labels, data, is_rows: true)
  rescue
    return ""
  end
end
