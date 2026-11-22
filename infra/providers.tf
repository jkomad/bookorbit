# specify provider and access details 
provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]

  default_tags {
    tags = {
      Project   = "bookorbit"
      ManagedBy = "terraform"
    }
  }
}

