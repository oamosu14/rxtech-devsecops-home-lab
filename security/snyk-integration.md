
# Snyk Integration

1. On **jenkins-node**, install Snyk CLI:
   ```bash
   curl -sL https://snyk.io/install | bash
   ```
2. Authenticate:
   ```bash
   snyk auth <YOUR_TOKEN>
   ```
3. In Jenkins pipeline, this repo uses `security/scripts/run-scans.sh`.
4. Optionally store token in Jenkins Credentials and export `SNYK_TOKEN` before running scans.
