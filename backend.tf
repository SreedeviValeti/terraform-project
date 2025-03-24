terraform {
  backend "s3" {
    bucket       = "terraform-remote-state-file"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
