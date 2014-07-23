name "development"

run_list(
  "recipe[core]",
  "recipe[couchdb]",
  "recipe[xvfb]",
  "recipe[firefox]",
  "recipe[phantomjs]",
  "recipe[rvm]",
  "recipe[seed]"
)

override_attributes(
  "couch_db" => {
    "config" => {
      "httpd" => {
        "bind_address" => "0.0.0.0"
      },
      "admins" => {
        "rapidftr" => "rapidftr"
      }
    }
  }
)
