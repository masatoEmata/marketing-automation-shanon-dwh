# 開発環境のセットアップ

## 事前準備

- `python --version` で Python のバージョンが、`pyproject.toml` に記載されているバージョンと一致していること。
一致していない場合、同じバージョンをインストールしてください。
- `poetry 1.8.3` が [インストール](https://python-poetry.org/docs/) されていること

拘りがなければ、以下の方法でも実現できます。

1. [asdf を インストール](https://asdf-vm.com/ja-jp/guide/getting-started.html)する
2. [依存関係をインストールする](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)
3. [Pythonプラグインをインストールする](https://github.com/asdf-community/asdf-python?tab=readme-ov-file#asdf-python)
4. `asdf list-all python` でインストール可能なバージョンを確認する
5. `asdf install`を実行し、`.tool-versions`ファイルに記載されたバージョンをインストールする
6. `asdf plugin-add poetry`を実行し、poetryをインストールする

## 仮想環境の作成

Poetryで `poetry.lock` に定義した依存関係をインストールしつつ、仮想環境を作成します。

1. `poetry config virtualenvs.in-project true` でプロジェクト内に仮想環境を作成する
2. `poetry install` で依存関係をインストールする
3. `poetry shell` で仮想環境に入る

## 環境変数の設定

zsh を使用している場合、以下の手順で環境変数を設定します。

1. `cp .envrc.sample .envrc` で環境変数の設定ファイルをコピーする
2. `brew install direnv` で direnv をインストールする
3. 実際の環境変数を設定し、`direnv allow` で許可する
4. `~/.zshrc` に `eval "$(direnv hook zsh)"` を追記し、direnv が自動的に環境変数を適用する
5. `source ~/.zshrc` で zsh の設定を再読み込みする
6. `echo $<変数名>` で環境変数が正しく設定されているか確認する

zsh以外も似たような手順で設定します。

ー> `dbt_worker/profiles.yml` の環境変数や Terraformコマンドなどで、指定した環境変数が使用できるようになります。なお、このPJのprofilesでは、BigQueryを前提に記述しているので、DBに応じて環境変数は変更する必要があります。

## 接続の確認

`dbt debug` を実行し、接続が正しく行えるか確認します。

例：BigQueryを使用する場合:

```zsh
gcloud auth application-default login
```

例：Snowflakeを使用する場合:

1. Snowflakeのロールを付与する: `alter user [自分のユーザー名] set DEFAULT_ROLE = *_role`
2. [キーペア認証する](https://docs.snowflake.com/ja/user-guide/key-pair-auth)
