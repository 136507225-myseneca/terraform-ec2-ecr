# Create an ECR Repository
resource "aws_ecr_repository" "Application" {
  name                 = "clo835-app" 
  image_tag_mutability = "MUTABLE"
}


resource "aws_ecr_repository" "Database" {
  name                 = "clo835-database" 
  image_tag_mutability = "MUTABLE"
}