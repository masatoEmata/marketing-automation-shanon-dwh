with
load_enquete_template as (
    select
        Id as enquete_template_id
        , Name as enquete_template_name
        , Memo as enquete_template_memo
        , DateRegist as created_at
        , DateUpdate as updated_at
    from
        {{ source('raw__shanon_customer_info', 'raw__shanon_enquete_template') }}
    where
        Name not like '%テスト%'
        or Name not like '%test%'
        or Name not like '%TEST%'
)

, final as (
    select
        enquete_template_id
        , enquete_template_name
        , enquete_template_memo
        , created_at
        , updated_at
    from
        load_enquete_template
)

select * from final
