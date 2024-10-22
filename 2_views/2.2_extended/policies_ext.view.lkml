include: "/2_views/2.1_base/policies.view.lkml"
view: policies_ext {
  extends: [policies]
###### DATES

  dimension_group: canceled_created_at {
    label: "Canceled Created At "
    group_label: "* Dates"
    description: "When the policy cancelation was created"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."POLICY_CANCELED_CREATIVE_AT" ;;
  }

  dimension_group: updated_at {
    label: "Updated At "
    group_label: "* Dates"
    description: "Last time changes were made to the policy"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension_group: quote_created_at {
    label: "Quote Created At "
    group_label: "* Dates"
    description: "When the original quote was created at "
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."ORIGINAL_QUOTE_CREATED_AT" ;;
  }

###### GEO

  dimension: city {
    label: "City"
    group_label: "Geo"
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: zip {
    label: "ZIP Code"
    group_label: "Geo"
    type: string
    sql: ${TABLE}."POSTAL_CODE" ;;
  }

###### ATTRIBUTES

  dimension: line_of_business {
    label: "Line of Business"
    group_label: "Attributes"
    description: "car, ho, life, pet"
    type: string
    sql: ${TABLE}."LINE_OF_BUSINESS" ;;
  }

  dimension: version {
    label: "Version"
    group_label: "Attributes"
    description: "Policy Version"
    type: string
    sql: ${TABLE}."VERSION" ;;
  }
  dimension: form {
    label: "Form"
    group_label: "Attributes"
    description: "car, car_ppm, car_ppm_mm, ho3, ho4, ho6, homeowners, landlords, life10, life20, life25, life30, life35, life40, pet"
    type: string
    sql: ${TABLE}."FORM" ;;
  }

  dimension: carrier {
    label: "Carrier"
    group_label: "Attributes"
    type: string
    sql: ${TABLE}."CARRIER_NAME" ;;
  }

  dimension: is_lemonade_carrier {
    label: "Is Lemonade Carrier?"
    group_label: "Attributes"
    type: yesno
    sql: ${TABLE}."IS_LEMONADE_CARRIER" ;;
  }

  dimension: agency_model {
    label: "Agency Model"
    group_label: "Attributes"
    description: "lemonade, homesite, life, lng"
    type: string
    sql: ${TABLE}."AGENCY_MODEL" ;;
  }

  dimension: agent_first_name {
    label: "Agent - First Name"
    group_label: "Attributes"
    type: string
    sql: ${TABLE}."AGENT_FIRST_NAME" ;;
  }

  dimension: agent_last_name {
    label: "Agent - Last Name"
    group_label: "Attributes"
    type: string
    sql: ${TABLE}."AGENT_LAST_NAME" ;;
  }

  dimension: partner_name {
    label: "Partner"
    group_label: "Attributes"
    type: string
    sql: ${TABLE}."Partner Name" ;;
  }

  dimension: renewal_term {
    label: "Renewal Term"
    group_label: "Attributes"
    type: number
    sql: ${TABLE}."POLICY_STATUS" ;;
  }

###### QUOTE MEASURES

  measure: quote_premium {
    label: "Total Quote Premium"
    group_label: "Premium"
    description: "Sum of original quote premium"
    type: sum
    sql: ${TABLE}."ORIGINAL_QUOTE_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }

  measure: avg_quote_premium {
    label: "Average Quote Premium"
    group_label: "Premium"
    description: "Average of original quote premium"
    type: average
    sql: ${TABLE}."ORIGINAL_QUOTE_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }

  measure: quote_annual_premium {
    label: "Total Annual Quote Premium"
    group_label: "Premium"
    description: "Sum of original annual quote premium"
    type: sum
    sql: ${TABLE}."ORIGINAL_QUOTE_ANNUAL_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }

  measure: avg_quote_annual_premium {
    label: "Average Annual Quote Premium"
    group_label: "Premium"
    description: "Average of original annual quote premium"
    type: average
    sql: ${TABLE}."ORIGINAL_QUOTE_ANNUAL_PREMIUM_IN_USD" ;;
    value_format_name: usd_0
  }

  measure: quote_base_deductible {
    label: "Total Quote Base Deductible"
    group_label: "Premium"
    description: "Sum of original quote base deductible"
    type: sum
    sql: ${TABLE}."ORIGINAL_QUOTE_BASE_DEDUCTIBLE_USD" ;;
    value_format_name: usd_0
  }

  measure: avg_quote_base_deductible {
    label: "Average Quote Base Deductible"
    group_label: "Premium"
    description: "Average of original quote base deductible"
    type: average
    sql: ${TABLE}."ORIGINAL_QUOTE_BASE_DEDUCTIBLE_USD" ;;
    value_format_name: usd_0
  }

}
