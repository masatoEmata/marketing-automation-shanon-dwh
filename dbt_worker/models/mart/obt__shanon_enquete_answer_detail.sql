with
one_big_table as (
    select
        answer.enquete_answer_id
        , answer.lead_id
        , answer.enquete_history_id
        , template.enquete_template_name
        , template.enquete_template_attribute_name
        , template.enquete_template_attribute_option_list
        , answer.enquete_answer_attribute_value
        , answer.latest_flag
        , answer.date_answer
        , mapping.enquete_history_memo
    from
        {{ ref('fct__shanon_enquete_answer') }} as answer
    left outer join
        {{ ref('dim__shanon_enquete_attribute') }} as template
        on
            answer.enquete_template_attribute_id = template.enquete_template_attribute_id
    left outer join
        {{ ref('stg__shanon_enquete_history') }} as mapping
        on
            answer.enquete_history_id = mapping.enquete_history_id
)

, final as (
    select
        enquete_answer_id
        , lead_id  -- TODO: 具体的なリード情報を取得する
        , enquete_history_id  -- TODO: 具体的なキャンペーン名を取得する
        , enquete_template_name
        , enquete_template_attribute_name
        , enquete_template_attribute_option_list
        , enquete_answer_attribute_value
        , enquete_history_memo
        , latest_flag
        , date_answer  -- TODO: 各種日付を取得する
    from
        one_big_table
)

select * from final
