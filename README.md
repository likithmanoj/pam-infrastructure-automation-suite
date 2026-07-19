# PAM Infrastructure Automation Suite

> A security automation platform for provisioning, auditing, and migrating Non-Human Identities (NHIs) across enterprise Privileged Access Management (PAM) and cloud environments.

---

## Overview

PAM Infrastructure Automation Suite is a long-term engineering project focused on automating the lifecycle of Non-Human Identities (NHIs), including service accounts, machine identities, API keys, and application credentials.

The project combines Infrastructure as Code, cloud security, and Python automation to build reusable tooling inspired by real-world enterprise Identity and Access Management (IAM) and Privileged Access Management (PAM) operations.

---

# Why This Project Exists

Enterprise environments often manage thousands of non-human identities across cloud platforms and privileged access management solutions.

These identities are frequently:

- Created manually
- Managed through support tickets
- Audited using spreadsheets
- Over-permissioned
- Poorly documented
- Rotated inconsistently
- Difficult to migrate between PAM platforms

This project aims to automate those operational workflows using modern cloud-native technologies while following security engineering best practices.

---

# Current Features

## Infrastructure Provisioning

- AWS IAM User provisioning
- IAM Roles
- IAM Trust Policies
- IAM Permission Policies
- IAM Role Policy Attachments
- Environment-based deployments
- Dynamic naming conventions

## Amazon S3

- Bucket provisioning
- Public Access Block configuration
- Secure infrastructure defaults

## Python Automation

- boto3 integration
- Automated S3 uploads
- Environment variable configuration
- Error handling

## Security

- Least Privilege IAM Policies
- Infrastructure as Code
- IAM path separation
- Trust-based role assumption
- Security-first resource provisioning

---

# Project Architecture

```text
Terraform
      │
      ▼
AWS Infrastructure
      │
      ├── IAM User
      ├── IAM Role
      ├── IAM Policies
      └── Amazon S3
              │
              ▼
Python (boto3)
              │
              ▼
AWS APIs
```

---

# Repository Structure

```text
terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── terraform.tfvars

automation_test.py
README.md
.gitignore
```

---

# Roadmap

## Phase 1 — AWS Infrastructure Foundation

### Completed

- AWS IAM User provisioning
- IAM Policy creation
- IAM Role implementation
- Trust Policy implementation
- Role Policy Attachments
- Amazon S3 provisioning
- Public Access Block configuration
- Python boto3 integration
- Environment parameterization

### In Progress

- Remove unnecessary IAM permissions
- Configure S3 Server-Side Encryption
- Remote Terraform State (S3 Backend)
- DynamoDB State Locking
- AWS STS AssumeRole
- Replace long-lived IAM User credentials with IAM Roles

---

## Phase 2 — CyberArk Foundation

- Authentication
- Safe discovery
- Account discovery
- Mock CyberArk API client
- JSON export

---

## Phase 3 — NHI Audit Scanner

Python-based security audit engine capable of identifying:

- Dormant identities
- Over-privileged IAM policies
- Wildcard permissions
- Missing credential rotation
- Risk findings exported as JSON

---

## Phase 4 — Migration Toolkit

Migration workflows for enterprise PAM platforms.

Planned support includes:

- CyberArk → AWS Secrets Manager
- CyberArk → HashiCorp Vault

---

## Phase 5 — Production Readiness

- Terraform Modules
- Unit Tests
- Logging
- CI/CD
- Architecture Documentation

---

# Engineering Principles

This project is built around:

- Infrastructure as Code
- Least Privilege
- Secure by Default
- Zero Trust
- Reusable Automation
- Environment Isolation
- Modular Infrastructure

---

# Project Goals

- Automate provisioning of non-human identities
- Reduce manual IAM and PAM administration
- Build reusable Terraform modules
- Automate cloud security tasks using Python
- Demonstrate production-oriented security engineering practices
- Explore migration paths between enterprise PAM platforms and cloud-native identity services

---

# Current Status

**Status:** Active Development

This repository is developed incrementally, with new functionality added and documented throughout each development phase.

The roadmap and README are reviewed and updated approximately every two weeks.