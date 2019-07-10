provider "aws" {
  region = "${var.requester_region}"

  # Requester's credentials.
  access_key = "${var.requester_aws_access_key}"
  secret_key = "${var.requester_aws_secret_key}"
}

provider "aws" {
  alias  = "peer"
  region = "${var.accepter_region}"

  # Accepter's credentials.
  access_key = "${var.accepter_aws_access_key}"
  secret_key = "${var.accepter_aws_secret_key}"
}
