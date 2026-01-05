# Ansible Playbooks

This directory contains Ansible playbooks for automating homelab infrastructure management.

## Structure

```
ansible/
├── inventory/           # Inventory files
├── playbooks/          # Playbook files
├── roles/              # Custom roles
├── group_vars/         # Group variables
├── host_vars/          # Host-specific variables
└── ansible.cfg         # Ansible configuration
```

## Prerequisites

- Ansible installed (`pip install ansible`)
- SSH access to target hosts
- Python on target hosts

## Quick Start

### Configure Inventory

Edit `inventory/hosts.yml` with your hosts:

```yaml
all:
  children:
    homelab:
      hosts:
        server1:
          ansible_host: 192.168.1.10
        server2:
          ansible_host: 192.168.1.11
```

### Run a Playbook

```bash
# Test connectivity
ansible all -m ping -i inventory/hosts.yml

# Run playbook
ansible-playbook -i inventory/hosts.yml playbooks/setup.yml

# Run with sudo
ansible-playbook -i inventory/hosts.yml playbooks/setup.yml --become

# Dry run
ansible-playbook -i inventory/hosts.yml playbooks/setup.yml --check
```

## Common Playbooks

- `setup.yml` - Initial server setup
- `docker.yml` - Install Docker
- `update.yml` - System updates
- `backup.yml` - Backup configurations
- `monitoring.yml` - Deploy monitoring agents

## Creating a Playbook

Example playbook structure:

```yaml
---
- name: Setup homelab server
  hosts: homelab
  become: yes
  
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
      when: ansible_os_family == "Debian"
    
    - name: Install packages
      apt:
        name:
          - vim
          - git
          - htop
        state: present
```

## Roles

Use roles for reusable components:

```bash
# Create a new role
ansible-galaxy init roles/my-role

# Use role in playbook
roles:
  - my-role
```

## Variables

### Group Variables

Store in `group_vars/all.yml`:
```yaml
ntp_servers:
  - time.cloudflare.com
  - time.google.com
```

### Host Variables

Store in `host_vars/server1.yml`:
```yaml
ansible_python_interpreter: /usr/bin/python3
```

## Secrets

Use Ansible Vault for sensitive data:

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Run playbook with vault
ansible-playbook playbook.yml --ask-vault-pass
```

## Testing

```bash
# Syntax check
ansible-playbook playbook.yml --syntax-check

# Check mode (dry run)
ansible-playbook playbook.yml --check

# Diff mode (show changes)
ansible-playbook playbook.yml --check --diff
```

## Best Practices

- Use roles for reusability
- Keep playbooks idempotent
- Use tags for selective execution
- Store secrets in Ansible Vault
- Test in check mode first
- Document your playbooks
- Use version control
