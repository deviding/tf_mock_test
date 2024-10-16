##################################
# subnet用テスト
##################################

# モック用プロバイダ
mock_provider "aws" {
  alias = "fake"
}

# VPCの検索結果のモック
override_data {
  target = data.aws_vpc.search
  values = {
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

  assert {
    # 作成したsn1のサブネットのタグのNameが設定値通りかを確認
    condition = aws_subnet.sn1.tags["Name"] == "sn1-tagname"
    error_message = "aws_subnet sn1 create Error!"
  }

  assert {
    # 作成したsn2のサブネットのVPC IDがモック通りかを確認
    condition = aws_subnet.sn2.vpc_id == "vpc-mock-id"
    error_message = "aws_subnet sn2 create Error!"
  }

  assert {
    # 作成したsn2のサブネットのタグのNameが設定値通りかを確認
    condition = aws_subnet.sn2.tags["Name"] == "sn2-tagname"
    error_message = "aws_subnet sn2 create Error!"
  }

}