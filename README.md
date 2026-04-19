Azure Cloud Security Hardening: Cross-Region Private Link Integration
🚀 Project Overview
This project demonstrates the transition from a "Public-Facing" storage configuration to a Zero-Trust architecture. I intentionally deployed an "Insecure by Design" Storage Account and remediated it by implementing Private Link, disabling Shared Keys, and enforcing identity-based access (RBAC) across different Azure regions.

🛠️ Tools & Technologies

Azure Networking: Virtual Network (VNet), VNet Peering, Private Endpoints.

Azure Security: Microsoft Defender for Cloud, RBAC (IAM), Private DNS Zones.

Monitoring: Log Analytics Workspace, Kusto Query Language (KQL).

Compute: Azure Bastion, Windows Server 2022 (Test Agent).

🛑 Phase 1: The Vulnerability (Creation)
I deployed a Storage Account (insecurestorage1) in Sweden Central with the following security flaws:

Public Access Enabled: Data was accessible to anonymous users over the internet.

Shared Key Access: Allowed access via a "Master Password," which is prone to leakage and lacks an audit trail.

Public Data Plane: The storage endpoint was reachable via a public IP address.

🔍 Phase 2: Detection
Using Microsoft Defender for Cloud, I identified the following critical misconfigurations:

Recommendation: "Storage account should use a private link connection"

Recommendation: "Storage accounts should prevent shared key access"

Recommendation: "Storage accounts should restrict network access using virtual network rules"

🛡️ Phase 3: Hardening (The Fix)

I executed a multi-layer remediation strategy to secure the environment:

Identity Hardening:

Disabled Shared Key Access to enforce modern Microsoft Entra ID (RBAC) authentication.

Assigned the Storage Blob Data Owner role to specific users to ensure the "Principle of Least Privilege."

Network Hardening:

Deployed a Private Endpoint in a Sweden VNet.

Configured Global VNet Peering between the North Europe VNet (VM) and the Sweden VNet (Storage).

Integrated a Private DNS Zone to ensure internal name resolution.

Transport Security:

Enforced TLS 1.2 and "Secure Transfer Required."

🧪 Phase 4: Verification (The "Evidence")
I verified the hardening from a test VM (192.168.1.4) in North Europe:

1. Network Validation (DNS)
Running nslookup confirmed the storage URL resolved to a Private IP (10.x.x.x) instead of the public internet.

3. Identity Validation (RBAC)
Anonymous Access: Attempting to view the file via a direct browser link resulted in a 409 Forbidden/AuthorizationFailure error (Expected behavior).

Authenticated Access: Successfully viewed the data using the Storage Browser inside the VM, which uses Entra ID tokens over the Private Link.

3. Log Audit (Log Analytics)
I used Kusto (KQL) to query the StorageBlobLogs table. The logs successfully captured the internal IP of the VM (192.168.1.4) as the source of traffic, proving the public internet was completely bypassed.

Code snippet
StorageBlobLogs
| where TimeGenerated > ago(1h)
| project TimeGenerated, OperationName, StatusCode, CallerIpAddress, AuthenticationType

🏆 Final Results
Attack Surface: Reduced from Public Internet to a Private VNet.

Authentication: Shifted from "Shared Secrets" to "Identity-Based RBAC."

Auditability: 100% of data plane actions are now logged in Log Analytics for forensic review.
