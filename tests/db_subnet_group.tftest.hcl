##################################
# DBサブネットグループ用テスト
##################################

# モック用プロバイダ
mock_provider "aws" {
  alias = "fake"
}

# サブネット検索結果のモック
override_data {
  target = data.aws_subnets.search
  values = {
    ids = ["subnet-id-mock-1", "subnet-id-mock-2"]
  }
}

# テスト実行
run "aaws_db_subnet_group_test" {
  command = plan  # planコマンドでテスト

  # モック用プロバイダを使用
  providers = {
    aws = aws.fake
  }

  assert {
    # 作成したdb_sngのDBサブネットグループのsubnet_idsにsubnet-id-mock-1が含まれるか確認
    condition = contains(aws_db_subnet_group.db_sng.subnet_ids, "subnet-id-mock-1")
    error_message = "aws_db_subnet_group create Error!"
  }

  assert {
    # 作成したdb_sngのDBサブネットグループのsubnet_idsにsubnet-id-mock-2が含まれるか確認
    condition = contains(aws_db_subnet_group.db_sng.subnet_ids, "subnet-id-mock-2")
    error_message = "aws_db_subnet_group create Error!"
  }

  assert {
    # 作成したdb_sngのDBサブネットグループのタグのNameが設定値通りか確認
    condition = aws_db_subnet_group.db_sng.tags["Name"] == "db-sng-tagname"
    error_message = "aws_db_subnet_group create Error!"
  }
}