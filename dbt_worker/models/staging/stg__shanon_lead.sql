with
load_lead as (
    select
        Id as lead_id
        , DateRegist as date_regist
        , DateUpdate as date_update
        , LoginId as lead_login_id
        , Name1 as lead_name1
        , Name2 as lead_name2
        , Name3 as lead_name3
        , Name1Ka as lead_name1_ka
        , Name2Ka as lead_name2_ka
        , CompanyName as lead_company_name
        , CompanyNameKa as lead_company_name_ka
        , Division as lead_division
        , Position as lead_position
        , Zip1 as lead_zip1
        , Zip2 as lead_zip2
        , Zip3 as lead_zip3
        , CountryId as lead_country_id
        , CountryName as lead_country_name
        , PrefectureId as lead_prefecture_id
        , PrefectureName as lead_prefecture_name
        , Address1 as lead_address1
        , Address2 as lead_address2
        , Address3 as lead_address3
        , Address4 as lead_address4
        , Address5 as lead_address5
        , Tel as lead_tel
        , SubTel as lead_sub_tel
        , Fax as lead_fax
        , Email as lead_email
        , EmailValidId as lead_email_valid_id
        , EmailValidName as lead_email_valid_name
        , EmailSendErrorCount as lead_email_send_error_count
        , EmailValidDateUpdate as lead_email_valid_date_update
        , SubEmail as lead_sub_email
        , SubEmailValidId as lead_sub_email_valid_id
        , SubEmailValidName as lead_sub_email_valid_name
        , SubEmailSendErrorCount as lead_sub_email_send_error_count
        , SubEmailValidDateUpdate as lead_sub_email_valid_date_update
        , PermissionTypeId as lead_permission_type_id
        , PermissionTypeName as lead_permission_type_name
        , InspectionTypeId as lead_inspection_type_id
        , InspectionTypeName as lead_inspection_type_name
        , RegistrationTypeId as lead_registration_type_id
        , RegistrationTypeName as lead_registration_type_name
        , LanguageId as lead_language_id
        , LanguageName as lead_language_name
        , Memo as lead_memo
        , UserId as lead_user_id
        , MembershipId as lead_membership_id
        , MembershipName as lead_membership_name
        , UnsubscribeStatus as lead_unsubscribe_status
        , UnsubscribeDate as lead_unsubscribe_date
        , Attribute1 as lead_attribute1
        , Attribute35 as lead_attribute35
        , Attribute36 as lead_attribute36
        , Attribute37 as lead_attribute37
        , Attribute67 as lead_attribute67
        , Attribute68 as lead_attribute68
        , Attribute69 as lead_attribute69
        , Attribute70 as lead_attribute70
        , Attribute72 as lead_attribute72
        , Attribute73 as lead_attribute73
        , Attribute74 as lead_attribute74
        , Attribute100 as lead_attribute100
        , Attribute133 as lead_attribute133
        , Attribute134 as lead_attribute134
        , Attribute135 as lead_attribute135
        , Attribute166 as lead_attribute166
        , Attribute199 as lead_attribute199
        , Attribute232 as lead_attribute232
        , Attribute265 as lead_attribute265
        , Attribute266 as lead_attribute266
        , Attribute298 as lead_attribute298
        , load_timestamp
    from
        {{ source('raw__shanon_customer_info', 'raw__shanon_lead') }}
    where
        (Name1 not like '%テスト%' or lower(Name1) not like '%test%')
        and (Name2 not like '%テスト%' or lower(Name2) not like '%test%')
)

, final as (
    select
        lead_id
        , lead_login_id
        , lead_name1
        , lead_name2
        , lead_name3
        , lead_name1_ka
        , lead_name2_ka
        , lead_company_name
        , lead_company_name_ka
        , lead_division
        , lead_position
        , lead_zip1
        , lead_zip2
        , lead_zip3
        , lead_country_id
        , lead_country_name
        , lead_prefecture_id
        , lead_prefecture_name
        , lead_address1
        , lead_address2
        , lead_address3
        , lead_address4
        , lead_address5
        , lead_tel
        , lead_sub_tel
        , lead_fax
        , lead_email
        , lead_email_valid_id
        , lead_email_valid_name
        , lead_email_send_error_count
        , lead_email_valid_date_update
        , lead_sub_email
        , lead_sub_email_valid_id
        , lead_sub_email_valid_name
        , lead_sub_email_send_error_count
        , lead_sub_email_valid_date_update
        , lead_permission_type_id
        , lead_permission_type_name
        , lead_inspection_type_id
        , lead_inspection_type_name
        , lead_registration_type_id
        , lead_registration_type_name
        , lead_language_id
        , lead_language_name
        , lead_memo
        , lead_user_id
        , lead_membership_id
        , lead_membership_name
        , lead_unsubscribe_status
        , lead_unsubscribe_date
        , lead_attribute1
        , lead_attribute35
        , lead_attribute36
        , lead_attribute37
        , lead_attribute67
        , lead_attribute68
        , lead_attribute69
        , lead_attribute70
        , lead_attribute72
        , lead_attribute73
        , lead_attribute74
        , lead_attribute100
        , lead_attribute133
        , lead_attribute134
        , lead_attribute135
        , lead_attribute166
        , lead_attribute199
        , lead_attribute232
        , lead_attribute265
        , lead_attribute266
        , lead_attribute298
        , date_regist
        , date_update
        , load_timestamp
    from
        load_lead
)

select * from final
