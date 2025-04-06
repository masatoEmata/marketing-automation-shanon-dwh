{% macro attribute_column_name_list(table_catalog, table_schema, table_name) %}
    {{
        dbt_utils.get_column_values(
            table_catalog=table_catalog,
            table_schema=table_schema,
            table_name=table_name,
            column_name='column_name',
            where="column_name like 'Attribute%'"
        )
    }}
{% endmacro %}
