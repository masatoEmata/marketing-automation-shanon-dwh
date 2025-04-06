-- dbtコマンド実行時、パラメーター必須 `--vars "{OUTPUT_PROJECT: $OUTPUT_PROJECT, OUTPUT_DATASET: $OUTPUT_DATASET}"`
with
load_enquete_answer as (
    select
        enquete_answer_id
        -- , lead_id  -- TODO: 具体的なリード情報を取得する
        , enquete_template_name
        , enquete_template_attribute_name
        -- , enquete_template_attribute_option_list  選択肢の候補を取得する場合
        , enquete_answer_attribute_value
    from
        {{ ref('obt__shanon_enquete_answer_detail') }}
    where
        enquete_history_memo like '%レビュー%'  --! サンプルのビジネスロジック。運用でアンケート履歴の「メモ」に必ず「レビュー」と入れること
)

/*
アンケートタイトルごとに質問と回答を連結
もしリードごとに要約したい場合は lead_id もgroup byに含める
*/
, aggregated_answers as (
    select
        enquete_template_name
        -- , lead_id -- リードごとに要約する場合
        , string_agg(
            enquete_template_attribute_name || ': ' || enquete_answer_attribute_value,
            '\n' -- 改行で区切る
            -- order by ... 必要であれば質問の順序を指定
        ) as concatenated_qa
    from
        load_enquete_answer
    group by all
)

, prompt_generation as (
    -- geminiへのプロンプトを作成
    select
        enquete_template_name
        -- lead_id, -- リードごとに要約する場合
        -- ! サンプル
        , CONCAT(
            'あなたは、サッカースクールを運営するNPO法人で、'
            , 'ボランティアコーチや保護者からのアンケートを集計・要約する担当者です。'
            , '以下のアンケート結果を読み、下記の指示に従って要約してください。\n\n'

            , '【指示】\n'

            , '1. アンケートは設問単位（enquete_template_attribute_name）で整理する。\n'
            , '   - まずは「設問名」と「回答内容（自由記述・定量評価）」を簡潔にまとめて一覧にしてください。\n'
            , '   - 定量評価（例: 選択肢IDが「2」で、対応ラベルが「4.やや満足」など）がある場合は、\n'
            , '     そのラベルや数値を読み取り、回答者の満足度や評価傾向をわかりやすく示してください。\n'
            , '   - 自由記述がある場合は、その内容をポイントを押さえて短くまとめてください。\n\n'

            , '2. すべての設問・回答を確認した上で、内容を「教育品質」「活動運用方法」「その他」の3つの観点に分類し、\n'
            , '   (1) 良かった点、(2) 改善点 をそれぞれまとめる。\n'
            , '   - 「教育品質」とは、コーチ陣の指導スキルや指導体系、個々の特性への対応、フィードバックの質など、教育的効果に直接かかわる要素を含む。\n'
            , '   - 「活動運用方法」とは、活動の運営体制、スタッフ間の連携、スケジュール管理、リソース配置、連絡手段など、運営上の仕組みに関わる要素を含む。\n'
            , '   - 「その他」は上記2つに該当しない内容を含む。\n\n'

            , '3. 改善点については、可能であれば具体的な対処案やヒントを簡潔に示す。\n'
            , '   - 教育機関としての視点（コーチ研修制度や評価・振り返りの仕組み、安全管理や支援体制の充実など）で、\n'
            , '     必要と思われる取り組みがあれば積極的に提案してください。\n\n'

            , '4. 特に重要または緊急度が高いと思われる課題があれば、\n'
            , '   「要注意事項」という見出しをつけて強調してください。\n\n'

            , '5. 最終出力は、(A)「設問ごとのまとめ」、(B)「教育品質・活動運用方法・その他」の観点別まとめ、(C)「要注意事項(あれば)」\n'
            , '   の順番で箇条書きを用いてわかりやすく構成してください。\n\n'

            , '【以下は例示です。モデルはこの例示を参考に、同様の出力形式を再現してください。】\n\n'

            , '---(例示 入力)---\n'
            , 'アンケートタイトル: 1on1振り返り(サンプル)\n'
            , '回答内容:\n'
            , '＜設問1: 「コミュニケーション能力の評価」＞\n'
            , '選択肢ID: 2（4.やや満足）\n'
            , '自由記述: 「コーチの声掛けが丁寧で助かっています」\n\n'
            , '＜設問2: 「活動内容に関するご意見」＞\n'
            , '自由記述: 「人数が増えてきたので、練習メニューの工夫をお願いしたいです」\n'
            , '           「会場までの道が分かりづらく、迷子になる人もいます」\n\n'

            , '---(例示 期待する出力)---\n'
            , '(A) 設問ごとのまとめ\n'
            , '・【設問1】コミュニケーション能力の評価 → 選択肢：4.やや満足、\n'
            , '   自由記述: 「コーチの声掛けが丁寧」\n'
            , '・【設問2】活動内容に関するご意見 → 自由記述: 「練習メニューの工夫」「会場が分かりづらい」\n\n'

            , '(B) 観点別まとめ\n'
            , '【教育品質】\n'
            , ' - 良かった点:\n'
            , '   - コーチの丁寧な声掛けで意欲向上\n'
            , ' - 改善点:\n'
            , '   - 特になし\n\n'
            , '【活動運用方法】\n'
            , ' - 良かった点:\n'
            , '   - 特になし\n'
            , ' - 改善点:\n'
            , '   - 練習メニューが参加人数に対応しきれていない\n'
            , '   - 会場案内のわかりやすさ向上\n\n'
            , '【その他】\n'
            , ' - 良かった点: なし\n'
            , ' - 改善点: なし\n\n'
            , '【要注意事項】\n'
            , ' - 今回は特になし\n\n'

            , '---(ここから実際の要約対象)---\n\n'

            , '【アンケートタイトル】\n'
            , enquete_template_name '\n\n'

            , '【回答内容】\n'
            , concatenated_qa

            , '\n\n---\n要約:'  -- 要約の開始を示すセパレータ
        ) as prompt -- geminiへのプロンプト
    from aggregated_answers
)

-- bigquery ml の ml.generate_text を使用して要約を生成
, summary_generation as (
    select
        ml_result.enquete_template_name
        -- ml_result.lead_id, -- リードごとに要約する場合
        , ml_result.ml_generate_text_llm_result as gemini_summary
        , ml_result.ml_generate_text_rai_result as safety_ratings
        , ml_result.ml_generate_text_status as generation_status
    from
        ml.generate_text(
            -- 事前準備: gemini_pro_model を作成しておく必要がある。mdファイル参照。
            model `{{ var('OUTPUT_PROJECT') }}.{{ var('OUTPUT_DATASET') }}_mart.gemini_pro_model`
            , (select * from prompt_generation)
            , struct(
                0.2 as temperature,       -- 生成の多様性 (低いほど決定的)
                1024 as max_output_tokens, -- 最大出力トークン数
                -- 0.95 as top_p,            -- top-pサンプリング (どちらか一方を使うことが多い)
                40 as top_k,              -- top-kサンプリング
                true as flatten_json_output -- 結果をjsonではなく文字列カラムとしてフラット化
            )
        ) as ml_result
)

, final as (
    select
        enquete_template_name
        -- , lead_id -- リードごとに要約する場合
        , gemini_summary
        , safety_ratings -- 必要であれば安全性評価も取得
        , generation_status -- 生成ステータス
    from
        summary_generation
)

select * from final
