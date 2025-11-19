# Security Policy

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability, please do the following:

1. **Do not** open a public issue
2. Email security details to: security@gaia-tools.com (or create a private security advisory on GitHub)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond within 48 hours and work with you to address the issue.

## Security Best Practices

- Keep dependencies updated
- Use authentication in production
- Configure rate limiting
- Use HTTPS/TLS
- Validate all inputs
- Follow principle of least privilege
- Monitor for suspicious activity

## Known Security Considerations

- JWT tokens: Use strong secrets and appropriate expiration
- Rate limiting: Configure based on your use case
- CORS: Restrict to known domains in production
- Input validation: All user inputs are validated
- Dependencies: Regularly updated via Dependabot

