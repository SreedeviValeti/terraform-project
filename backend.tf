terraform {
    backend "s3" {
        bucket = "terraform-remote-state-file"
        key = "terraform.tfstate"
        region = "us-east-2"
        profile = "default"
        use_lockfile = true
    }
}