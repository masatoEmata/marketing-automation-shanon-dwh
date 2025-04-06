with
load_enquete_history as (
    select
        Id as enquete_history_id
        , EnqueteTemplateId as enquete_template_id
        , EnqueteTemplateName as enquete_template_name
        , EnquetePlace2Id as enquete_place2_id
        , ApplicationFlowId as application_flow_id
        , ApplicationFlowName as application_flow_name
        , Name as enquete_history_name
        , Memo as enquete_history_memo
        -- , EnqueteStatusId as enquete_history_status_id  不要
        , EnqueteStatusName as enquete_history_status_name
        , StartDay as enquete_history_start_date
        , EndDay as enquete_history_end_date
    from
        {{ source('raw__shanon_customer_info', 'raw__shanon_enquete_history') }}
    where
        Name not like '%テスト%'
        or lower(Name) not like '%test%'
)

, final as (
    select
        enquete_history_id
        , enquete_template_id
        , enquete_template_name
        , enquete_place2_id
        , application_flow_id
        , application_flow_name
        , enquete_history_name
        , enquete_history_memo
        -- , enquete_history_status_id  不要
        , enquete_history_status_name
        , enquete_history_start_date
        , enquete_history_end_date
    from
        load_enquete_history
)

select * from final
