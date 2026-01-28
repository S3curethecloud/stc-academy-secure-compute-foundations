# Lab 2.4 — VPC Flow Logs as Security Telemetry

**Phase 2 — Secure Compute Foundations (STC Academy)**

---

## 🎯 Lab Objective

In this lab, you will enable **VPC Flow Logs** and learn how to use them as **security telemetry**, not just networking data.

You will observe:

- Allowed traffic
- Rejected traffic
- Directional flow patterns

This lab closes Phase 2 by providing **visibility into the secure compute environment** you built.

---

## 🧠 Why This Lab Matters

Security controls without visibility create **false confidence**.

VPC Flow Logs allow you to:

- Verify that network intent is being enforced
- Detect unexpected access patterns
- Support investigations and threat detection

This is **foundational telemetry** for any secure cloud environment.

---

## 🧱 Architecture Outcome

By the end of this lab, you will have:

- VPC Flow Logs enabled at the VPC level
- Logs delivered to CloudWatch Logs
- Visibility into accepted and rejected traffic
- A baseline for detection and response

---

## 📦 Prerequisites

- Completion of **Labs 2.1 – 2.3**
- Active VPC with subnets and route tables
- At least one EC2 instance generating traffic

---

## 🪜 Step-by-Step Implementation

### Step 1 — Create IAM Role for Flow Logs

Navigate to:  
**IAM → Roles → Create role**

- **Trusted entity:** VPC Flow Logs  
- **Permissions:** `CloudWatchLogsFullAccess`

**Role name:**
stc-p2-vpc-flowlogs-role


📌 This role allows VPC Flow Logs to publish logs to CloudWatch.

---

### Step 2 — Enable VPC Flow Logs

Navigate to:  
**VPC → Your VPCs**

- Select `stc-p2-vpc`
- Open **Flow Logs** → **Create flow log**

Configure:

| Setting | Value |
|------|------|
| Filter | All |
| Destination | CloudWatch Logs |
| Log group | `/stc/p2/vpc-flowlogs` |
| IAM role | `stc-p2-vpc-flowlogs-role` |

---

### Step 3 — Generate Network Traffic

From your private EC2 instance (via SSM):

```bash
curl https://example.com
Optional:

sudo yum update -y
📌 ICMP (ping) may be blocked — this is expected.

Step 4 — Analyze Flow Logs
Navigate to:
CloudWatch → Logs → Log groups → /stc/p2/vpc-flowlogs

You will see entries similar to:

ACCEPT OK
REJECT NODATA
Key fields to observe:

Source IP

Destination IP

Port

Action (ACCEPT / REJECT)

Direction

🔍 Interpreting Flow Logs (Security View)
ACCEPT
Traffic allowed by SG + NACL + routing

Expected outbound NAT traffic

Controlled internal communication

REJECT
Blocked inbound attempts

Misconfigured routing

Security Group enforcement

📌 Rejected traffic is often more valuable than accepted traffic.

🔐 Security Design Principles Applied
This lab enforces:

Visibility before response

Telemetry-driven security

Verification of routing intent

Evidence-based security decisions

✅ Validation Checklist
Confirm all of the following:

 Flow logs enabled on the VPC

 Logs delivered to CloudWatch

 Both ACCEPT and REJECT events visible

 Traffic aligns with expected architecture

 No unexpected inbound flows observed

If traffic surprises you — investigate. That’s the point.

🧠 What You Just Built (Phase 2 Summary)
Across Phase 2, you built:

A tiered VPC architecture

Default-deny private compute

Identity-native access (Zero Trust ready)

Network telemetry for security visibility

This is a production-grade secure compute foundation.
