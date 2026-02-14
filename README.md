# mathtrail-service-template
Golden template for creating new MathTrail microservices — provides the standard `infra/` layout, Dockerfile, Helm chart, Skaffold config, justfile, devcontainer, and CI/CD workflows.

## Purpose
Clone this repo to bootstrap a new service with all infrastructure pre-configured:
- Helm chart depending on `mathtrail-service-lib`
- Multi-environment values (dev, on-prem, cloud)
- ExternalSecret template for Vault integration
- Terraform modules (database abstraction)
- Ansible playbook (on-prem node preparation)
- GitHub Actions workflow (chart publishing)
- Skaffold pipeline (local dev + deploy)
- DevContainer configuration

## Standard Directory Layout
```
mathtrail-<service>/
├── cmd/server/              # Application entry point
├── internal/                # Internal packages
├── Dockerfile               # Multi-stage: builder → alpine
├── skaffold.yaml            # Skaffold pipeline
├── justfile                 # Automation recipes
├── infra/
│   ├── helm/
│   │   ├── <service>/       # Helm chart (depends on service-lib)
│   │   ├── values-dev.yaml
│   │   ├── values-on-prem.yaml
│   │   └── values-cloud.yaml
│   ├── terraform/
│   │   ├── modules/database/
│   │   └── environments/
│   └── ansible/
│       └── playbooks/setup.yml
├── .github/workflows/release-chart.yml
├── .devcontainer/
└── .claude/CLAUDE.md
```

## Usage
1. Clone this repo as your new service name
2. Replace all placeholder values (MATHTRAIL_SERVICE_NAME)
3. Run `just dev` to verify everything works
