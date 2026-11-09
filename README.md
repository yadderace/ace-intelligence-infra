# ipc-infra

Terraform for the ipcservices stack on DigitalOcean.

```
modules/droplet    droplet + tag-targeted firewall
modules/database   managed Postgres + database + trusted-sources firewall
envs/prod          VPC, tag, droplet, DB, reserved IP, project
```

Architecture: one droplet runs the frontend (nginx) and backend containers via Docker Compose.
Postgres is a DigitalOcean Managed Database reachable only from the droplet over the VPC.

## One-time bootstrap (manual, on purpose)

1. DO console > API: create a **personal access token** (read+write).
2. DO console > Spaces: create a bucket `ipc-tfstate` in `nyc3` (keep it private) and a Spaces key pair.
   If you pick another name/region, edit the `backend "s3"` block in `envs/prod/providers.tf`.
3. Upload your SSH public key in DO > Settings > Security.

```bash
export DIGITALOCEAN_TOKEN=...            # never commit
export AWS_ACCESS_KEY_ID=...             # Spaces key (used by the state backend)
export AWS_SECRET_ACCESS_KEY=...
```

## Usage

```bash
cd envs/prod
cp terraform.tfvars.example terraform.tfvars   # fill in ssh_key_name and admin_cidrs
terraform init
terraform plan
terraform apply
```

## Deploying the app

cloud-init installs Docker and writes `/opt/ipcservices/.env` (DB host/port/credentials, `JWT_SECRET`).
Code is not deployed by Terraform. Copy the `ipcservices` project to `/opt/ipcservices`
and run a compose file **without** the postgres service, using that `.env`.

## Known requirements on the app side

- Managed Postgres enforces TLS. `backend/src/config/ormconfig.ts` has no `ssl` option yet;
  add one driven by `DB_SSL` or the backend cannot connect.
- Managed Postgres listens on port `25060`, not 5432 (handled via `DB_PORT`).

## Notes

- State and `terraform.tfvars` are git-ignored; `.terraform.lock.hcl` is committed.
- The DB cluster has `prevent_destroy = true`.
- The app connects as `doadmin` so TypeORM migrations can create tables in `public`.
  A least-privilege app user is a good later hardening step.
- Secrets (DB password, JWT secret) are stored in Terraform state. Keep the Space private.
- Droplet `user_data` changes are ignored after creation; to re-run cloud-init, replace the droplet
  (`terraform apply -replace=module.droplet.digitalocean_droplet.this`).
- Pre-commit: `pre-commit install` (fmt, validate, tflint, trivy).
