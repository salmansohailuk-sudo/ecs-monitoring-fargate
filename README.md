# ECS-FrontEnd-Backend-Monitoring-Demo

Learning project for deploying a frontend, Python backend, monitoring stack, and Grafana on Amazon ECS Fargate.

## Services

- Frontend: Nginx plus Nginx exporter.
- Backend: Python application on port 5000.
- Monitoring: Prometheus plus CloudWatch exporter.
- Grafana: Provisioned monitoring dashboard.

## Important architecture decisions

- Docker is not required on the local laptop.
- GitHub Actions builds the four Docker images on hosted runners.
- Images are pushed to Amazon ECR.
- Terraform creates the AWS infrastructure.
- The frontend is public through an Application Load Balancer.
- Backend, Prometheus, CloudWatch exporter, and Grafana are private.
- Cloud Map provides private service discovery.
- OIDC is intentionally not used for this demonstration.
- GitHub Actions uses encrypted AWS repository secrets.

## Required GitHub secrets

Create these under:

Repository → Settings → Secrets and variables → Actions → Secrets

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

Create this repository variable:

- AWS_REGION = eu-west-2

## Deployment sequence

1. Create the GitHub repository.
2. Copy the application files into the repository.
3. Copy the Terraform files into the repository.
4. Copy `terraform.tfvars.example` to `terraform.tfvars`.
5. Edit `terraform.tfvars`.
6. Run Terraform formatting and validation.
7. Apply Terraform to create AWS resources and ECR repositories.
8. Add the GitHub Actions secrets.
9. Add the GitHub Actions workflow.
10. Push the workflow to the `main` branch.
11. Run the GitHub Actions workflow.
12. Confirm that all four images exist in ECR.
13. Apply Terraform with the successful commit SHA.
14. Check the ECS services.
15. Check ALB target health.
16. Open the ALB DNS name.
17. Verify Prometheus targets.
18. Verify the Grafana dashboard.
19. Destroy the sandbox when finished.

## Terraform commands

```bash
terraform -chdir=terraform init
terraform -chdir=terraform fmt -recursive
terraform -chdir=terraform validate
terraform -chdir=terraform plan
terraform -chdir=terraform apply
```

After the image build succeeds:

```bash
terraform -chdir=terraform apply \
  -var="image_tag=YOUR_COMMIT_SHA"
```

Destroy the sandbox:

```bash
terraform -chdir=terraform destroy
```

## Private service names

- frontend.ecs-test.local
- backend.ecs-test.local
- monitoring.ecs-test.local
- grafana.ecs-test.local

## Public access

Only the frontend is public through the ALB.

Prometheus and Grafana remain private in this initial version.