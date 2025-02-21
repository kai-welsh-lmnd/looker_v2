connection: "snowflake"

include: "/**/*.view.lkml" # include all views in this project
include: "/datagroups.lkml" # able to reference caching strategies for PDTs

# Select the views that should be a part of this model,
# and define the joins that connect them together.

explore: policies_ext {
  hidden: yes
  always_filter: {
    filters: [policies_ext.company: "pet"]
  }
}
