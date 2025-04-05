with
-- 1. Enquete Template Attribute
load_enquete_template_attribute as (
    select
        enquete_template_attribute_id
        , enquete_template_attribute_name
        , enquete_template_attribute_option_list
        , enquete_template_id
        , enquete_template_name
    from
        {{ ref('stg__enquete_template_attribute') }}
)

-- 2. Enquete Template
, load_enquete_template as (
    select
        enquete_template_id
        , enquete_template_name
        , enquete_template_memo
        , created_at
        , updated_at
    from
        {{ ref('stg__enquete_template') }}
)

-- 3. Join Enquete Template and Enquete Template Attribute
, load_enquete_template_attribute_join as (
    select
        enq_attribute.enquete_template_attribute_id
        , enq_attribute.enquete_template_attribute_name
        , enq_attribute.enquete_template_attribute_option_list
        , enq_attribute.enquete_template_id
        , enq_template.enquete_template_name
        , enq_template.enquete_template_memo
        , enq_template.created_at
        , enq_template.updated_at
    from
        load_enquete_template_attribute as enq_attribute
    left outer join
        load_enquete_template as enq_template
        on
            enq_attribute.enquete_template_id = enq_template.enquete_template_id
)

, final as (
    select
        enquete_template_attribute_id
        , enquete_template_attribute_name
        , enquete_template_attribute_option_list
        , enquete_template_id
        , enquete_template_name
        , enquete_template_memo
        , created_at
        , updated_at
    from
        load_enquete_template_attribute_join
)

select * from final
