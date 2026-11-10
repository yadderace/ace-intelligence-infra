# ace-intelligence-infra

Terraform for the ace-intelligence infrastructure on DigitalOcean.

Built up one resource at a time, applying and validating each before adding the next. Currently
applied: the DigitalOcean Project (`ace-master`) and its managed Postgres database (cluster
`popolhub-db`, database `popolhub`). The App Platform app comes next, attached to this project now
that the database is confirmed live.

## Structure

```
ace-master/              # production environment, named after its DigitalOcean Project
  versions.tf            # provider version constraints + Terraform Cloud backend
                          # (org `ace-intelligence`, workspace `ace-intelligence-prod`)
  providers.tf           # DigitalOcean provider config
  variables.tf           # inputs for this environment (do_token)
  project.tf             # the "ace-master" DigitalOcean Project
  database.tf            # managed Postgres cluster + the app's database within it
  outputs.tf             # connection info for the managed Postgres cluster
```

The Postgres cluster is a single node on the smallest plan (`db-s-1vcpu-1gb`, nyc3, engine version
18), sized for the app's own OLTP traffic only. No read replica yet - if/when dbt pipelines are
added, they're meant to run against the primary directly during an off-hours window (no concurrent
app traffic), not against a replica; a replica only becomes worth the extra cost if that off-hours
assumption stops holding.

The cluster currently has no trusted-sources restriction, so it's reachable from any IP (over TLS,
with the generated credentials). That's deliberate for now - there's no App Platform app yet to
restrict it to. Once the App Platform app exists, lock the cluster down to it (DigitalOcean lets an
App Platform app be added as a trusted source without needing its IP).

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
