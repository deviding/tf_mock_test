# --- サブネット作成 ---

# VPCを検索
# (モックにしたいものはdataでの検索で書いておくのが良さそう)
data "aws_vpc" "search" {
  filter {
    name   = "tag:Name"
    values = ["vpc-main"]
  }
}

# 検索結果のVPCにサブネット1を作成
resource "aws_subnet" "sn1" {
  vpc_id            = data.aws_vpc.search.id

  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sn1-tagname"
  }
}

# 検索結果のVPCにサブネット2を作成
resource "aws_subnet" "sn2" {
  vpc_id            = data.aws_vpc.search.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sn2-tagname"
  }
}
