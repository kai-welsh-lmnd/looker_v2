view: annual_dollar_retention {
  sql_table_name: "LEMONADE_DWH"."DATAMART_FINANCE"."MRT_ADR_BY_POLICY" ;;

  dimension: adr_id {
    label: "Adr ID"
    description: "Unique primary key"
    primary_key: yes
    type: string
    sql: ${TABLE}."ADR_INTERNAL_ID" ;;
    hidden: yes
  }

  dimension_group: reporting {
    label: "* Reporting"
    description: "The 'Day 365' of the measurement for the cohort."
    type: time
    timeframes: [month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."REPORTING_DATE" ;;
  }

  dimension_group: starting {
    label: "* Starting"
    description: "The 'Day 0' of the measurement for the cohort."
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."STARTING_DATE" ;;
  }

  dimension: is_finalized_month {
    label: "ADR Finalized?"
    description: "Has the full ADR cohort time period (1 year) passed?"
    type: yesno
    sql: ${TABLE}."IS_FINALIZED_MONTH" ;;
  }

  dimension: user_id {
    group_label: "Attributes"
    label: "User ID"
    description: "User ID of policy"
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: policy_id {
    group_label: "Attributes"
    label: "Policy ID"
    description: "Policy ID"
    type: string
    sql: ${TABLE}."POLICY_ID" ;;
  }

  dimension: country {
    group_label: "Attributes"
    label: "Country"
    description: "Initial country of policy"
    type: string
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: state {
    group_label: "Attributes"
    label: "State"
    description: "Initial state of policy"
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: form {
    group_label: "Attributes"
    label: "Form"
    description: "Form of policy"
    type: string
    sql: ${TABLE}."FORM" ;;
  }

  dimension: company {
    group_label: "Attributes"
    label: "Company"
    description: "Company of policy"
    type: string
    sql: ${TABLE}."COMPANY" ;;
  }

  dimension: adr_component {
    label: "ADR Component Type"
    description: "Cancellation, upsale, downsale, etc."
    type: string
    sql: ${TABLE}."SUB_TYPE" ;;
  }

  dimension: adr_component_sub_type {
    label: "ADR Component Sub-Type"
    description: "Sub-Types of Upsale, downsale, etc."
    type: string
    sql: ${TABLE}."ADDITIONAL_SUB_COMPONENT" ;;
  }

  measure: relevant_diff {
    label: "ADR Component Amount"
    description: "Difference in IFP caused by ADR component type"
    type: sum
    sql: ${TABLE}."RELEVANT_DIFF" ;;
    value_format_name: usd_0
  }

  measure: starting_ifp_total {
    label: "Starting IFP - Total"
    description: "Total starting IFP. Filter to indiviudal date"
    type: sum
    sql: ${TABLE}."IFP_START_AMOUNT" ;;
    value_format_name: usd_0
  }

  measure: ending_ifp_total {
    label: "Ending IFP - Total"
    description: "Total ending IFP. Filter to individual date"
    type: sum
    sql: ${TABLE}."IFP_END_AMOUNT" ;;
    value_format_name: usd_0
  }

  measure: adr {
    label: "Annual Dollar Retention (ADR)"
    type: number
    sql: ${ending_ifp_total} / nullifzero(${starting_ifp_total}) ;;
    value_format_name: percent_2
  }

  measure: total_customers {
    label: "Total Customers"
    description: "Distinct count of user ID."
    type: count_distinct
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: total_cross_sales {
    label: "Total Cross Sales"
    description: "Distinct count of user ID for policies tagged as Cross Sale"
    type: count_distinct
    sql: ${TABLE}."USER_ID" ;;
    filters: [adr_component: "cross_sale"]
  }

}
