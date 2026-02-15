# MathTrail Service CI/CD Contract
# ─────────────────────────────────────────────────────────────────────────────
# Every microservice MUST implement these recipes.
# The self-hosted runner calls them during CI workflows.
#
# Usage (called by GitHub Actions):
#   just ci-lint
#   just ci-test  pr-123
#   just ci-build pr-123
#   just ci-prepare pr-123
#   just ci-cleanup pr-123

set shell := ["bash", "-c"]

NAMESPACE := "mathtrail"
SERVICE   := "CHANGE_ME"

# -- CI/CD Contract ------------------------------------------------------------

# Lint the codebase
ci-lint:
    golangci-lint run ./...

# Run tests (unit + integration)
ci-test ns="":
    #!/bin/bash
    set -e
    if [ -n "{{ns}}" ]; then
        echo "Running tests targeting namespace {{ns}}..."
        NAMESPACE={{ns}} go test ./... -v -count=1
    else
        go test ./... -v -count=1
    fi

# Build the container image (no push — Skaffold handles it)
ci-build ns="":
    #!/bin/bash
    set -e
    echo "Building {{ SERVICE }}..."
    go build -o bin/server ./cmd/server

# Create an ephemeral namespace for a PR
ci-prepare ns:
    #!/bin/bash
    set -e
    echo "Creating namespace {{ns}}..."
    kubectl create namespace {{ns}} 2>/dev/null || true
    kubectl label namespace {{ns}} app.kubernetes.io/managed-by=ci --overwrite

# Delete an ephemeral namespace after PR merge/close
ci-cleanup ns:
    #!/bin/bash
    set -e
    echo "Deleting namespace {{ns}}..."
    kubectl delete namespace {{ns}} --wait=false 2>/dev/null || true
