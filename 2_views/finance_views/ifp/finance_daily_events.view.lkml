view: finance_daily_events {
  derived_table: {
    sql: SELECT
            *
        FROM LEMONADE_DWH.DATAMART_FINANCE.MRT_IFP fes
        WHERE accounting_date < dateadd(day, -2, CURRENT_DATE)
        ;;
    datagroup_trigger: daily_caching_11_utc
  }

##### Base Dimensions ####
  dimension: primary_key {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${policy_id}||${encrypted_user_id}||${accounting_raw}||${annualized_premium} ;;
  }

  dimension: policy_id {
    group_label: "Policy Level Attributes"
    type: string
    sql: ${TABLE}."POLICY_ID" ;;
    link: {
      label: "View Policy in Blender"
      url: "https://blender.lemonade.com/backoffice/search?term={{ value }}"
      icon_url: "https://lh3.googleusercontent.com/0Vzx4mEcwROKb1NM9GanIQ4RLAJ8aw1DOErZcXFPvlqmb6JYSkcQU2zLsOiL8Ghm2Q"
    }
  }

  dimension: days_active {
    group_label: "OKR Filters"
    label: "Days Since Cohort Start"
    description: "The number of days since the beginning of the cohort (the first of the month)"
    type: number
    sql: DATEDIFF(day,DATE_TRUNC(month,${new_user_date.new_user_raw}),CURRENT_DATE()) ;;
  }

  dimension: monthly_cohort_filter {
    group_label: "OKR Filters"
    description: "Filter for 'Yes' when segmenting by New User Month. Prevents inclusion of incomplete cohorts"
    type: yesno
    sql: (MOD(${months_since_new_user},12) = 0 AND ${days_active} > ${months_since_new_user}/12*365 + 60)
        OR (MOD(${months_since_new_user},12) != 0 AND ${days_active} > ${months_since_new_user}*30 + 60)
        ;;
  }

  dimension: months_since_new_user {
    hidden: no
    group_label: "Analytical Dimensions"
    description: "How many months after the customer joined Lemonade did the financial event occur?"
    type: number
    sql: floor(DATEDIFF(days,${new_user_date.new_user_date},${accounting_date}) / 30) ;;
  }

  dimension: year_since_new_user {
    hidden: no
    group_label: "Analytical Dimensions"
    description: "How many years after the customer joined Lemonade did the financial event occur?"
    type: number
    sql: floor(DATEDIFF(days,${new_user_date.new_user_date},${accounting_date}) / 365) ;;
  }

  dimension: okr_q1_limiter {
    label: "Q1 OKR Limiter"
    group_label: "OKR Filters"
    description: "Set to TRUE for measurement of the Q1 OKR Churn Rate"
    type: yesno
    sql:
       ( (datediff(months,${new_user_date.new_user_date},'2022-03-31') = 2 OR datediff(months,${new_user_date.new_user_date},'2021-03-31') = 2 OR datediff(months,${new_user_date.new_user_date},'2023-03-31') = 2) AND ${months_since_new_user} = 1 )
    OR ( (datediff(months,${new_user_date.new_user_date},'2022-03-31') = 3 OR datediff(months,${new_user_date.new_user_date},'2021-03-31') = 3 OR datediff(months,${new_user_date.new_user_date},'2023-03-31') = 3) AND ${months_since_new_user} IN (1,2) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2022-03-31') = 4 OR datediff(months,${new_user_date.new_user_date},'2021-03-31') = 4 OR datediff(months,${new_user_date.new_user_date},'2023-03-31') = 4) AND ${months_since_new_user} IN (1,2,3) )
       ;;
  }

  dimension: okr_q2_limiter {
    label: "Q2 OKR Limiter"
    group_label: "OKR Filters"
    description: "Set to TRUE for measurement of the Q2 OKR Churn Rate"
    type: yesno
    sql:

       ( (datediff(months,${new_user_date.new_user_date},'2021-06-30') = 2 OR datediff(months,${new_user_date.new_user_date},'2022-06-30') = 2 OR datediff(months,${new_user_date.new_user_date},'2023-06-30') = 2) AND ${months_since_new_user} = 1 )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-06-30') = 3 OR datediff(months,${new_user_date.new_user_date},'2022-06-30') = 3 OR datediff(months,${new_user_date.new_user_date},'2023-06-30') = 3) AND ${months_since_new_user} IN (1,2) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-06-30') = 4 OR datediff(months,${new_user_date.new_user_date},'2022-06-30') = 4 OR datediff(months,${new_user_date.new_user_date},'2023-06-30') = 4) AND ${months_since_new_user} IN (1,2,3) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-06-30') = 5 OR datediff(months,${new_user_date.new_user_date},'2022-06-30') = 5 OR datediff(months,${new_user_date.new_user_date},'2023-06-30') = 5) AND ${months_since_new_user} IN (1,2,3,4) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-06-30') = 6 OR datediff(months,${new_user_date.new_user_date},'2022-06-30') = 6 OR datediff(months,${new_user_date.new_user_date},'2023-06-30') = 6) AND ${months_since_new_user} IN (1,2,3,4,5) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-06-30') = 7 OR datediff(months,${new_user_date.new_user_date},'2022-06-30') = 7 OR datediff(months,${new_user_date.new_user_date},'2023-06-30') = 7) AND ${months_since_new_user} IN (1,2,3,4,5,6) )
       ;;
  }

  dimension: okr_q3_limiter {
    label: "Q3 OKR Limiter"
    group_label: "OKR Filters"
    description: "Set to TRUE for measurement of the Q3 OKR Churn Rate"
    type: yesno
    sql:

    ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 2 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 2 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 2) AND ${months_since_new_user} = 1 )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 3 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 3 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 3) AND ${months_since_new_user} IN (1,2) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 4 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 4 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 4) AND ${months_since_new_user} IN (1,2,3) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 5 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 5 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 5) AND ${months_since_new_user} IN (1,2,3,4) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 6 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 6 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 6) AND ${months_since_new_user} IN (1,2,3,4,5) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 7 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 7 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 7) AND ${months_since_new_user} IN (1,2,3,4,5,6) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 8 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 8 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 8) AND ${months_since_new_user} IN (1,2,3,4,5,6,7) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 9 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 9 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 9) AND ${months_since_new_user} IN (1,2,3,4,5,6,7,8) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-09-30') = 10 OR datediff(months,${new_user_date.new_user_date},'2022-09-30') = 10 OR datediff(months,${new_user_date.new_user_date},'2023-09-30') = 10) AND ${months_since_new_user} IN (1,2,3,4,5,6,7,8,9) )
    ;;
  }

  dimension: okr_q4_limiter {
    label: "Q4 OKR Limiter"
    group_label: "OKR Filters"
    description: "Set to TRUE for measurement of the Q4 OKR Churn Rate"
    type: yesno
    sql:
    ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 2 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 2 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 2) AND ${months_since_new_user} = 1 )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 3 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 3 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 3) AND ${months_since_new_user} IN (1,2) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 4 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 4 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 4) AND ${months_since_new_user} IN (1,2,3) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 5 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 5 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 5) AND ${months_since_new_user} IN (1,2,3,4) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 6 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 6 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 6) AND ${months_since_new_user} IN (1,2,3,4,5) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 7 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 7 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 7) AND ${months_since_new_user} IN (1,2,3,4,5,6) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 8 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 8 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 8) AND ${months_since_new_user} IN (1,2,3,4,5,6,7) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 9 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 9 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 9) AND ${months_since_new_user} IN (1,2,3,4,5,6,7,8) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 10 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 10 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 10) AND ${months_since_new_user} IN (1,2,3,4,5,6,7,8,9) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 11 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 11 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 11) AND ${months_since_new_user} IN (1,2,3,4,5,6,7,8,9,10) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 12 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 12 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 12) AND ${months_since_new_user} IN (1,2,3,4,5,6,7,8,9,10,11) )
    OR ( (datediff(months,${new_user_date.new_user_date},'2021-12-31') = 13 OR datediff(months,${new_user_date.new_user_date},'2022-12-31') = 13 OR datediff(months,${new_user_date.new_user_date},'2023-12-31') = 13) AND ${months_since_new_user} IN (1,2,3,4,5,6,7,8,9,10,11,12) )
    ;;
  }

  dimension: okr_limiter_type {
    label: "OKR Limiter Type"
    group_label: "OKR Filters"
    description: "Use to segment churn into different OKR calculation buckets."
    type: string
    sql: CASE
              WHEN ${okr_q1_limiter} = TRUE THEN 'Q1'
              WHEN ${okr_q2_limiter} = TRUE THEN 'Q2'
              WHEN ${okr_q3_limiter} = TRUE THEN 'Q3'
              WHEN ${okr_q4_limiter} = TRUE THEN 'Q4'
              ELSE null
            END ;;
  }

  dimension: encrypted_user_id {
    group_label: "Policy Level Attributes"
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: combined_user_id {
    group_label: "Policy Level Attributes"
    type: string
    sql: ${TABLE}."MATCH_USER_ID_FOR_MM" ;;
  }

  dimension: value {
    group_label: "Policy Level Attributes"
    hidden: yes
    label: "Daily Earned Premium ($USD)"
    type: number
    sql: ${TABLE}."DAILY_PREMIUM_USD" ;;
  }
  dimension: annualized_premium {
    group_label: "Policy Level Attributes"
    label: "In-Force Annual Premium ($USD) - (Excl. Palomar)"
    description: "The total in-force written & placed premium for the policy (excl. Palomar)"
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
    label: "In-Force Annual Premium ($USD) - Placed (Excl. Palomar)"
    description: "The total in-force *placed* premium for the policy (excl. Palomar)"
    type: number
    sql: ${TABLE}."ANNUALIZED_PLACED_PREMIUM_USD" ;;
  }

  dimension: is_mpp_quote {
    group_label: "Policy Level Attributes"
    label: "Is MPP Policy"
    description: "policy which was purchased via MPP flow"
    type: yesno
    sql: ${mpp_combined.is_mpp_quote} ;;
  }
  dimension: source {
    group_label: "Policy Level Attributes"
    label: "quote source"
    description: "where was the quote originated (app / web / metromile etc.)"
    type: string
    sql: ${quotes_master.source} ;;
  }

  dimension: is_mm_migrated_user {
    label: "Is MM Migrated Car Customer"
    group_label: "Policy Level Attributes"
    type: yesno
    sql: ${users_sf.is_mm_migrated_user} ;;
  }

  measure: count_mm_migrated_users {
    label: "MM Migrated Car Customer Count"
    group_label: "MM Migrated User Count"
    hidden: yes
    type: count_distinct
    sql: ${encrypted_user_id} ;;
    filters: [
      is_mm_migrated_user: "yes"
    ]
  }

  measure: count_non_mm_migrated_users {
    label: "Non-MM Migrated Car Customer Count"
    group_label: "MM Migrated User Count"
    hidden: yes
    type: count_distinct
    sql: ${encrypted_user_id} ;;
    filters: [
      is_mm_migrated_user: "no"
    ]
  }

  measure: bolt_2024_q3_ifp {
    label: "Bolt 2024 Q3 IFP"
    description: "This is Bolt's IFP derived from EOQ spreadsheet for Q3 2024 - Prior to when Bolt IFP was incorporated into the main IFP model starting in 2024 Q4?"
    type: average
    sql: CASE WHEN ${accounting_date} = LAST_DAY(to_date('2024-09-01')) THEN '922788' ELSE NULL END ;;
    value_format_name: usd_0
  }

  measure: bolt_2024_q3_active_customer_count {
    label: "Bolt 2024 Q3 Active Customer Count"
    description: "This is Bolt's Active Customer Count number derived from EOQ spreadsheet for Q3 2024 - Prior to when Bolt IFP was incorporated into the main IFP model starting in 2024 Q4?"
    type: average
    sql: CASE WHEN ${accounting_date} = LAST_DAY(to_date('2024-09-01')) THEN '248' ELSE NULL END ;;
    value_format_name: decimal_0
  }

  measure: lng_2024_q1_q2_active_customer_count {
    label: "L&G 2024 Q1 & Q2 Active Customer Count"
    description: "This is L&G's Active Customer Count number derived from the lng_policies_report Looker view file for Q1 & Q2 2024 - Prior to when L&G IFP was incorporated into the main IFP model starting in 2024 Q3."
    type: average
    sql: CASE WHEN ${accounting_date} = LAST_DAY(to_date('2024-06-01')) THEN '256'
              WHEN ${accounting_date} = LAST_DAY(to_date('2024-05-01')) THEN '165'
              WHEN ${accounting_date} = LAST_DAY(to_date('2024-04-01')) THEN '67'
              ELSE NULL
         END ;;
    value_format_name: decimal_0
  }

  measure: lng_2024_q1_q2_ifp {
    label: "L&G 2024 Q1 & Q2 IFP"
    description: "This is L&G's IFP derived from the lng_policies_report Looker view file for Q1 & Q2 2024 - Prior to when L&G IFP was incorporated into the main IFP model starting in 2024 Q3."
    type: average
    sql: CASE WHEN ${accounting_date} = LAST_DAY(to_date('2024-06-01')) THEN '348903'
              WHEN ${accounting_date} = LAST_DAY(to_date('2024-05-01')) THEN '241962'
              WHEN ${accounting_date} = LAST_DAY(to_date('2024-04-01')) THEN '89802'
              ELSE NULL
         END ;;
    value_format_name: usd_0
  }

  measure: tx_il_home_correction_ifp {
    label: "TX/IL Home Correction IFP"
    description: "This additional IFP was corrected given an analysis on 7/12/2024 where we had missed out on IFP. This is a one-time add for Q2 to account this for EOQ reporting."
    type: average
    sql: CASE WHEN ${accounting_date} = LAST_DAY(to_date('2024-06-01')) THEN '697000' ELSE NULL END ;;
    value_format_name: usd_0
  }

  measure: lmnd_car_ppm_correction_ifp {
    label: "LMND Car PPM Correction IFP"
    description: "This additional IFP was corrected given an analysis on 7/12/2024 where we had missed out on IFP due to adding late miles from June/May incidents plu changing per mile rate to most recent one instead of average. This is a one-time add for Q2 to account this for EOQ reporting."
    type: average
    sql: CASE WHEN ${accounting_date} = LAST_DAY(to_date('2024-06-01')) THEN '814942' ELSE NULL END ;;
    value_format_name: usd_0
  }

  measure: mm_correction_ifp {
    label: "MM Correction IFP"
    description: "This additional IFP was corrected given an analysis on 7/12/2024 where we had missed out on IFP due to adding late miles from June/May incidents plu changing per mile rate to most recent one instead of average. This is a one-time add for Q2 to account this for EOQ reporting."
    type: average
    sql: CASE WHEN ${accounting_date} = LAST_DAY(to_date('2024-06-01')) THEN '2245568' ELSE NULL END ;;
    value_format_name: usd_0
  }

  measure: palomar_placed_ifp {
    label: "Palomar IFP (Placed)"
    description: "The amount of IFP that was placed and active as of as of the last day of the month."
    type: average
    sql:
        CASE
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-09-01')) THEN '585679'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-08-01')) THEN '610067'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-07-01')) THEN '622524'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-06-01')) THEN '641852'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-05-01')) THEN '653816'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-04-01')) THEN '650233'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-03-01')) THEN '657889'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-02-01')) THEN '662747'
            WHEN ${accounting_date} = LAST_DAY(to_date('2024-01-01')) THEN '656111'

      WHEN ${accounting_date} = LAST_DAY(to_date('2023-12-01')) THEN '655299'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-11-01')) THEN '669107'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-10-01')) THEN '676604'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-09-01')) THEN '678064'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-08-01')) THEN '680756'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-07-01')) THEN '677019'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-06-01')) THEN '690139'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-05-01')) THEN '693162'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-04-01')) THEN '701957'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-03-01')) THEN '699655'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-02-01')) THEN '706184'
      WHEN ${accounting_date} = LAST_DAY(to_date('2023-01-01')) THEN '707007'

      WHEN ${accounting_date} = LAST_DAY(to_date('2022-12-01')) THEN '710574'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-11-01')) THEN '756360'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-10-01')) THEN '762149'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-09-01')) THEN '756536'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-08-01')) THEN '754237'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-07-01')) THEN '759834'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-06-01')) THEN '777516'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-05-01')) THEN '790471'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-04-01')) THEN '790572'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-03-01')) THEN '802175'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-02-01')) THEN '859234'
      WHEN ${accounting_date} = LAST_DAY(to_date('2022-01-01')) THEN '785136'

      WHEN ${accounting_date} = LAST_DAY(to_date('2021-12-01')) THEN '771426'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-11-01')) THEN '768634'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-10-01')) THEN '738755'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-09-01')) THEN '724545'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-08-01')) THEN '713701'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-07-01')) THEN '711639'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-06-01')) THEN '653986'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-05-01')) THEN '649831'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-04-01')) THEN '629611'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-03-01')) THEN '617003'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-02-01')) THEN '603494'
      WHEN ${accounting_date} = LAST_DAY(to_date('2021-01-01')) THEN '606371'

      WHEN ${accounting_date} = LAST_DAY(to_date('2020-12-01')) THEN '587541'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-11-01')) THEN '561571'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-10-01')) THEN '635668'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-09-01')) THEN '523187'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-08-01')) THEN '512194'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-07-01')) THEN '454494'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-06-01')) THEN '469249'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-05-01')) THEN '453883'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-04-01')) THEN '431354'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-03-01')) THEN '391852'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-02-01')) THEN '359779'
      WHEN ${accounting_date} = LAST_DAY(to_date('2020-01-01')) THEN '358471'

      WHEN ${accounting_date} = LAST_DAY(to_date('2019-12-01')) THEN '345601'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-11-01')) THEN '307437'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-10-01')) THEN '294561'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-09-01')) THEN '258556'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-08-01')) THEN '248295'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-07-01')) THEN '219711'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-06-01')) THEN '160288'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-05-01')) THEN '150600'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-04-01')) THEN '140005'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-03-01')) THEN '121016'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-02-01')) THEN '115846'
      WHEN ${accounting_date} = LAST_DAY(to_date('2019-01-01')) THEN '109304'

      WHEN ${accounting_date} = LAST_DAY(to_date('2018-12-01')) THEN '96790'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-11-01')) THEN '85786'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-10-01')) THEN '79142'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-09-01')) THEN '72058'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-08-01')) THEN '65301'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-07-01')) THEN '58667'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-06-01')) THEN '53552'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-05-01')) THEN '50339'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-04-01')) THEN '45300'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-03-01')) THEN '39291'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-02-01')) THEN '37450'
      WHEN ${accounting_date} = LAST_DAY(to_date('2018-01-01')) THEN '35033'

      WHEN ${accounting_date} = LAST_DAY(to_date('2017-12-01')) THEN '30057'
      WHEN ${accounting_date} = LAST_DAY(to_date('2017-11-01')) THEN '27876'
      WHEN ${accounting_date} = LAST_DAY(to_date('2017-10-01')) THEN '24707'
      WHEN ${accounting_date} = LAST_DAY(to_date('2017-09-01')) THEN '19425'
      WHEN ${accounting_date} = LAST_DAY(to_date('2017-08-01')) THEN '11374'
      WHEN ${accounting_date} = LAST_DAY(to_date('2017-07-01')) THEN '6408'
      WHEN ${accounting_date} = LAST_DAY(to_date('2017-06-01')) THEN '2958'
      WHEN ${accounting_date} = LAST_DAY(to_date('2017-05-01')) THEN '564'

      ELSE NULL
      END ;;
    value_format_name: usd_0
  }

