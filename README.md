# custom — Helm Chart for Self-Hosted Web App on Kubernetes

This repo contains a Helm chart (`custom`) for deploying a simple public-facing web application onto a Kubernetes cluster. The cluster runs on local VMs (desktop homelab-style), serves a Vue frontend, and is exposed to the internet using Kubernetes ingress and Cloudflare DNS.

This project focuses on repeatable deployment, clean Helm structure, and practical self-hosting.

---

## Stack

- Frontend: Vue (built as static assets)
- Runtime: Kubernetes (local VM cluster)
- Packaging: Helm
- Networking: Kubernetes Service + Ingress
- DNS / Edge: Cloudflare
- Deployment model: Homelab to public internet

---

## Architecture (High Level)

Internet
|
Cloudflare DNS
|
Router / NAT
|
Ingress Controller (Kubernetes)
|
Service
|
Pods (Web server serving Vue build)

---

## Helm Design

The chart follows standard Helm conventions:

- Consistent naming via helpers:
  - custom.name
  - custom.fullname
- Kubernetes-standard labels:
  - app.kubernetes.io/name
  - app.kubernetes.io/instance
  - app.kubernetes.io/version
- Helm metadata:
  - helm.sh/chart
  - app.kubernetes.io/managed-by

Supports:
- nameOverride
- fullnameOverride
- configurable serviceAccount
- standard label selectors
- predictable resource naming for multi-release installs

This allows:
- multiple installs in one cluster
- clean upgrades
- non-conflicting naming
- proper label-based selection

---

## Prerequisites

- Kubernetes cluster (kubectl configured)
- Helm 3+
- Ingress controller (e.g. nginx-ingress)
- Public network path to cluster (NAT, port-forwarding, MetalLB, or equivalent)
- Cloudflare DNS account

---

## Installation via Helm

helm repo add custom-repo https://github.com/bucknercd/custom/raw/main/
helm repo update
helm install <my-release> custom-repo/custom

Upgrade:
helm upgrade <my-release> custom-repo/custom

Uninstall:
helm uninstall <my-release>

---

## Typical Configuration

Common values configured per install:

- nameOverride
- fullnameOverride
- serviceAccount.create
- serviceAccount.name
- image.repository
- image.tag
- service.type
- service.port
- ingress.enabled
- ingress.className
- ingress.hosts
- ingress.tls

Example:

helm install web custom-repo/custom \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=app.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix

---

## Cloudflare Setup

Typical flow:

1. Cloudflare DNS A record:
   app.example.com -> <public IP>

2. Traffic flow:
   Cloudflare → Router/NAT → Ingress Controller → Service → Pods

3. TLS termination can occur at:
   - Cloudflare
   - Ingress
   - both (depending on configuration)

---

## Local VM Cluster Model

Cluster runs on local virtual machines and is exposed externally using:

- ingress controller
- router port forwarding or bridged networking
- optional MetalLB or host networking

This enables:
- public hosting from local infrastructure
- full control over networking
- zero managed cloud dependencies

---

## Purpose of This Repo

This project exists as a practical infrastructure reference showing:

- Helm chart structure and templating
- Kubernetes deployment patterns
- self-hosted public web services
- homelab to internet exposure workflows
- clean resource naming and labeling
- repeatable cluster deployments
- infra-first design thinking

It is intentionally simple and focused on deployment architecture, not application complexity.

