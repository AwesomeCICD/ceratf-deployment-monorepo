<p align="center">
  <img width="200" height="200" src="./.img/circleci_logo.png">
</p>

<h2 align="center" >C.E.R.A</h1>
<h1 align="center" >CircleCI Enterprise Reference Architecture</h1>
<h1 align="center" >A new monorepo for CERA Terraform deployment</h1>

## Index
- [What is CERA?](#What-is-CERA?)
- [Why do we need CERA?](#Why-do-we-need-CERA?)
- [Goals of CERA](#Goals-of-CERA)
- [Wall of Work and Organization](#Wall-of-Work-and-Organization)
- [Diagrams](#Diagrams)
- [Cluster Information](#Cluster Information)
- [Development Workflows](#Development Workflows)


## What is CERA?
CERA, CircleCI Enterprise Reference Architecture, is a full scale enterprise environment that includes the following services:

[comment]: <> (- CircleCI Server running on Kubernetes)
[comment]: <> (- CircleCI Runners deployed on VMs and Kubernetes)
- Full Stack Logging Solution
- Re-deployable infrastructure using infrastructure as code
- A production like application - Circle Banking App (cba)
- CircleCI's Fieldguide
[comment]: <> (- On Prem VCS)
- Artifact Repository
- Container Registry
- Argo Rollouts
- CCI Release Agent
- Kiali, Grafana, Prometheus, Istio & Cert-Manager
- `TODO: Add more services`


## Why does CircleCI need CERA?
CERA grew from the need of CircleCI shifting to larger enterprise customers. To make a truly impactful demo for enterprise customers it is important to understand an enterprise like environment, the pain points surrounding an enterprise like environment,
and what technologies are in an enterprise like environment.


## Goals of CERA
Focusing our talented Field Engineering team's effort on supporting CircleCI's Enterprise Reference Architecture, the goals are as follows:

- Have an effective environment to showcase CircleCI's enterprise level features
- Show off more complex use cases of CircleCI's platform
- Have an environment that can be tailored to different personas inside an enterprise customer (Mobile Developer, DevOps Engineer, Frontend/Backend Developer, Centralized Ops Team)
- Flexible environment that is easy to add or modify
- Re-deployable with little to no effort
- Easily Maintainable
- `TODO: Define and solidify goals with team`

At the end of the day CircleCI needs an environment that Field Engineering can utilize for demos.


## Wall of Work and Organization
CERA has a lot of moving parts and will require collaboration to be complex. In order to stay organized this project will be utilizing [JIRA](https://circleci.atlassian.net/jira/software/projects/FE/boards/392).
JIRA will act as a wall of work where individuals can look and be assigned tasks. By utilizing JIRA the Field Engineering team can effectively collaborate on multiple tasks across different time zones.

**How we work**
#### TODO


## Diagrams
[Here](https://drive.google.com/file/d/1hYCSr-1dme95koshN_0nmEKLA9JI3yEs/view?usp=sharing) is the link to the diagrams!

## Cluster Information
[Here](https://circleci.atlassian.net/wiki/spaces/CE/pages/6582469344/CERA+Customer+Engineering+Cluster+Details) is the link containing information on accessing the CERA EKS Cluster. (CCI Employees only)


## Workflows & Layers
![Screenshot](./.img/tree.png)
### Global
Our global module represents common resources needed by all clusters. If this path is triggerd, an apply will propigate through all layers of our infrastructure (Global -> EKS -> Platform)

Services deployed at the global layers include: 
- Route 53
- IAM
- Kuma

### (namer/emea/japac-eks)
Our EKS layer and modules will handle the deployment of our EKS clusters in each of the regions above. If this path is triggerd, an apply will trigger the following jobs (EKS -> Platform)

Services deployed at the EKS layer include: 
- EKS cluster to eu-west-2, us-west-2 or ap-northeast-1, depending on what region is triggered
- Istio service mesh
- Vault

### (namer/emea/japac-platforms)
Our platform layer and modules will handle the deployment of the required services to our clusters in each of the regions above. If this path is triggerd, an apply will trigger the following jobs at the Platform level only

Services & configuration deployed at the platform layer include: 
- Vault config
- Nexus
- Nexus Config
- Argo Rollouts
- CircleCI Release Agent

### TOO


## Use Cases

### Global Trigger
1. Global -> Everything
    * Global -> NAMER -> NAMER-Platforms
    * Global -> EMEA -> EMEA-Platforms
    * Global -> JAPAC -> JAPAC-Platforms

### Namer-all
1. NAMER -> NAMER-Platforms
2. NAMER-Platforms

### EMEA-all
1. EMEA -> EMEA-Platforms
2. EMEA-Platforms

### JAPAC-all
1. JAPAC -> JAPAC-Platforms
2. JAPAC-Platforms

### Platforms
1. NAMER-Platforms
2. EMEA-Platforms
3. JAPAC-Platforms


## Trooubleshooting

### Teardown Stuck Istio Namespace

If deleting istio-system namespace hangs, try this to force;fully remove Kiali finalizers.

```
kubectl get kialis.kiali.io kiali "istio-system" -o json \\n  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \\n  | kubectl replace --raw /api/spaces/istio-system/finalize -f -
```

Or print the `kialis.kiali.io kiali` to yaml and manually remove finalizers, and apply.