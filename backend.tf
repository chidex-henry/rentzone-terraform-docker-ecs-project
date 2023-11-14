# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "chidex-terraform-remote-state2"
    key            = "rentzone/terraform.tfstate"
    region         = "us-east-1"
    profile        = "terraform-user"
    dynamodb_table = "terraform-state-lock"
  }
}