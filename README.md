# LifeMemo
カリキュラム用のToDoアプリ

# 環境
- Ruby 2.4.2
- Rails 5.1.4
- PostgreSQL 9.6.5

# テーブルスキーマ
## Task
| column name     | Data types |
|:----------------|------------|
| id              | bigint     |
| name            | string     |
| description     | string     |
| expires_at      | datetime   |
| priority        | integer    |
| status          | integer    |
| user_id         | bigint     |
| label_id        | bigint     |
| created_at      | datetime   |
| updated_at      | datetime   |

## User
| column name     | Data types |
|:----------------|------------|
| id              | bigint     |
| name            | string     |
| email           | string     |
| password_digest | string     |
| created_at      | datetime   |
| updated_at      | datetime   |

## Label
| column name     | Data types |
|:----------------|------------|
| id              | bigint     |
| name            | string     |
| color           | string     |
| created_at      | datetime   |
| updated_at      | datetime   |

# デプロイ方法
*heroku* を使用し、基本は *github* との連携を行っています。

## heroku上でgithubと連携
heroku 上で githubの `everyleaf/LifeMemo` リポジトリと連携しています。
masterに変更があると、自動的に反映されます。

## 手動でデプロイする方法
コマンドで行うことも可能です。

- リモートリポジトリを登録
```
$ heroku git:remote --app APPNAME
```

- デプロイ
```
$ git push heroku master
```

- マイグレート
```
$ heroku run rake db:migrate
```
