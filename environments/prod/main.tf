module "app" {
  source = "../../modules/app"

  region            = var.region
  app_name          = var.app_name
  db_size           = var.db_size
  db_engine_version = var.db_engine_version
}
