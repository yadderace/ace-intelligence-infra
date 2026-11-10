# ace-intelligence-infra

Terraform for the ace-intelligence infrastructure on DigitalOcean.

Built up one resource at a time, applying and validating each before adding the next. Currently
only the DigitalOcean Project (`ace-master`) is defined; the managed Postgres database and App
Platform app come next, attached to this project once it's confirmed working.

## Structure

```
ace-master/              # production environment, named after its DigitalOcean Project
  versions.tf            # provider version constraints + Terraform Cloud backend
                          # (org `ace-intelligence`, workspace `ace-intelligence-prod`)
  providers.tf           # DigitalOcean provider config
  variables.tf           # inputs for this environment (do_token)
  project.tf             # the "ace-master" DigitalOcean Project
```

Each environment is its own top-level directory, named after the DigitalOcean Project it owns, with
its own Terraform Cloud workspace and state. Adding another environment later (e.g. a dev one) means
creating a new top-level directory named after its project, pointing at a new Terraform Cloud
workspace.

## Setup

Run these from inside `ace-master/`:

1. `terraform login` (already done once per machine).
2. Export `TF_VAR_do_token` with a DigitalOcean API token (kept out of any file).
3. `terraform init`
4. `terraform plan`
5. `terraform apply`
