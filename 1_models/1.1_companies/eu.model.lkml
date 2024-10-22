connection: "snowflake"

include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# Select the views that should be a part of this model,
# and define the joins that connect them together.

explore: policies_ext {
  always_filter: {
    filters: [policies_ext.company: "eu"]
  }
}