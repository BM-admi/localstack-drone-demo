module "whoami" {
  source = "./modules/whoami"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "test"
}
