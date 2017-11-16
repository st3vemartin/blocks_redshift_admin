view: redshift_query_queue_times {
  derived_table: {
    sql: select count(*) as query_count
      , COALESCE(SUM((total_queue_time > 0)::int ), 0) as queued_count
      , TO_CHAR(DATE_TRUNC('hour', dateadd(hour,-5,service_class_start_time)), 'YYYY-MM-DD HH24') as start_time

      from STL_WLM_QUERY

      where
            dateadd(hour,-5,service_class_start_time) < '11/11/2017'
       and  dateadd(hour,-5,service_class_start_time) >= '11/10/2017'

      group by TO_CHAR(DATE_TRUNC('hour', dateadd(hour,-5,service_class_start_time)), 'YYYY-MM-DD HH24')
      order by TO_CHAR(DATE_TRUNC('hour', dateadd(hour,-5,service_class_start_time)), 'YYYY-MM-DD HH24')


             ;;
  }

  dimension_group: start {
    type: time
    timeframes: [raw, minute15, hour, day_of_week, date]
    sql: ${TABLE}.start_time ;;
  }

  measure: query_count {
    type: sum
    sql: ${TABLE}.query_count::int ;;
  }

  measure: queued_count {
    type: sum
    sql: ${TABLE}.queued_count::int ;;
  }
  measure: percent_queued {
    type: number
    value_format: "0.## \%"
    sql: 100 * ${queued_count} / ${query_count}  ;;
  }


}
