view: new_user_date {
  derived_table: {
    sql: SELECT *
        FROM public.new_user_date
        ;;
    datagroup_trigger: daily_caching_3_utc
  }

  dimension: encrypted_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}."ENCRYPTED_ID" ;;
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension_group: new_user {
    label: "* New Customer"
    ## This date is used in the calculation of churn duration, i.e. for each New User, what is the starting date of the clock between when they were a New User
    ## the date they ultimately churned.
    description: "Use for Churn Calculations for total churn triangles. Based on policy created date"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      month_name
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."NEW_USER_DATE" ;;
  }

  dimension_group: new_user_within_lob {
    ## This date is used in the calculation of churn duration, i.e. for each New User, what is the starting date of the clock between when they were a New User
    ## the date they ultimately churned.
    label: "* New Customer within LOB"
    description: "Use for Churn Calculations for within LOB triangles."
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."NEW_USER_WITHIN_LOB_DATE" ;;
  }

  dimension: is_after_multipet_launch {
    hidden: yes
    group_label: "Analytical Measures"
    label: "Customer first engagement after Multi-pet discount launch"
    description: "Does the customer first engagement with pet accure after Multi pet discount launched (May 15th 2021)"
    type: yesno
    sql: ${new_user_within_lob_date}>='2021-05-15' ;; #This is the date we launch Multi Pet
  }

  dimension: is_og_line_of_business {
    # MS: we now have initial LOB dimensions. use custom filters for LOB = intitial LOB
    hidden: yes
    label: "Policy Is Initial LOB"
    description: "For each policy, this identifies whether the associated LOB matches the user's first Lemonade LOB. For example, for LOB=Pet, this returns True
    when the Customer's first Lemonade policy was Pet. Use when filtering/segmenting by LOB (esp. Churn by LOB)."
    type: yesno
    sql: ${new_user_date} = ${new_user_within_lob_date} ;;
  }

  dimension: user_age_at_new_user_date_tier {
    hidden: yes
    group_label: "New Customer Dimensions"
    label: "User Age - Tier"
    description: "How old was the user (in years) when they became a new user? [tiers]"
    type: tier
    style: integer
    sql: FLOOR(DATEDIFF(day,${users_sf.date_of_birth_for_calculations_raw},${new_user_date})/365) ;;
    tiers: [23,30,40,50]
  }

  dimension: initial_lob {
    group_label: "New Customer Dimensions"
    label: "Initial LOB"
    description: "What was the LOB first purchased when the customer became a new user?"
    type: string
    sql: ${TABLE}."INITIAL_LOB" ;;
  }

  dimension: initial_form {
    group_label: "New Customer Dimensions"
    label: "Initial Form"
    description: "What was the form first purchased when the customer became a new user?"
    type: string
    sql: ${TABLE}."INITIAL_FORM" ;;
  }

  dimension: initial_form_grouped {
    group_label: "New Customer Dimensions"
    label: "Initial Form (Grouped)"
    description: "What was the form first purchased when the customer became a new user?. Values: life, car, car_ppm, car_ppm_mm, ho3, ho4, ho6, pet"
    type: string
    sql: CASE WHEN ${initial_form} ILIKE 'life%' THEN 'life' ELSE ${initial_form} END;;
  }

  dimension: initial_product {
    hidden: yes
    group_label: "New Customer Dimensions"
    description: "Initial Form grouped into: bundle, car, home, renters, pet, life. Filter by country to split out EU"
    type: string
    sql: CASE
      WHEN ${initial_form_grouped} ILIKE '%car%' THEN 'car'
      WHEN ${initial_form_grouped} IN ('ho3', 'ho6', 'landlords', 'homeowners') THEN 'home'
      WHEN ${initial_form_grouped} = 'ho4' THEN 'renters'
      ELSE ${initial_form_grouped}
      END;;
  }

  dimension: car_states_boolean {
    label: "Live Car State"
    group_label: "New Customer Dimensions"
    description: "Identifies customers who became new customers in live car states vs. non-car. This adjusts for historical data as well (i.e. TX new customers before December 2022 will be tagged as 'Non-Car'."
    type: string
    sql:
         CASE WHEN  (${user_facts.initial_state_of_user_id} = 'TX' AND ${new_user_date} > '2022-12-05') THEN 'TX'
              WHEN  (${user_facts.initial_state_of_user_id} = 'IL' AND ${new_user_date} > '2021-11-06') = 1 OR
                    (${user_facts.initial_state_of_user_id} = 'TN' AND ${new_user_date} > '2022-02-11') = 1 OR
                    (${user_facts.initial_state_of_user_id} = 'OH' AND ${new_user_date} > '2022-07-01') = 1 THEN 'IL, TN, OH'
              ELSE 'Non-Car'
              END
            ;;
  }

  dimension: user_before_pet_launch {
    hidden: yes #MS: hidden because used for one-off analysis
    group_label: "Analytical Dimensions"
    description: "Was the user active before our pet launch? i.e., is the new user date before Jul 13,2020"
    type: yesno
    sql: ${new_user_date} < '2020-07-13' ;;
  }

  dimension: days_from_new_user_to_sale {
    hidden: yes #MS: hidden because used for one-off analysis
    group_label: "Analytical Dimensions"
    description: "How many days after the new user date did a sale happen?"
    type: number
    sql: DATEDIFF(days,${new_user_date},${sales_facts_sf.sales_facts_accounting_date_date}) ;;
  }

  dimension: tenure {
    hidden: yes
    group_label: "Analytical Dimensions"
    description: "How many years have passed since the new user date to the customer churn date or current date?"
    type: number
    sql: DATEDIFF(days,${new_user_date},COALESCE(${policies_user_status_changes_sf.churned_date},current_date()))/365 ;;
  }

  measure: tenure_average {
    label: "Average Tenure (Years)"
    description: "How many years have passed since the new user date to the customer churn date or current date?"
    type: average
    sql: ${tenure} ;;
    value_format_name: decimal_1
  }

  dimension: churned_within_lob_timeframes {
    hidden: yes
    ## MS: hidden while still in progress
    type: string
    sql:CASE
         WHEN ${policies_user_status_changes_sf.churned_within_lob_date} IS NULL THEN 'Total'
         ELSE
          CASE
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=30 then 'Before Effective Date'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=60 then 'Month 01'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=90 then 'Month 02'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=120 then 'Month 03'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=150 then 'Month 04'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=180 then 'Month 05'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=210 then 'Month 06'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=240 then 'Month 07'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=270 then 'Month 08'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=300 then 'Month 09'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=330 then 'Month 10'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=360 then 'Month 11'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=395 then 'Month 12'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=425 then 'Month 13'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=455 then 'Month 14'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=485 then 'Month 15'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=515 then 'Month 16'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=545 then 'Month 17'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=575 then 'Month 18'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=605 then 'Month 19'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=635 then 'Month 20'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=665 then 'Month 21'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=695 then 'Month 22'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=725 then 'Month 23'
            WHEN datediff(day,${new_user_within_lob_raw},${policies_user_status_changes_sf.churned_within_lob_raw})<=760 then 'Month 24'
            ELSE 'Month 25 +'
          END
      END;;
  }

  dimension: inactive_policy_not_churned {
    hidden: yes
    type: yesno
    ## MS: want to exclude policies that canceled/expired over 30 days ago but didn't churn
    sql: (${policies_user_status_changes_sf.churned_user_within_lob} = 0
         AND
         datediff(minutes,COALESCE(${policies_master.canceled_raw},${policies_master.renewal_raw}),current_date()) >= 43200)
        ;;
  }

  dimension: days_active_new_user {
    # hidden: yes
    label: "New User Days Active"
    group_label: "Analytical Dimensions"
    description: "Number of days active as a Lemonade customer."
    type: number
    sql: ${TABLE}."DAYS_ACTIVE_NEW_USER" ;;
  }

  dimension: days_active_new_user_tier {
    # hidden: yes
    label: "Years Active Tiers"
    group_label: "Analytical Dimensions"
    description: "Number of years active as a Lemonade customer, by tier."
    type: string
    sql: floor(${days_active_new_user}/365)   ;;
  }

  dimension: days_active_new_user_within_lob {
    hidden: yes
    label: "New User Days Active within LOB"
    group_label: "Analytical Dimensions"
    description: "Number of days active as a customer within this LOB."
    type: number
    sql: ${TABLE}."DAYS_ACTIVE_NEW_USER_WITHIN_LOB" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }

  measure: avg_days_active_new_user {
    # hidden: yes
    label: "Average New User Days Active"
    group_label: "New User Days Active Measures"
    description: "Average number of days active as a Lemonade customer."
    type: average
    sql: ${days_active_new_user} ;;
  }

  measure: avg_days_active_new_user_within_lob {
    # hidden: yes
    label: "Average New User Days Active within LOB"
    group_label: "New User Days Active Measures"
    description: "Average number of days active as a customer within this LOB."
    type: average
    sql: ${days_active_new_user_within_lob} ;;
  }
}
