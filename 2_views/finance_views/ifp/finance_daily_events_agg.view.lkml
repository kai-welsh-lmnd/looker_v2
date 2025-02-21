view: finance_daily_events_agg {
  sql_table_name: "LEMONADE_DWH"."FINANCE"."AGG_IFP_CORRECTED"
    ;;

##### Base Dimensions ####
  dimension: primary_key {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${accounting_month}||${carrier}||${country}||${form} ;;
  }

  dimension: annualized_premium {
    group_label: "Policy Level Attributes"
    label: "In-Force Annual Premium ($USD)"
    description: "The total in-force written & placed premium for the policy"
    type: number
    sql: ${TABLE}."ANNUALIZED_PREMIUM_USD" ;;
  }

  dimension: annualized_premium_written {
    group_label: "Policy Level Attributes"
    label: "In-Force Annual Premium ($USD) - Written"
    description: "The total in-force *written* premium for the policy"
    type: number
    sql: ${TABLE}."ANNUALIZED_WRITTEN_PREMIUM_USD" ;;
  }

  dimension: annualized_premium_placed {
    group_label: "Policy Level Attributes"
    label: "In-Force Annual Premium ($USD) - Placed"
    description: "The total in-force *placed* premium for the policy"
    type: number
    sql: ${TABLE}."ANNUALIZED_PLACED_PREMIUM_USD" ;;
  }

  dimension: active_user_count_dim {
    group_label: "Policy Level Attributes"
    label: "Active User Count"
    description: "The distinct count of users"
    type: number
    sql: ${TABLE}."ACTIVE_USER_COUNT" ;;
  }

  dimension: active_policy_count_dim {
    group_label: "Policy Level Attributes"
    label: "Active Policy Count"
    description: "The distinct count of users"
    type: number
    sql: ${TABLE}."ACTIVE_POLICY_COUNT" ;;
  }

  dimension: carrier {
    hidden: no
    group_label: "Policy Level Attributes"
    label: "Carrier"
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  dimension: country {
    hidden: no
    group_label: "Policy Level Attributes"
    label: "Country"
    type: string
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: form {
    hidden: no
    group_label: "Policy Level Attributes"
    label: "Form"
    type: string
    sql: ${TABLE}."FORM" ;;
  }

##### Date & Date Manipulations #####

  dimension_group: accounting {
    label: "* * Accounting"
    type: time
    timeframes: [
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."ACCOUNTING_DATE" ;;
  }

  ##### Aggregations / Measures #####

  measure: active_user_count {
    label: "Active Customer Count"
    group_label: "Daily Metric Measures"
    description: "Counts Number of Unique User IDs that have policies that have a status of 'active'"
    type: sum
    sql: ${active_user_count_dim} ;;
    drill_fields: []
  }

  measure: active_policy_count {
    label: "Active Policy Count"
    group_label: "Daily Metric Measures"
    description: "Counts Number of Unique Policy IDs that have a status of 'active'"
    type: sum
    sql: ${active_policy_count_dim} ;;
    drill_fields: []
  }

  measure: arr {
    label: "In-Force Premium ($USD)"
    group_label: "Daily Metric Measures"
    description: "Sums the annual premium of policies that have a status of 'active', at a daily level. Includes both Written and Placed premium"
    type: sum
    sql: ${annualized_premium} ;;
    drill_fields: []
    value_format_name: usd_0
  }

  measure: total_written_ifp {
    label: "In-Force Premium ($USD) - Written"
    group_label: "Daily Metric Measures"
    description: "The total amount of Written Premium across all active policies on a daily level."
    type: sum
    sql: ${annualized_premium_written} ;;
    drill_fields: []
    value_format_name: usd_0
  }

  measure: total_placed_ifp {
    label: "In-Force Premium ($USD) - Placed"
    group_label: "Daily Metric Measures"
    description: "The total amount of Placed Premium (e.g., Life, FR Assistance) across all active policies on a daily level."
    type: sum
    sql: ${annualized_premium_placed} ;;
    drill_fields: []
    value_format_name: usd_0
  }

  measure: apv {
    label: "Average Premium per Customer (Premium-per-Customer - $USD)"
    group_label: "Daily Metric Measures"
    description: "Reflects the Average Value of Annual Premiums that have a status of 'active'."
    type: number
    sql: ${arr}/nullifzero(${active_user_count}) ;;
    drill_fields: []
    value_format_name: usd
  }

}
