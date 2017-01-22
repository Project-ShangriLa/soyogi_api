# Soyogi API
ShangriLa Anime API Server for Twitter Data Voice Actor

## Soyogi Server システム概要

### 説明

* アニメに関するTwitterのデータを返すREST形式のAPIサーバーのリファレンス実装です。
* ShangriLa Anime API のサブセットです。

### サーバーシステム要件

* Ruby 2.2+
* フレームワーク Sinatra

#### API Server

```
bundle install
```

### 起動方法-開発

```
bundle exec ruby soyogi_api.rb
```

or

```
bundle exec rerun ruby soyogi_api.rb
```

or


```
bundle exec unicorn -c unicorn.rb
```

### 起動方法-本番

```
bundle exec unicorn -c unicorn.rb -D -E production
```
-D デーモン化
-E production

デーモン化した後の再起動

```
kill -HUP `cat /tmp/unicorn_sana.pid`
```


## V1 API リファレンス

### エンドポイント

http://api.moemoe.tokyo/anime/v1/

### 認証

V1では認証を行いません。


### レートリミット

なし

### GET /anime/v1/voice-actor/twitter/follower/diff-ranking

```
パラメーター: range={日数}
```

上位50人を返す

```
curl localhost:4567/anime/v1/voice-actor/twitter/follower/diff-ranking

curl 'localhost:4567/anime/v1/voice-actor/twitter/follower/diff-ranking?range=1' | jq . | less
```


```
{
  "start": "2017-01-21 20:00",
  "end": "2017-01-22 20:00",
  "diff_hour": 24,
  "diff_follower": [
    {
      "name": "島﨑信長(島崎信長)",
      "num": 1217
    },
    {
      "name": "上坂すみれ",
      "num": 1182
    },
    {
      "name": "高橋李依",
      "num": 903
    },
    {
      "name": "諏訪部順一 Junichi Suwabe",
      "num": 892
    },
    {
      "name": "愛美",
      "num": 865
    },
    {
      "name": "杉田智和",
      "num": 751
    },
    {
      "name": "中村悠一オルタ",
      "num": 717
    },
    {
```    