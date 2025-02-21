###### INTRA-DAY REFRESH ######

#Rebuilds table every 6 hours
datagroup: periodic_caching_6_hours {
  sql_trigger: select FLOOR(DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) / (6*60*60)) ;;
  max_cache_age: "4 hours"
}

###### DAILY REFRESH ######

#Rebuilds table at 2 AM UTC  (~8 PM ET)
datagroup: daily_caching_2_utc {
  sql_trigger: select FLOOR((DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) - 60*60*2) / (60*60*24)) ;;
  max_cache_age: "24 hours"
}

#Rebuilds table at 3 AM UTC  (~9 PM ET)
datagroup: daily_caching_3_utc {
  sql_trigger: select FLOOR((DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) - 60*60*3) / (60*60*24)) ;;
  max_cache_age: "12 hours"
}

#Rebuilds table at 4 AM UTC  (~4 AM ET)
datagroup: daily_caching_4_utc {
  sql_trigger: select FLOOR((DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) - 60*60*4) / (60*60*24)) ;;
  max_cache_age: "8 hours"
}

#Rebuilds table at 5 AM UTC  (~11 PM ET)
datagroup: daily_caching_5_utc {
  sql_trigger: select FLOOR((DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) - 60*60*5) / (60*60*24)) ;;
  max_cache_age: "24 hours"
}

#Rebuilds table at 9 AM UTC  (~3 AM ET)
datagroup: daily_caching_9_utc {
  sql_trigger: select FLOOR((DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) - 60*60*9) / (60*60*24)) ;;
  max_cache_age: "4 hours"
}

#Rebuilds table at 10 AM UTC  (~4 AM ET)
datagroup: daily_caching_10_utc {
  sql_trigger: select FLOOR((DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) - 60*60*10) / (60*60*24)) ;;
  max_cache_age: "12 hours"
}

#Rebuilds table at 11 AM UTC  (~5 AM ET)
datagroup: daily_caching_11_utc {
  sql_trigger: select FLOOR((DATE_PART('EPOCH_SECOND',CURRENT_TIMESTAMP) - 60*60*11) / (60*60*24)) ;;
  max_cache_age: "12 hours"
}

#Rebuilds table at 12  UTC  (~6 PM ET)
datagroup: daily_caching_12_utc {
  sql_trigger: select CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}

###### WEEKLY REFRESH ######

#Rebuilds table at 3 AM UTC (9 PM ET) weekly on Sunday.
datagroup: weekly_sunday_caching_3_utc  {
  sql_trigger: SELECT FLOOR((EXTRACT(epoch from CURRENT_TIMESTAMP) - 60*60*(24*3 + 3))/(60*60*24*7));;
  max_cache_age: "168 hours"
}

###### MONTHLY REFRESH ######

datagroup: monthly_fde_caching {
  #Trigger refreshes as soon as the last day of the month is added to segmentations table (should be on the 2nd of the month)
  sql_trigger:  select last_day(CURRENT_DATE()) ;;
  max_cache_age: "720 hours"
}

datagroup: monthly_loss_ratio_caching {
  sql_trigger:select last_day(CURRENT_DATE()) ;;
  max_cache_age: "288 hours"
}

#Rebuilds table at 3 AM UTC (9 PM ET) on the 5th of every month. Allows time for the lag of FDE table to take place before rebuilding monthly cohort tables built on top of FDE.
#Resets the cache age to check for the trigger every week in case the cache has not been cleared.
datagroup: monthly_caching_5th_day  {
  sql_trigger: SELECT date_trunc('Month', CURRENT_DATE - INTERVAL '4 days') + INTERVAL '3 hours';;
  max_cache_age: "168 hours"

}
