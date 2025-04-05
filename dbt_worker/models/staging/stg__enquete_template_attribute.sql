with
load_enquete_template_attribute as (
    select
        Id as enquete_template_attribute_id
        , Name as enquete_template_attribute_name
        , ItemList as enquete_template_attribute_option_list
        , EnqueteTemplateId as enquete_template_id
        , Name as enquete_template_name
    from
        {{ source('raw__shanon_customer_info', 'raw__shanon_enquete_template_attribute') }}
    where
        Name not like '%テスト%'
        or Name not like '%test%'
        or Name not like '%TEST%'
)

, final as (
    select
        enquete_template_attribute_id
        , enquete_template_attribute_name
        , enquete_template_attribute_option_list
        , enquete_template_id
        , enquete_template_name
    from
        load_enquete_template_attribute
)

select * from final
