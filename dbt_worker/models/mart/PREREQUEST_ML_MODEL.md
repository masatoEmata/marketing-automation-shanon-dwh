# 事前準備

1. 接続を作成しておく。

```bash
bq mk --connection --location=asia-northeast1 \
--project_id=<YOUR_PROJECT_ID> \
--connection_type=CLOUD_RESOURCE gemini-connection
```

2. geminiのサービスアカウントに権限を付与しておく。

```bash
gcloud projects add-iam-policy-binding <YOUR_PROJECT_ID> \
    --member="serviceAccount:bqcx-....iam.gserviceaccount.com" \  # これを付与しないとエラーになるgeminiのサービスアカウント IAM参照
    --role="roles/aiplatform.user"

```

3. geminiのモデルを作成しておく。

```sql
CREATE OR REPLACE MODEL
    `<YOUR_PROJECT_ID>.dwh__shanon_customer_info_mart.gemini_pro_model`
REMOTE WITH CONNECTION
    `<YOUR_PROJECT_ID>.asia-northeast1.gemini-connection`
OPTIONS (
    remote_service_type = 'CLOUD_AI_LARGE_LANGUAGE_MODEL_V1',
    endpoint = 'gemini-1.0-pro' -- 使用したいGeminiモデル名
);
```
