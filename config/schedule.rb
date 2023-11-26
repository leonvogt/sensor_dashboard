# Crontab mittels http://github.com/javan/whenever

set :chronic_options, hours24: true

every 1.day, at: "05:00" do
  rake "housekeeping:guest_data"
end
