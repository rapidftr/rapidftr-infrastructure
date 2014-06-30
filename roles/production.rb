name "production"

run_list(
  "recipe[core]",
  "recipe[ruby]",
  "recipe[couchdb]",
  "recipe[passenger]",
  "recipe[rapidftr]"
)

override_attributes(
    "rapidftr" => {
        "repository" => "git://github.com/rdsubhas/RapidFTR.git",
        "revision"   => "rails_4_upgrade"
    }
)
