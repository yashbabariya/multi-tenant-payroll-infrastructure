# 🤖 AI Usage Log

## Overview

AI tools were used during this assignment to accelerate development, validate architectural decisions, and improve security practices. All outputs were reviewed, modified, and adapted based on real-world DevOps knowledge.

---

## 🔹 Prompt 1 — Terraform AWS Infrastructure

**Prompt:**

> Generate Terraform code for AWS infrastructure with EC2, RDS, S3, IAM roles for multi-tenant system.

**AI Response:**

* Provided base Terraform structure for EC2, RDS, S3, IAM.

**What I Changed:**

* Introduced bastion host for secure SSH
* Added security groups for tenant isolation
* Integrated IAM roles per tenant

**Reason:**
To align with security-first architecture and assignment requirements.

---

## 🔹 Prompt 2 — Multi-Tenancy Design

**Prompt:**

> Design multi-tenancy architecture for payroll system with strict isolation.

**AI Response:**

* Suggested shared DB and schema-per-tenant options

**What I Chose:**

* Schema-per-tenant model

**What I Modified:**

* Added JWT-based tenant context propagation
* Implemented schema switching using `SET search_path`
* Added infrastructure-level isolation (IAM + S3)

**Reason:**
Schema-per-tenant provides strong isolation with better cost efficiency.

---

## 🔹 Prompt 3 — Secure RDS Setup

**Prompt:**

> Generate secure RDS Terraform configuration.

**AI Response:**

* Basic RDS setup with encryption

**What I Improved:**

* Added Secrets Manager integration
* Restricted access via security groups
* Disabled public access (or restricted via IP when required)
* Enabled logging and backups

**Reason:**
To meet security and compliance requirements for sensitive payroll data.

---

## 🔹 Prompt 4 — CI/CD Pipeline

**Prompt:**

> Create CI/CD pipeline for Docker build and deploy to EC2.

**AI Response:**

* Provided basic GitHub Actions with SSH deployment

**What I Improved:**

* Replaced SSH with AWS SSM
* Integrated OIDC authentication (no static credentials)
* Used Amazon ECR instead of DockerHub
* Added multi-instance deployment using tags

**Reason:**
To achieve secure, scalable, and production-grade deployment.

---

## 🔹 Prompt 5 — Secrets Management

**Prompt:**

> How to use AWS Secrets Manager with application.

**AI Response:**

* Provided secret creation and retrieval

**What I Modified:**

* Integrated with EC2 IAM roles
* Injected secrets as environment variables at runtime
* Avoided storing secrets in code or CI/CD

**Reason:**
To ensure secure handling of sensitive credentials.

---

## 🔹 Prompt 6 — Bastion Host Setup

**Prompt:**

> Create bastion host architecture for accessing private EC2.

**AI Response:**

* Provided basic bastion host setup

**What I Improved:**

* Restricted SSH access to specific IP
* Allowed private instances access only via bastion
* Suggested SSM as alternative

**Reason:**
To enforce strong network security.

---

## 🔹 Prompt 7 — Architecture Diagram

**Prompt:**

> Generate AWS architecture diagram for multi-tenant system.

**AI Response:**

* Provided base visual representation

**What I Modified:**

* Ensured inclusion of:

  * CI/CD pipeline (GitHub → ECR → SSM)
  * Multi-tenant EC2 instances
  * RDS (schema-per-tenant)
  * S3 storage
* Aligned diagram with Terraform implementation

**Reason:**
To match assignment requirements and real architecture.

---

## 🔹 Prompt 8 — README Documentation

**Prompt:**

> Generate complete README for multi-tenant DevOps Task.

**AI Response:**

* Provided structured documentation

**What I Improved:**

* Added detailed explanations for:

  * Security decisions
  * Multi-tenancy model
  * CI/CD workflow
  * GDPR compliance
* Simplified language for clarity

**Reason:**
To make documentation professional and easy to review.

---

## 🔹 Prompt 10 — Project Structure & README Enhancements

**Prompt:**

> How to generate project tree structure and include in README.

**AI Response:**

* Suggested using `tree` command

**What I Applied:**

* Cleaned structure output
* Removed unnecessary folders (`node_modules`, `.terraform`)

**Reason:**
To improve readability and presentation.

---

## 🧠 Summary

AI was used as a **support tool**, not a replacement for decision-making.

Key contributions:

* Accelerated Terraform and CI/CD development
* Suggested best practices
* Helped refine architecture

All outputs were:

* Reviewed
* Modified
* Validated against real-world DevOps practices

---

# 🏆 Final Note

The final solution reflects a **security-first, production-ready architecture** with thoughtful use of AI to enhance productivity while maintaining engineering judgment.