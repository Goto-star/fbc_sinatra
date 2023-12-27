# fbcプラクティス「Sinatra を使ってWebアプリケーションの基本を理解する」

プラクティス「Sinatra を使ってWebアプリケーションの基本を理解する」の課題です。

# 使用手順

## 1.データベースの準備

1.Homebrewを確認してください。

```
brew --version
```

2.インストールできるpostgreSQLを確認してください。

```
brew search postgresql
```

3.postgreSQLをインストールしてください。

```
brew install postgresql
```
バージョン確認の実施

```
psql --version
```

## 2.データベースの作成

4.postgreSQLを起動してください。
```
brew services start postgresql
```

5.postgreSQLへログインします。

```
psql postgres
```

6.テーブル作成コマンドを実行してください。

```
create table fbc_memo_app;
```

## 3.アプリケーションの用意

1.作業用PCの任意のディレクトリにgit cloneしてください。

```
git clone https://github.com/ユーザー名/fbc_sinatra
```

2.アプリを起動してください。

```
bundle exec ruby main.rb
```

3.アプリを終了する場合

```
ctl + C
```
