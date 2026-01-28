Secure Compute Foundations (AWS)
Lab 2.1 — Secure VPC Layout & Private Compute
Phase

Phase 2 — Secure Compute Foundations

Objective

This lab establishes a production-grade secure compute foundation on AWS by building a properly segmented VPC, deploying private compute, and enabling Zero-Trust-ready access and network telemetry.

By the end of this lab, you will have a VPC design that prevents direct internet exposure of compute, supports controlled outbound access, and forms the baseline for identity-driven security and attack-path analysis in later phases.

What You Will Build

A secure AWS network and compute foundation with:

Multi-AZ VPC (2 Availability Zones)

Public subnets (NAT + optional bastion only)

Private application subnets (compute lives here)

Optional private data subnets (restricted backend zone)

NAT Gateway for controlled outbound access

Security Groups with least-privilege rules

Optional NACL hardening

Zero-Trust-ready access using AWS SSM Session Manager

VPC Flow Logs for network telemetry

Architecture Summary

Design intent:

No public IPs on application compute

Explicit routing and trust boundaries

Egress allowed, ingress tightly controlled

Access via identity, not network exposure

This architecture is intentionally conservative and mirrors real production environments.

Prerequisites

AWS account with VPC and EC2 permissions

Chosen AWS Region (example: us-east-1)

Phase 1 identity completed (recommended, not required)

Optional: EC2 key pair (only if testing SSH/bastion access)

Step 1 — Create the VPC (10 minutes)
1.1 Create VPC

CIDR: 10.20.0.0/16

Name: stc-p2-vpc

Tenancy: Default

AWS Console → VPC → Your VPCs → Create VPC

1.2 Create Internet Gateway

Name: stc-p2-igw

Attach to: stc-p2-vpc

Step 2 — Create Subnets (15 minutes)

Use two Availability Zones (example: us-east-1a, us-east-1b).

Public Subnets (NAT / Bastion Only)
Name	CIDR	AZ
stc-p2-public-a	10.20.1.0/24	AZ A
stc-p2-public-b	10.20.2.0/24	AZ B
Private App Subnets (Compute)
Name	CIDR	AZ
stc-p2-private-app-a	10.20.11.0/24	AZ A
stc-p2-private-app-b	10.20.12.0/24	AZ B
Optional: Private Data Subnets (Stricter)
Name	CIDR	AZ
stc-p2-private-data-a	10.20.21.0/24	AZ A
stc-p2-private-data-b	10.20.22.0/24	AZ B

✅ Rule: Private subnets must not auto-assign public IPv4 addresses.

Step 3 — Route Tables (15 minutes)
3.1 Public Route Table

Name: stc-p2-rt-public

Associated with public subnets

Routes:

10.20.0.0/16 → local

0.0.0.0/0 → Internet Gateway

3.2 NAT Gateway (Private Egress)

Subnet: stc-p2-public-a

Allocate Elastic IP

Name: stc-p2-nat-a

(Optional: second NAT for HA later)

3.3 Private App Route Table

Name: stc-p2-rt-private-app

Associated with private app subnets

Routes:

10.20.0.0/16 → local

0.0.0.0/0 → NAT Gateway

3.4 Private Data Route Table (Optional)

Name: stc-p2-rt-private-data

No default internet route

Creates a restricted backend zone

Step 4 — Security Groups (10 minutes)
4.1 Bastion Security Group (Optional)

Name: stc-p2-sg-bastion

Inbound:

SSH (22) from your IP only

Outbound:

Allow all (initially)

4.2 App Security Group (Private Compute)

Name: stc-p2-sg-app

Inbound:

SSH only from Bastion SG (or none if using SSM)

Optional: HTTP 80 from VPC CIDR

Outbound:

Allow required egress

✅ Key principle: No inbound access from the internet.

Step 5 — NACLs (Optional, Recommended Later)

Start with Security Groups first.

Optional hardening:

Public NACL: allow 80/443, ephemeral ports

Private App NACL: allow VPC-internal traffic + outbound 80/443

Step 6 — Launch Private Compute (15 minutes)
6.1 Launch App EC2 (Private)

Subnet: stc-p2-private-app-a

Public IP: Disabled

SG: stc-p2-sg-app

IAM Role: SSM-enabled role (next step)

6.2 Optional Bastion

Subnet: stc-p2-public-a

Public IP: Enabled

SG: stc-p2-sg-bastion

Step 7 — Zero-Trust-Ready Access (SSM) (10 minutes)
7.1 Create IAM Role

Service: EC2

Policy: AmazonSSMManagedInstanceCore

Name: stc-p2-ec2-ssm-role

Attach to private app EC2.

7.2 Validate Access

Systems Manager → Session Manager
Instance should appear as Managed.

✅ This replaces SSH and is your Phase 2 bridge into Zero Trust.

Step 8 — Enable VPC Flow Logs (10 minutes)

Destination: CloudWatch Logs

Log Group: /stc/p2/vpc-flowlogs

Filter: All

Generate traffic from the instance and confirm logs appear.

Step 9 — Validation Checklist

✅ No public IPs on app instances
✅ Private instances reach internet via NAT
✅ No inbound from 0.0.0.0/0 to app SG
✅ SSM access works
✅ Flow Logs show traffic
✅ Route tables match intent

Outcome

You now have a secure, production-style compute foundation that:

Enforces least privilege at the network layer

Supports Zero Trust access models

Generates telemetry for later analysis

Is compatible with attack-path reasoning and consulting assessments

Academy Mapping

This lab feeds:

Lab 2.1: Secure VPC layout

Lab 2.2: Private compute + NAT egress

Lab 2.3: Bastion vs Zero Trust (SSM)

Lab 2.4: VPC Flow Logs telemetry

Each lab is isolated, ordered, and metadata-governed.
