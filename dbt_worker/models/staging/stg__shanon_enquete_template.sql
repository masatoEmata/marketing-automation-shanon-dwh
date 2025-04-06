with
load_enquete_template as (
    select
        Id as enquete_template_id
        , Name as enquete_template_name
        , Memo as enquete_template_memo
        , DateRegist as date_regist
        , DateUpdate as date_update
    from
        {{ source('raw__shanon_customer_info', 'raw__shanon_enquete_template') }}
    where
        Name not like '%テスト%'
        or lower(Name) not like '%test%'
)

, final as (
    select
        enquete_template_id
        , enquete_template_name
        , enquete_template_memo
        , date_regist
        , date_update
    from
        load_enquete_template
)

select * from final
