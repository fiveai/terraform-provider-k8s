resource "k8s_manifest" "my-configmap" {
  name      = "my-configmap"
  namespace = "default"
  kind      = "ConfigMap"
  content = templatefile("${path.module}/manifests/my-configmap.yml.tpl", {
    app       = "dummyvalue"
  })
}

resource "k8s_manifest" "ngix-deployment" {
  name      = "nginx-deployment-test"
  namespace = "default"
  kind      = "Deployment"
  content = templatefile("${path.module}/manifests/nginx-deployment.yml.tpl", {
    replicas  = 1
    app       = "dummyvalue"
  })
}
