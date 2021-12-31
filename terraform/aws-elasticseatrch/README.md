## Abstract

Amazon ESの環境を定義

## Getting start

### AWSのアクセストークンを記述

```
$ sudo pip install awscli
$ aws configure
```

### terraformの設定

```
$ cd path-to-project
$ terrafrom init
$ terraform workspace new dev
$ terraform workspace select dev
```

## How to deploy

### planにて構成の差分を確認

```
$ terraform plan
```

特定のリソースのみを対象にしたい場合はオプションに `-target` を記述する
https://www.terraform.io/docs/commands/plan.html

例

```
$ terraform plan -target aws_elasticsearch_domain.internal-log
```

### apply

```
$ terraform apply
```
