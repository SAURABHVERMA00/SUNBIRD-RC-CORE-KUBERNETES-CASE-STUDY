# Helm Secrets Management Guide (Beginner)

## Problem
Hardcoded secrets in Git = Security Risk! ❌

```yaml
# BAD - Never do this!
stringData:
  password: "postgres"  # Now everyone can see it!
```

## Solution: Use Helm Values + .gitignore ✅

### Step 1: Create Your Local Secrets File

Copy the example file and add REAL values:

```bash
cp values.example.yaml values.yaml
# Edit values.yaml with actual secrets (don't commit this!)
```

### Step 2: Update .gitignore

Already done! These files are ignored:
- `values.yaml` (your real secrets)
- `values.local.yaml` (local overrides)

### Step 3: Use Values in Templates

Instead of hardcoded secrets:

```yaml
# OLD (BAD) - Don't do this:
stringData:
  connectionInfo_password: postgres

# NEW (GOOD) - Use Helm values:
stringData:
  connectionInfo_password: {{ .Values.secrets.postgres.password | quote }}
```

### Step 4: Deploy with Your Secrets File

```bash
# Deploy with values from your local secrets
helm install sunbird-rc \
  -f values.example.yaml \
  -f values.yaml \
  .

# OR upgrade
helm upgrade sunbird-rc \
  -f values.example.yaml \
  -f values.yaml \
  .
```

## What Gets Committed to Git?

✅ `values.example.yaml` - Template with placeholders
✅ Updated `backend.yaml` - Uses `{{ .Values.secrets.* }}`

## What Does NOT Get Committed?

❌ `values.yaml` - Contains real secrets (in .gitignore)
❌ `values.local.yaml` - Local overrides (in .gitignore)

## File Hierarchy

```
SUNBIRD-RC-CORE-KUBERNETES/helm/sunbird-rc-core/
├── values.example.yaml       ✅ Commit this
├── values.yaml               ❌ NEVER commit (in .gitignore)
├── values.local.yaml         ❌ NEVER commit (in .gitignore)
├── templates/
│   ├── backend.yaml          ✅ Uses {{ .Values.secrets.* }}
│   └── ...
```

## For Your Team

1. Share `values.example.yaml` in Git
2. Each developer creates their own `values.yaml` 
3. Developers never commit their local `values.yaml`
4. Production deploys use secure secrets management (Vault/AWS Secrets Manager)

## Production Best Practice

In production, don't even use `values.yaml` files:

```bash
# Use Vault or environment variables
helm install sunbird-rc \
  --set secrets.postgres.password=$(vault kv get -field=password secret/postgres) \
  .
```

This is much more secure! 🔐
