# Kubernetes Terraform Provider

The k8s Terraform provider enables Terraform to deploy Kubernetes resources. Unlike the
[official Kubernetes provider][kubernetes-provider] it handles raw manifests, leveraging `kubectl` directly to allow
developers to work with any Kubernetes resource natively.

This provider is published in the [Terraform Registry](https://registry.terraform.io/providers/fiveai/k8s)

## ToC

* [Usage](#usage)
* [Build](#build)
* [Publishing](#publishing)

## Usage

### Provider and Version control

This provider is automatically pushed to the TF Registry. You can pull it into your project uses the standard provider
and versions notation.

```hcl
terraform {
  required_providers {
    kubernetes = {
      source = "fiveai/k8s"
      version = "0.2.1"
    }
  }
}

provider "kubernetes" {
  # Configuration options
}
```

#### Provider Configuration options

The provider takes the following optional configuration parameters:

* If you have a kubeconfig available on the file system you can configure the provider as:

```hcl
provider "k8s" {
  kubeconfig = "/path/to/kubeconfig"
}
```

* If you content of the kubeconfig is available in a variable, you can configure the provider as:

```hcl
provider "k8s" {
  kubeconfig_content = "${var.kubeconfig}"
}
```

**WARNING:** Configuration from the variable will be recorded into a temporary file and the file will be removed as
soon as call is completed. This may impact performance if the code runs on a shared system because the global
tempdir is used.

### Resource Definition

An example of the k8s_manifest might look like.

The terraform resource definition should include:

* `name` of the resource
* `namespace` to be deployed to (namespaced resources only, not cluster level)
* `content` resource to be deployed
* `kind` of resource being deployed, e.g. `Deployment`, `ConfigMap`

```hcl
resource "k8s_manifest" "dummy-deployment" {
  name      = "dummyvalue"
  namespace = "default"
  kind      = "Deployment"

  content = templatefile("${path.module}/manifest/dummy-deployment.yml.tpl", {
    app       = "dummyvalue"
  })
}
```

The templated resource definition should then resemble the following example.

```yaml
apiVersion: apps/v1
metadata:
  labels:
    app: ${app}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${app}
  template:
    metadata:
      labels:
        app: ${app}
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

## Build

To build please use [goreleaser](https://goreleaser.com/intro/). You can edit the automated Github Actions by the
`./.goreleaser.yml` and `./github/workflows/release.yml` files.

To create a test build run the following command:

```
goreleaser build --snapshot
```

To push up a new build add a tag based on [semantic versioning](https://semver.org/) with a `v` prefix.

## Publishing

The configuration is a terraform and github integration with manual configuration. The provider has been setup and will
automatically pickup new version releases in github.
