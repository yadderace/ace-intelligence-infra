# ace-intelligence-infra

Terraform for the ace-intelligence infrastructure on DigitalOcean: App Platform (backend service,
deployed from GitHub) + a Managed Postgres database.

Built up one resource at a time, applying and validating each before adding the next. Currently
only the managed Postgres database is defined; App Platform comes next once the database is
confirmed working.

## Structure

```
modules/app/            # reusable resource definitions, no provider or backend config
  variables.tf
  database.tf            # managed Postgres cluster + database
  outputs.tf

environments/
  prod/                  # the only environment so far
    versions.tf          # provider version constraints + Terraform Cloud backend
                          # (org `ace-intelligence`, workspace `ace-intelligence-prod`)
    providers.tf          # DigitalOcean provider config
    variables.tf          # inputs for this environment (incl. do_token)
    main.tf                # calls modules/app with this environment's values
    outputs.tf
    terraform.tfvars        # this environment's values (git-ignored, non-secret only)
    terraform.tfvars.example
```

Each environment is its own Terraform root with its own Terraform Cloud workspace and state, all
pointing at the same `modules/app`. Adding a dev environment later means creating an
`environments/dev/` directory with the same shape (pointing at a new `ace-intelligence-dev`
workspace) — no changes needed to `modules/app`.

## Setup (per environment)

Run these from inside the environment directory, e.g. `environments/prod/`:

1. `terraform login` (already done once per machine).
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in values, or set the
   equivalent `TF_VAR_*` environment variables. `terraform.tfvars` is git-ignored since it
   can hold secrets; `do_token` in particular should be set via `TF_VAR_do_token` rather than
   written to a file.
3. `terraform init`
4. `terraform plan`
5. `terraform apply`
