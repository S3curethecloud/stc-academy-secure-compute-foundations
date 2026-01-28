# Lab 2.1 — Secure VPC Layout & Network Tiering

**Phase 2 — Secure Compute Foundations (STC Academy)**

---

## 🎯 Lab Objective

In this lab, you will design and implement a **production-grade VPC layout** that enforces:

- Network tiering
- Blast-radius reduction
- Explicit routing intent

You will **not deploy applications** yet — the focus is on **foundational structure**, not workloads.

This lab establishes the **network substrate** that all secure compute depends on.

---

## 🧠 Why This Lab Matters

Most cloud breaches are not caused by “bad compute” — they are caused by:

- Flat networks  
- Overexposed subnets  
- Misaligned routing intent  
- Confusion between *reachability* and *authorization*  

This lab teaches you how to design the network so **mistakes are harder to make**.

---

## 🧱 Architecture Outcome

By the end of this lab, you will have:

- A dedicated VPC with a non-overlapping CIDR
- Public subnets used **only** for edge services
- Private subnets reserved for compute
- Clear routing separation between tiers
- A design that supports Zero Trust access later

---

## 📦 Prerequisites

- AWS account with VPC permissions
- One AWS region selected (example: `us-east-1`)
- Basic familiarity with AWS networking concepts

⚠️ **Do not switch regions mid-lab.**

---

## 🪜 Step-by-Step Implementation

### Step 1 — Create the VPC

Navigate to:  
**VPC → Your VPCs → Create VPC**
```
| Setting | Value |
|------|------|
| Name | `stc-p2-vpc` |
| IPv4 CIDR | `10.20.0.0/16` |
| Tenancy | Default |
```

✅ This CIDR allows clean subnet tiering without overlap.

---

### Step 2 — Create an Internet Gateway

Navigate to:  
**Internet Gateways → Create**

- **Name:** `stc-p2-igw`
- Attach to: `stc-p2-vpc`

📌 The IGW is **not exposure by itself** — routing controls exposure.

---

### Step 3 — Create Subnets (Tiered Design)

Use **two Availability Zones**.

#### Public Subnets (Edge Tier)

```
| Name | CIDR | AZ |
|----|----|----|
| stc-p2-public-a | 10.20.1.0/24 | AZ-A |
| stc-p2-public-b | 10.20.2.0/24 | AZ-B |
```
---

✔ Used for NAT Gateways or optional bastions  
❌ **Not** for application workloads

---

#### Private App Subnets (Compute Tier)
```
| Name | CIDR | AZ |
|----|----|----|
| stc-p2-private-app-a | 10.20.11.0/24 | AZ-A |
| stc-p2-private-app-b | 10.20.12.0/24 | AZ-B |
```
---
⚠️ **Disable auto-assign public IPv4** (mandatory)

---

#### (Optional) Private Data Subnets (Restricted Tier)
```
| Name | CIDR | AZ |
|----|----|----|
| stc-p2-private-data-a | 10.20.21.0/24 | AZ-A |
| stc-p2-private-data-b | 10.20.22.0/24 | AZ-B |
```
---

📌 These will later host databases or internal services.

---

## Step 4 — Create Route Tables

### Public Route Table

- **Name:** `stc-p2-rt-public`
- Associate with:
  - `stc-p2-public-a`
  - `stc-p2-public-b`
---
```
| Destination | Target |
|-----------|--------|
| 10.20.0.0/16 | local |
| 0.0.0.0/0 | Internet Gateway |
```
---
✅ Only public subnets should ever have this route.

---

### Private App Route Table (No Internet Gateway)

- **Name:** `stc-p2-rt-private-app`
- Associate with:
  - `stc-p2-private-app-a`
  - `stc-p2-private-app-b`

```
| Destination | Target |
|-----------|--------|
| 10.20.0.0/16 | local |
```
---

❌ No IGW route  
✔ Internet access will be added later via NAT (Lab 2.2)

---

### Private Data Route Table (Optional)

- Local routing only
- No internet access by default

This creates a **true restricted backend zone**.

---

## 🔐 Security Design Principles Applied

This lab enforces:

- Blast-radius reduction via subnet isolation
- Default-deny networking (no implicit internet access)
- Separation of concerns between edge, compute, and data
- Future Zero Trust readiness

---

## ✅ Validation Checklist

Confirm all of the following before proceeding:

- [ ] VPC CIDR is `10.20.0.0/16`
- [ ] Public subnets have an IGW route
- [ ] Private subnets have **no** IGW route
- [ ] Private subnets do **not** auto-assign public IPs
- [ ] Route tables align with subnet intent

If any item fails, fix it before moving on.

---

## 🧠 What You Just Built (Mental Model)

You did not build “a VPC”.

You built:

- A **security boundary**
- A **routing contract**
- A **foundation for Zero Trust compute**

Everything in later labs assumes this structure exists.