##### Date & Date Manipulations #####

  dimension_group: accounting {
    label: "* * Accounting"
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."ACCOUNTING_DATE" ;;
  }

  # Gsheets Looker Connector ONLY
  dimension: accounting_date_within_14_days {
    label: "Accounting Date within 14 days (For Gsheets Looker Connector only)"
    group_label: "Gsheets Looker Connector"
    type: yesno
    sql: CASE WHEN datediff(day, ${accounting_date}, CURRENT_DATE) <= 14 THEN 1 ELSE 0 END ;;
  }

  dimension: weeks_after_launch_renters {
    hidden: yes
    group_label: "Weeks After Launch Timeframes"
    type: number
    sql: datediff(week,'2016-09-19',${accounting_date}) ;;
  }

  dimension: weeks_after_launch_life {
    hidden: yes
    group_label: "Weeks After Launch Timeframes"
    type: number
    sql: datediff(week,'2021-01-13',${accounting_date}) ;;
  }

  dimension: car_states_boolean {
    label: "Live Car State"
    group_label: "Attributes - Customer"
    #description: "Returns TRUE if the customer is in a state that LMND sells Car Insurance after the date pulled in the report."
    description: "Identifies customers who became new customers in live car states vs. non-car. This adjusts for historical data as well (i.e. TX new customers before December 2022 will be tagged as 'Non-Car'."
    type: string
    sql:
         CASE WHEN  (${user_facts.initial_state_of_user_id} = 'TX' AND ${accounting_date} > '2022-12-05') THEN 'TX'
              WHEN  (${user_facts.initial_state_of_user_id} = 'IL' AND ${accounting_date} > '2021-11-06') = 1 OR
                    (${user_facts.initial_state_of_user_id} = 'TN' AND ${accounting_date} > '2022-02-11') = 1 OR
                    (${user_facts.initial_state_of_user_id} = 'OH' AND ${accounting_date} > '2022-07-01') = 1 THEN 'IL, TN, OH'
              ELSE 'Non-Car'
              END
            ;;
  }

  dimension: last_day_of_quarter {
    group_label: "Date Types"
    type: yesno
    sql: ${accounting_date} = last_day(to_date(${accounting_raw})) AND EXTRACT(month from to_date(${accounting_raw})) IN ('3','6','9','12') ;;
  }

  dimension: first_day_of_quarter {
    group_label: "Date Types"
    type: yesno
    sql: EXTRACT(day from to_date(${accounting_raw})) = 1 AND EXTRACT(month from to_date(${accounting_raw})) IN ('1','4','7','10') ;;
  }

  dimension: last_day_of_month {
    group_label: "Date Types"
    type: yesno
    sql: ${accounting_date} = last_day(to_date(${accounting_raw})) ;;
  }

  dimension: first_day_of_month {
    group_label: "Date Types"
    type: yesno
    sql: extract(day from to_date(${accounting_raw})) = 1 ;;
  }

  dimension: last_day_of_week {
    group_label: "Date Types"
    description: "End of week = Sunday"
    type: yesno
    sql: ${accounting_day_of_week} = 'Sunday' ;;
  }

  dimension: weeks_after_launch_us {
    hidden: yes
    group_label: "Weeks After Launch Timeframes"
    type: number
    sql: datediff(week,'2016-09-19',${accounting_raw}) ;;
  }

  dimension: weeks_after_launch_de {
    hidden: yes
    group_label: "Weeks After Launch Timeframes"
    type: number
    sql: datediff(week,'2019-06-10',${accounting_raw}) ;;
  }

  dimension: weeks_after_launch_nl {
    hidden: yes
    group_label: "Weeks After Launch Timeframes"
    type: number
    sql: datediff(week,'2020-04-01',${accounting_raw}) ;;
  }

  dimension: us_eur_fx {
    hidden: no
    label: "USD to Euro FX Rate"
    description: "USD to Euro FX Rate. Used to convert all financial metrics (including GB) to Euro for financial reporting"
    type: number
    sql: ${currency_conversions_to_usd.rate_usd_to_eur} ;;

  }

  parameter: product_filter {
    hidden: no
    type: unquoted
    allowed_value: { value: "ho4" }
    allowed_value: { value: "ho3" }
    allowed_value: { value: "ho6" }
    allowed_value: { value: "pet" }
    allowed_value: { value: "life10" }
  }

  ##### Aggregations / Measures #####

  measure: active_user_count {
    label: "Active Customer Count"
    group_label: "Daily Metric Measures"
    description: "Counts Number of Unique User IDs that have policies that have a status of 'active', at a daily level."
    type: count_distinct
    sql: ${combined_user_id} ;;
    drill_fields: []
  }

  measure: active_policy_count {
    label: "Active Policy Count"
    group_label: "Daily Metric Measures"
    description: "Counts Number of Unique Policy IDs that have a status of 'active', at a daily level."
    type: count_distinct
    sql: ${policy_id} ;;
    drill_fields: []
  }

  measure: arr {
    label: "In-Force Premium ($USD) - Excl. Palomar"
    group_label: "Daily Metric Measures"
    description: "Sums the annual premium of policies that have a status of 'active', at a daily level. Includes both Written and Placed premium, though excludes Palomar"
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
    label: "In-Force Premium ($USD) - Placed (Excl. Palomar)"
    group_label: "Daily Metric Measures"
    description: "The total amount of Placed Premium (e.g., Life, FR Assistance) across all active policies on a daily level. EXCLUDES Palomar."
    type: sum
    sql: ${annualized_premium_placed} ;;
    drill_fields: []
    value_format_name: usd_0
  }

  measure: arr_eur {
    #hidden: yes
    label: "In-Force Written Premium (Local)"
    group_label: "Daily Metric Measures"
    description: "Sums the annual premium of policies that have a status of 'active', at a daily level."
    type: sum
    sql: ${annualized_premium} / ${currency_conversions_to_usd.rate} ;;
    #sql: ${TABLE}."ANNUALIZED_PREMIUM_LOCAL" ;;
    #html: {{ currency_symbol._value }}{{ rendered_value }};;
    value_format_name: decimal_0
  }

  measure: ifp_euro {
    label: "In-Force Premium (Euro) - Excl. Palomar"
    group_label: "Daily Metric Measures"
    description: "Sums the annual premium of policies that have a status of 'active', at a daily level. Includes both Written and Placed premium, though excludes Palomar"
    type: sum
    sql: ${annualized_premium}*${currency_conversions_to_usd.rate_usd_to_eur} ;;
    drill_fields: []
    value_format_name: eur_0
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

  measure: apv_eur {
    hidden: yes
    label: "Average Premium per Customer (Premium-per-Customer - EUR/Pound)"
    group_label: "Daily Metric Measures"
    description: "Reflects the Average Value of Annual Premiums that have a status of 'active'."
    type: number
    sql: ${arr_eur}/nullifzero(${active_user_count}) ;;
    drill_fields: []
    value_format: "#.##€"
  }

  measure: earned_premium {
    group_label: "Daily Metric Measures"
    description: "Sums the *daily* earned premium (in $USD) for policies that have a status of 'active'."
    type: sum
    sql: ${value} ;;
    value_format_name: usd_0
  }

  measure: total_earned_premium_per_customer {
    label: "Total Earned Premium per Customer"
    group_label: "Daily Metric Measures"
    description: "Total earned premium (in $USD) for policies that have a status of 'active' over number of unique user IDs that have policies that have a status of 'active'."
    type: number
    sql: ${earned_premium}/nullifzero(${active_user_count}) ;;
    value_format_name: usd_0
  }

  measure: bundled_ifp {
    group_label: "Daily Metric Measures"
    label: "Multi-Line IFP"
    description: "Of all IFP on a given day, what $ amount belongs to customers with Multiple Lines-of-Business?"
    type: sum
    sql: ${annualized_premium} ;;
    filters: [daily_customer_active_policy_lob_count.is_bundled: "Yes"]
    value_format_name: usd_0
  }

  measure: bundled_ifp_pct {
    hidden: yes
    group_label: "Daily Metric Measures"
    label: "Multi-Line IFP - %"
    description: "Of all IFP on a given day, what % is multi-line?"
    type: number
    sql: ${bundled_ifp} / NULLIFZERO(${arr}) ;;
    value_format_name: percent_1
  }

  #
  measure: multi_line_active_user_count {
    label: "Multi-line Active Customer Count"
    group_label: "Daily Metric Measures"
    description: "Counts Number of Unique Multi-line User IDs that have policies that have a status of 'active', at a daily level."
    type: count_distinct
    sql: ${combined_user_id} ;;
    filters: [daily_customer_active_policy_lob_count.is_bundled: "Yes"]
    drill_fields: []
  }

}
