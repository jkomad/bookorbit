# Container registry for one of the pilot's images. Immutable tags match
# the CI convention (sha-<short>), so a re-push of the same commit is a no-op
# rather than an overwrite. Scan-on-push for a basic vulnerability signal.

resource "aws_ecr_repository" "this" {
  name                 = var.repo_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  # AES256 (S3-managed) rather than a CMK. Container images carry no PHI, and a
  # CMK here would force kms:Decrypt / kms:GenerateDataKey grants on both the
  # ECS execution role (pull) and the GitHub deploy role (push) or pulls/pushes
  # fail. AES256 is the AWS default and FedRAMP-acceptable for non-sensitive
  # artifacts. The data tier (RDS + Secrets) still uses the customer CMK.
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = { Name = var.repo_name }
}

# Keep the registry from growing without bound: expire untagged images and
# cap tagged history.
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep only the last 30 tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["sha-"]
          countType     = "imageCountMoreThan"
          countNumber   = var.keep_tagged
        }
        action = { type = "expire" }
      }
    ]
  })
}
