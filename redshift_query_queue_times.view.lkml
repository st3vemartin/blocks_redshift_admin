view: redshift_query_counts {
  derived_table: {
    sql: select query_count
      , queued_count
      , start_time

      from query_queue_times_20171110


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
