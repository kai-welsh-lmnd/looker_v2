view: policies {
  sql_table_name: LEMONADE_DWH.CORE.MRT_POLICY_PREMIUMS ;;
  view_label: "Policies"

###### IDs

  dimension: policy_id {
    primary_key: yes
    group_label: "IDs"
    type: string
    sql: ${TABLE}."POLICY_ID" ;;
  }

  dimension: combined_user_id {
    label: "User ID - Combined"
    group_label: "IDs"
    description: "Combined User ID - Always LMND user ID if MM/other user migrated or had an identifiable LMND account"
    type: string
    sql: ${TABLE}."COMBINED_USER_ID" ;;
  }

  dimension: user_id {
    label: "User ID"
    group_label: "IDs"
    description: "User ID - overwritten by LMND user ID in combined user ID if applicable"
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: quote_id {
    label: "Quote ID - Current"
    group_label: "IDs"
    type: string
    sql: ${TABLE}."CURRENT_QUOTE_ID" ;;
  }

  dimension: original_quote_id {
    label: "Quote ID - Original"
    group_label: "IDs"
    type: string
    sql: ${TABLE}."ORIGINAL_QUOTE_ID" ;;
  }

  dimension: partner_id {
    label: "Partner ID"
    group_label: "IDs"
    type: string
    sql: ${TABLE}."PARTNER_ID" ;;
  }

  dimension: agent_id {
    label: "Agent ID"
    group_label: "IDs"
    type: string
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: last_cart_id {
    label: "Last Cart ID"
    group_label: "IDs"
    type: string
    sql: ${TABLE}."ORIGINAL_LAST_CART_ID" ;;
  }

###### GEO

  dimension: country {
    label: "Country"
    group_label: "Geo"
    type: string
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: state {
    label: "State"
    group_label: "Geo"
    type: string
    sql: ${TABLE}."STATE" ;;
  }

###### DATES

  dimension_group: effective_at {
    label: "Effective At "
    group_label: "* Dates"
    description: "When the policy went into effect"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."POLICY_EFFECTIVE_AT" ;;
  }

  dimension_group: effective_until {
    label: "Effective Until "
    group_label: "* Dates"
    description: "Ending date of policy"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."POLICY_EFFECTIVE_AT" ;;
  }

  dimension_group: canceled_effective_at {
    label: "Canceled Effective At "
    group_label: "* Dates"
    description: "When the policy cancelation went into effect"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."POLICY_CANCELED_EFFECTIVE_AT" ;;
  }

  dimension_group: renewal_at {
    label: "Renewal At "
    group_label: "* Dates"
    description: "The time the policy was renewed"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."POLICY_RENEWAL_AT" ;;
  }

  dimension_group: created_at {
    label: "Created At "
    group_label: "* Dates"
    description: "The time the policy was created (can be ahead or behind of effective date)"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."POLICY_CREATED_AT" ;;
  }



###### ATTRIBUTES

  dimension: status {
    label: "Status"
    group_label: "Attributes"
    description: "active, canceled, canceled_renewal, claimed, deleted, dunning, error, expired, future, migrated, other, pending, pre_binding, renewal, renewed"
    type: string
    sql: ${TABLE}."POLICY_STATUS" ;;
  }

  dimension: humanized_form {
    label: "Humanized Form"
    group_label: "Attributes"
    description: "car_fixed, car_pay_per_mile, condo, homeowners, landlords, life, pet, renters"
    type: string
    sql: ${TABLE}."HUMANIZED_FORM" ;;
  }

  dimension: company {
    label: "Company"
    group_label: "Attributes"
    description: "car, eu, home, life, pet, renters"
    type: string
    sql: ${TABLE}."COMPANY" ;;
  }

  dimension: is_same_day_cancel {
    label: "Is Same Day Cancel?"
    group_label: "Attributes"
    type: yesno
    sql: ${TABLE}."IS_LEMONADE_CARRIER" ;;
  }

###### PREMIUM MEASURES

  measure: current_premium {
    label: "Total Current Premium"
    group_label: "Premium"
    description: "Sum of current premium"
    type: sum
    sql: ${TABLE}."CURRENT_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }

  measure: avg_current_premium {
    label: "Average Current Premium"
    group_label: "Premium"
    description: "Average of current premium"
    type: average
    sql: ${TABLE}."CURRENT_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }

  measure: current_annual_premium {
    label: "Total Current Annual Premium"
    group_label: "Premium"
    description: "Sum of annual premium"
    type: sum
    sql: ${TABLE}."CURRENT_ANNUAL_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }

  measure: avg_current_annual_premium {
    label: "Average Current Annual Premium"
    group_label: "Premium"
    description: "Average of annual premium"
    type: average
    sql: ${TABLE}."CURRENT_ANNUAL_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }
}
