connection: "snowflake"

#include ALL views TOGGLE
#include: "/****/***/**/*.view.lkml"

#include specific views (preferred)
include: "/****/finance_views/**/*.view.lkml"
include: "/2_views/user_views/**/*.view.lkml"
include: "/datagroups.lkml"

###### ADR ######

# explore: annual_dollar_retention_agg {
#   label: "ADR - Topline"
#   group_label: "Finance - ADR"
# }

# explore: annual_dollar_retention {
#   label: "ADR"
#   group_label: "Finance - ADR"
# }

# explore: annual_dollar_retention_cross_sales {
#   label: "ADR - Cross Sales"
#   group_label: "Finance - ADR"
# }

# ###### IFP ######

# explore: finance_daily_events {
#   group_label: "Finance - IFP"
#   label: "Finance Daily Events"
#   view_label: "* Finance Daily Events"
#   join: new_user_date {
#     view_label: "* Finance Daily Events"
#     relationship: one_to_one
#     sql_on: ${policies_user_status_changes_sf.encrypted_id} = ${new_user_date.encrypted_id} ;;
#     fields: [new_user_date.initial_lob,new_user_date.initial_form_grouped,new_user_date.initial_form,new_user_date.new_user_date,new_user_date.new_user_month]
#   }
# }

# explore: finance_daily_events_agg {
#   label: "Finance Daily Events - Aggregated w/ Corrections"
#   group_label: "Finance - IFP"
# }dfgdfg
