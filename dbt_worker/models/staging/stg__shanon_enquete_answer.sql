{# 1. 縦持ち対象列のリストを、別マクロから取得 #}
{% set source_relation = source('raw__shanon_customer_info', 'raw__shanon_enquete_answer') %}
{% set pivot_list = attribute_column_unpivot_list(source_relation) %}

with
load_enquete_answer as (
    select
        *
    from
        {{ source_relation }} as answer
    where
        /*
        対象のリードが除外されていないこと。
        テストリードなどは stg__shanon_lead で除外されている
        */
        exists (
            select 1
            from {{ ref('stg__shanon_lead') }} as lead
            where lead.lead_id = answer.VisitorId
        )
)

, unpivot_attribute as (
    select
        Id
        , VisitorId
        , HistoryId
        , DataId
        , LatestFlag
        , DateAnswer
        , DateRegist
        , DateUpdate
        , attribute_name
        , attribute_value
    from
        load_enquete_answer
    unpivot (
        attribute_value
        for attribute_name in (
            {{ pivot_list }}
        )
    )
)

, rename_column as (
    select
        Id as enquete_answer_id
        , VisitorId as lead_id
        , HistoryId as enquete_history_id
        , DataId as data_id
        , regexp_extract(attribute_name, r'(\d+)') as enquete_template_attribute_id  -- 数字のみ抽出
        , attribute_value as enquete_answer_attribute_value
        , LatestFlag as latest_flag
        , DateAnswer as date_answer
        , DateRegist as date_regist
        , DateUpdate as date_update
    from
        unpivot_attribute
)

, final as (
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
        rename_column
)

select * from final
