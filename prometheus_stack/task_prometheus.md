**TASK / SYSTEM REQUIREMENT**

**Grafana Monitoring Platform Installation**

_Assigned to: System Administrator_

| **Field** | **Details** |
| --- | --- |
| Document ID | OPS-MON-001 |
| Issued Date | April 15, 2026 |
| Priority | High |
| Assigned To | System Administrator |
| Requested By | Operations / Infrastructure Team |
| Target Completion | To be agreed with assignee |
| Related System | All Production & Staging Virtual Machines |

# 1\. Objective

Deploy Grafana as the centralised monitoring and observability platform for all virtual machines (VMs) in the organisation's infrastructure. This includes installing the Grafana server, provisioning monitoring agents on every VM, and configuring dashboards to provide real-time visibility into system health, resource utilisation, and performance metrics.

# 2\. Scope

## 2.1 In Scope

- Installation and configuration of the Grafana server on a dedicated monitoring host.
- Deployment of Prometheus Node Exporter agent on all Linux VMs.
- Configuration of Prometheus as the data source connected to Grafana.
- Creation of baseline dashboards covering CPU, memory, disk, and network metrics.
- Alert rule setup for critical thresholds (CPU > 85%, disk > 80%, memory > 90%).
- Documentation of all scripts, configurations, and runbooks.

## 2.2 Out of Scope

- Application-level APM (Application Performance Monitoring).
- Log aggregation (to be addressed in a separate task).
- Cloud-managed Grafana Cloud or SaaS deployments.

# 3\. Required Deliverables

The System Administrator must produce and deliver the following artefacts:

| **#** | **Deliverable** | **Description** |
| --- | --- | --- |
| 1   | grafana_server_install.sh | Bash script to install and configure Grafana server on the monitoring host (Linux). |
| 2   | node_exporter_install.sh | Bash script to install and configure Prometheus Node Exporter on each Linux VM. |
| 4   | prometheus_install.sh | Bash script to install Prometheus and configure scrape targets for all VM agents. |
| 5   | grafana_alloy_install.sh ? | Script to deploy Grafana Alloy agent as an alternative/supplement collector. |
| 6   | dashboard_provisioning/ | Grafana dashboard JSON files (Node Overview, Disk, Network, Summary) ready for import. |
| 7   | alert_rules.yml | Prometheus alerting rules file covering critical system thresholds. |
| 8   | README.md | Installation and runbook guide: prerequisites, execution order, rollback steps, and maintenance notes. |

# 4\. Technical Requirements

## 4.1 Grafana Server

- Latest stable Grafana OSS release (v10+ recommended).
- Installed as a docker container; auto-start on boot.
- Accessible via HTTPS on port 3000 (TLS/self signed certificate or reverse proxy).
- Admin credentials stored securely (not hardcoded in scripts). May asked to enter on installation
- Data source: Prometheus configured and tested automatically via provisioning file.

## 4.2 Prometheus

- Installed on the monitoring host alongside Grafana.
- Scrape interval: 15 seconds (configurable).
- Retention: 10-30 days (configurable via --storage.tsdb.retention.time flag).
- Scrape targets: dynamically generated from a VM inventory list (YAML or CSV input).
- Alertmanager integration for email/Telegram notifications.

## 4.3 Node Exporter (Linux VMs)

- Latest stable release from the Prometheus project.
- Runs as a dedicated system user (non-root) with minimum required permissions.
- Listens on port 9100 (default); firewall rule to allow access only from the Prometheus host.
- Enabled collectors: cpu, meminfo, diskstats, filesystem, netdev, loadavg, uname.

## 4.5 Networking & Security

- All agent ports (9100, 9182) must be restricted to the Prometheus server IP only.
- Grafana accessible only via internal network or VPN; no direct internet exposure.
- Service accounts used for agents must not have interactive login rights.

# 5\. Script Standards & Quality Requirements

All scripts must comply with the following standards:

- **Each script must be safely re-runnable without causing errors or duplicate installations.** Idempotency:
- **Scripts must exit on any unhandled error (set -euo pipefail for Bash; $ErrorActionPreference = 'Stop' for PowerShell).** Error handling:
- **All steps must write timestamped log entries to /var/log/grafana_install.log (Linux).** Logging:
- **Host IPs, ports, and credentials must be passed as arguments or environment variables — no hardcoded values.** Parameterisation:
- **Scripts must install specific, tested versions. Version variables must be declared at the top of each script.** Version pinning:
- **A corresponding uninstall/rollback script or function must be provided for each component.** Rollback:
- **Linux scripts must support Debian 13 and Ubuntu 22.04/24.04.**

# 6\. Acceptance Criteria

The task is considered complete when ALL of the following are verified:

| **#** | **Acceptance Criterion** | **Verification Method** |
| --- | --- | --- |
| 1   | Grafana UI is accessible and displays the login screen. | Browser access test. |
| 2   | Prometheus data source is connected with 'Data source connected and labels found.' | Grafana Data Sources panel. |
| 3   | All VMs appear as targets in Prometheus with status 'UP'. | Prometheus /targets page. |
| 4   | Node Overview dashboard shows live metrics for all VMs. | Visual inspection of dashboards. |
| 5   | Disk alert fires correctly when threshold is simulated. | Alert test using stress tool or manual threshold change. |
| 6   | All scripts execute without errors on a freshly provisioned VM. | Test run on clean VM. |
| 7   | README.md is complete with all sections documented. | Document review. |
| 8   | No credentials are hardcoded in any script. | Code review / grep for secrets. |

# 7\. Suggested Timeline

| **Phase** | **Task** | **Est. Duration** |
| --- | --- | --- |
| Phase 1 | Environment assessment: inventory all VMs, OS types, network topology. | 1 day |
| Phase 2 | Install & configure Grafana server and Prometheus on monitoring host. | 1 day |
| Phase 3 | Develop and test Node Exporter install script on a single Linux VM. | 1 day |
| Phase 4 | Roll out Node Exporter agent to all Linux VMs. | 1–2 days |
| Phase 5 | Develop and test Windows Exporter script (if Windows VMs exist). | 1 day |
| Phase 6 | Configure dashboards, alert rules, and notification channels. | 1 day |
| Phase 7 | Testing, documentation, and handover. | 1 day |

# 8\. References & Resources

- Grafana Documentation: https://grafana.com/docs/grafana/latest/
- Prometheus Node Exporter: https://github.com/prometheus/node_exporter
- Windows Exporter: https://github.com/prometheus-community/windows_exporter
- Grafana Alloy Agent: https://grafana.com/docs/alloy/latest/
- Prometheus Getting Started: https://prometheus.io/docs/introduction/getting_started/

# 9\. Notes & Assumptions

- The monitoring host must have a minimum of 4 vCPUs, 8 GB RAM, and 100 GB storage.
- The assignee should flag any VMs with non-standard OS versions before starting.
- Firewall rule changes must be coordinated with the network team prior to deployment.
- Secrets (passwords, tokens) must be stored in the organisation's secrets manager or passed via CI/CD environment variables.
