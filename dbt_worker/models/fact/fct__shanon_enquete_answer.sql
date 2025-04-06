with
final as (
    select
        enquete_answer_id
        , lead_id
        , enquete_history_id
        , data_id
        , enquete_template_attribute_id
        , enquete_answer_attribute_value
        , latest_flag
        , date_answer
        , date_regist
        , date_update
    from
        {{ ref('stg__shanon_enquete_answer') }}
)

select * from final
