# Contributing to MyHomeLab

Thank you for your interest in contributing to this homelab repository! This document provides guidelines for contributions.

## How to Contribute

### Sharing Your Improvements

If you've made improvements or added features that might benefit others:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Reporting Issues

If you encounter issues with the configurations or documentation:

1. Check if the issue already exists
2. Create a new issue with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - System information (OS, versions, etc.)

## Contribution Guidelines

### Documentation

- Keep documentation clear and concise
- Use proper markdown formatting
- Include examples where helpful
- Update README if adding new features

### Code Style

- **Bash Scripts**:
  - Use `#!/bin/bash` shebang
  - Include comments for complex operations
  - Add error handling (`set -e`)
  - Use meaningful variable names

- **YAML Files**:
  - Use 2 spaces for indentation
  - Keep formatting consistent
  - Add comments for complex configurations

- **Docker Compose**:
  - Use version 3.8 or higher
  - Group related services
  - Use named volumes
  - Document environment variables

### Configuration Files

- Never commit secrets or passwords
- Use `.env.example` for examples
- Document all configuration options
- Keep sensitive data in `.env` (gitignored)

### Testing

Before submitting:

- Test configurations work as expected
- Verify scripts execute without errors
- Check documentation is accurate
- Validate YAML syntax

## What to Contribute

### Welcome Contributions

- Bug fixes
- Documentation improvements
- New service configurations
- Automation scripts
- Security enhancements
- Performance optimizations
- Testing improvements

### Ideas for Contributions

- Additional monitoring dashboards
- More Ansible playbooks
- Kubernetes configurations
- Terraform modules
- Backup/restore scripts
- Security hardening guides
- Troubleshooting tips

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn
- Be patient with questions

## Questions?

If you have questions about contributing:

- Open an issue for discussion
- Check existing issues and PRs
- Review documentation first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in the project. Thank you for helping make this homelab setup better!
