view: annual_dollar_retention_agg {
  sql_table_name: "LEMONADE_DWH"."DATAMART_FINANCE"."AGG_ADR_BY_MONTH" ;;

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
    timeframes: [month, quarter, year]
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

}
