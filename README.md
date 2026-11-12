# ace-intelligence-infra

Terraform for the ace-intelligence infrastructure on DigitalOcean.

Built up one resource at a time, applying and validating each before adding the next. Currently
applied: the DigitalOcean Project (`ace-master`), its managed Postgres database (cluster
`popolhub-db`, database `popolhub`), the frontend App Platform app (`popolhub-frontend`, a Static
Site built from `ace-intelligence-services`' `frontend/` directory), and the `popolhub.com` DNS
zone. The backend App Platform app comes next (Dockerfile-based service, wired to the database).

Frontend and backend are two separate App Platform apps, not two components of one app, so each
deploys independently.

## Structure

```
ace-master/                  # production environment, named after its DigitalOcean Project
  versions.tf                # provider version constraints + Terraform Cloud backend
                              # (org `ace-intelligence`, workspace `ace-intelligence-prod`)
  providers.tf                # DigitalOcean provider config
  variables.tf                # inputs for this environment (do_token)
  project.tf                  # the "ace-master" DigitalOcean Project
  database.tf                 # managed Postgres cluster + the app's database within it
  domain.tf                   # popolhub.com DNS zone, assigned to the ace-master project
  outputs.tf                  # connection info for the managed Postgres cluster
  app_platform.tf             # calls the app_platform module, passes the DNS zone's name into it
  app_platform/                # child module - the App Platform apps
    versions.tf                # provider requirement (child modules need their own)
    variables.tf                # project_id, root_domain
    popolhub_frontend.tf        # the frontend Static Site app + its domain/ingress config
    outputs.tf                  # frontend_app_url
```

### Domain setup - what actually worked

`popolhub.com`'s nameservers are delegated to DigitalOcean (`ns1/ns2/ns3.digitalocean.com`), and
the zone is managed here via `digitalocean_domain.popolhub` in `domain.tf`. The working shape, in
`app_platform/popolhub_frontend.tf`:

- `www.popolhub.com` as the `PRIMARY` domain, `zone = "popolhub.com"`.
- The bare `popolhub.com` as an `ALIAS` domain (same zone), so it still routes to this app at all.
- An `ingress` rule 301-redirecting the bare domain to `https://www.popolhub.com`.

`digitalocean_domain` has no `project_id` field (unlike `digitalocean_app`, which does) - it's
assigned to the project via a separate `digitalocean_project_resources` resource instead, also in
`domain.tf`.

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
