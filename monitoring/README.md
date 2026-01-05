# Monitoring Stack

This directory contains configurations for monitoring and observability tools.

## Components

- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Loki** - Log aggregation
- **Promtail** - Log shipping
- **Node Exporter** - System metrics
- **cAdvisor** - Container metrics
- **Alertmanager** - Alert management

## Structure

```
monitoring/
├── prometheus/         # Prometheus configuration
├── grafana/           # Grafana dashboards and datasources
├── loki/              # Loki configuration
├── alertmanager/      # Alert rules and configuration
└── docker-compose.yml # Monitoring stack compose file
```

## Quick Start

### Deploy with Docker Compose

```bash
cd monitoring
docker-compose up -d
```

### Access Services

- **Grafana**: http://localhost:3000 (default: admin/admin)
- **Prometheus**: http://localhost:9090
- **Alertmanager**: http://localhost:9093

## Prometheus Configuration

### Adding Targets

Edit `prometheus/prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
  
  - job_name: 'docker'
    static_configs:
      - targets: ['cadvisor:8080']
```

### Recording Rules

Create rules in `prometheus/rules/`:

```yaml
groups:
  - name: example
    interval: 30s
    rules:
      - record: job:http_requests:rate5m
        expr: rate(http_requests_total[5m])
```

## Grafana

### Importing Dashboards

1. Navigate to Dashboards → Import
2. Enter dashboard ID from grafana.com
3. Select Prometheus datasource

### Popular Dashboard IDs

- Node Exporter Full: 1860
- Docker Monitoring: 193
- Prometheus Stats: 2

### Datasource Configuration

Datasources can be provisioned in `grafana/provisioning/datasources/`.

## Alerting

### Prometheus Alerts

Create alert rules in `prometheus/alerts/`:

```yaml
groups:
  - name: system
    rules:
      - alert: HighCPU
        expr: node_cpu_usage > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
```

### Alertmanager Configuration

Configure receivers in `alertmanager/alertmanager.yml`:

```yaml
receivers:
  - name: 'email'
    email_configs:
      - to: 'alerts@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.example.com:587'
```

## Log Aggregation with Loki

### Promtail Configuration

Configure log collection in `loki/promtail.yml`:

```yaml
scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*.log
```

### Querying Logs in Grafana

Use LogQL syntax:
```
{job="varlogs"} |= "error"
```

## Exporters

### Node Exporter

Collects system metrics:
- CPU usage
- Memory usage
- Disk I/O
- Network statistics

### cAdvisor

Collects container metrics:
- Container CPU usage
- Container memory usage
- Container network I/O

### Custom Exporters

Add exporters for specific services:
- blackbox_exporter - Endpoint monitoring
- snmp_exporter - SNMP device monitoring
- postgres_exporter - PostgreSQL metrics

## Best Practices

- Set appropriate retention periods
- Use labels effectively for filtering
- Create meaningful alerts (avoid alert fatigue)
- Document dashboards
- Back up Grafana dashboards
- Use service discovery when possible
- Implement rate limiting on exporters
- Secure dashboards with authentication

## Troubleshooting

### Prometheus not scraping targets

```bash
# Check targets status
curl http://localhost:9090/api/v1/targets

# Check Prometheus logs
docker logs prometheus
```

### Grafana datasource issues

1. Verify datasource URL
2. Check network connectivity
3. Verify Prometheus is running
4. Test datasource in Grafana UI

### High cardinality issues

- Review metric labels
- Limit label values
- Use relabeling to drop unnecessary metrics
