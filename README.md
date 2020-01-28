# タスク管理アプリ

## バージョン情報
- Ruby 2.6.5
- Ruby on Rails 5.2.3
- PostgreSQL 12.1

## システムの用件
- [ ] 自分のタスクを簡単に登録したい
- [ ] タスクに終了期限を設定できるようにしたい
- [ ] タスクに優先順位をつけたい
- [ ] ステータス（未着手・着手・完了）を管理したい
- [ ] ステータスでタスクを絞り込みたい
- [ ] タスク名などで指定のタスクを検索したい
- [ ] タスクを一覧したい。一覧画面で（優先順位、終了期限などを元にして）ソートしたい
- [ ] タスクにラベルなどをつけて分類したい
- [ ] ユーザ登録し、自分が登録したタスクだけを見られるようにしたい

## サポートブラウザ
- macOS/Chrome各最新版を想定

## テーブル設計
### Userテーブル
|カラム名|データ型|
---|---
|id|bigint|
|name|string|
|email|string|
|password_digest|string|
|admin|boolean|

### Taskテーブル
|カラム名|データ型|
---|---
|id|bigint|
|title|string|
|content|text|
|deadline|datetime|
|status|integer|
|priority|integer|
|usr_id|bigint|

### Task_labelsテーブル
|カラム名|データ型|
---|---
|id|bigint|
|task_id|bigint|
|label_id|bigint|

### Labelテーブル
|カラム名|データ型|
---|---
|id|bigint|
|name|string|

## herokuへのデプロイ手順
1. Herokuにログインする

`heroku login`

2. コミットする

`git add -A`

`git commmit -m "init"`

3. Herokuに新しいアプリケーションを作成

`heroku create`

4. herokuにデプロイをする

`git push heroku master`

