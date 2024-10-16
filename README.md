# Terraformのモックサンプル

## 概要

Terraformでモックを使ったテストを動かすサンプルコードです。

比較的新しい機能でまだネット上に有用な例が少ないようだったので自分で書きました。

情報が少ないのでこれがベストな書き方という訳ではないと思いますが、動いた例として参考にしてください。

ちなみに`Terrafrom 1.9.5`での内容なので、それ以上のバージョンによっては書き方や動作が変わってくる可能性があります。

## Terraformのテストとモックについての概要

- `.tftest.hcl`拡張子のファイルがTerraformのテストコードになる
- `.tftest.hcl`内ではlocalsやvariablesなどの変数は使えない模様
- ルートモジュール内に`tests`ディレクトリを作成し、その中に`.tftest.hcl`を複数入れると`terraform test`コマンドでまとめてテストを実行可能
- モックにしたい部分は`data`で検索する形が今のところ一番良さそう
  - その`data`部分をモックを使ってテスト用の値で上書きする

## Terraformのテストの書き方について

- モック用プロバイダ(あった方が良さそう)

~~~shell
mock_provider "aws" {
  alias = "fake"
}
~~~

- dataリソースのオーバーライド

~~~shell
override_data {
  target = data.xxx.yyy # ルートモジュール内にある対象リソース

  # モックとして返す値の設定(複数の要素を設定可能)
  values = {
    id = "xxx-id"
    ids = ["id1", "id2"]
    name = "xxx-name"
  }
}
~~~

- テスト実行部分

~~~shell
# runの次がテスト名
run "test_name" {
  command = plan  # planコマンドでテスト

  # モック用プロバイダを使用
  providers = {
    aws = aws.fake
  }

  # assertで結果を確認(assertを複数書くことも可能)
  assert {
    condition     = aws_xxx.id == "hogehoge" # 結果比較
    error_message = "Error!"                 # 結果が違う場合の表示メッセージ
  }
}
~~~

上記をまとめたテスト例は以下のようになります。

~~~shell
# --- モックを含むテストの例 ---

# モック用プロバイダ
mock_provider "aws" {
  alias = "fake"
}

# dataの内容をモックの値で上書き
override_data {
  target = data.aws_vpc.search # 対象リソース
  # モックで返す値
  values = {
    # VPCのidしか使わないのでidのみをモックにする
    id = "vpc-mock-id"
  }
}

# テスト実行
run "subnet_test" {
  command = plan  # planコマンドでテスト

  # モック用プロバイダを使用
  providers = {
    aws = aws.fake
  }

  assert {
    # 作成したsn1のサブネットのVPC IDがモック通りかを確認
    condition = aws_subnet.sn1.vpc_id == "vpc-mock-id"
    error_message = "aws_subnet sn1 create Error!"
  }
}
~~~

## ディレクトリ構成

~~~shell
tf_mock_test/
├── main.tf            # terraformバージョンなどの設定(モック無関係)
├── subnet.tf          # サブネット作成(VPC検索がモック対象)
├── db_subnet_group.tf # DBサブネットグループ作成(サブネット検索がモック対象)
|
└── tests/
    ├── subnet.tftest.hcl          # subnet.tfのテスト(VPC検索をモックにしている)
    └── db_subnet_group.tftest.hcl # db_subnet_group.tfのテスト(サブネット検索をモックにしている)
~~~

## モックサンプルの実行方法

前提として、TerraformとAWS CLIの設定が完了して各種コマンドが実行できる状態にしておいてください。

mock_test_tfディレクトリに移動します。

~~~shell
cd mock_test_tf
~~~

initしてルートモジュールとして初期化します。

~~~shell
terraform init
~~~

ルートモジュール直下で以下のコマンドを叩くとテストが実行されます。

~~~shell
terraform test
~~~

