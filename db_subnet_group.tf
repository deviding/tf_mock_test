# --- DBサブネットグループ作成 ---

# DBサブネットグループの対象となるサブネットを検索
# (モックにしたいものはdataでの検索で書いておくのが良さそう)
data "aws_subnets" "search" {
  filter {
    name   = "tag:Name"
    values = ["sn1", "sn2"]
  }
}

# DBサブネットグループ作成
resource "aws_db_subnet_group" "db_sng" {
  name       = "db-sng"
  subnet_ids = data.aws_subnets.search.ids

  tags = {
    Name = "db-sng-tagname"
  }
}
