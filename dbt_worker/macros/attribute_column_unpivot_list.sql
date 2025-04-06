{% macro attribute_column_unpivot_list(relation, column_name_prefix='Attribute') %}
    {#
        relation は dbt の ref() や adapter.get_relation() で取得したものを想定
        例えば、{{ ref('load_enquete_answer') }} の呼び出し結果
        -> relation.database = プロジェクトID
        -> relation.schema   = データセット名
        -> relation.identifier = テーブル名
    #}

    {% set project_id = relation.database %}
    {% set dataset    = relation.schema %}
    {% set table_name = relation.identifier %}

    {# 1. INFORMATION_SCHEMA から attribute_ で始まる列名を取得するSQLを発行 #}
    {% set query %}
        select
            column_name
        from `{{ project_id }}.{{ dataset }}.INFORMATION_SCHEMA.COLUMNS`
        where
            table_name = '{{ table_name }}'
            and column_name like '{{column_name_prefix}}%'
            and lower(column_name) not like '%list'
            and lower(column_name) not like '%file'
        order by column_name
    {% endset %}

    {# 2. dbtのrun_query()を用いて、上記クエリを実行 -> 結果をPythonオブジェクトとして取得 #}
    {% set results = run_query(query) %}

    {# 3. 取得結果の行をイテレートして、UNPIVOTで必要となる "col AS 'col'" 形式の文字列リストを作成 #}
    {% set pivot_list = [] %}
    {% for row in results %}
        {% set col = row.column_name %}
        {% set item = col ~ " as '" ~ col ~ "'" %}
        {% do pivot_list.append(item) %}
    {% endfor %}

    {# 4. "attribute_1 as 'attribute_1', attribute_2 AS 'attribute_2', ..." のような文字列を返却 #}
    {{ return(pivot_list | join(',\n        ')) }}
{% endmacro %}
