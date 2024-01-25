resource "helm_release" "wordpress" {
  name       = "wordpress"
  repository = "oci://registry-1.docker.io/bitnamicharts"

  chart     = "wordpress"
  namespace = "wordpress"

  create_namespace = true
}

resource "helm_release" "kubeview" {
  name  = "kubeview"
  chart = "https://github.com/benc-uk/kubeview/releases/download/0.1.31/kubeview-0.1.31.tgz"

  namespace        = "kubeview"
  create_namespace = true
}

resource "helm_release" "monitoring" {
  name       = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-distributed"

  namespace        = "monitoring"
  create_namespace = true
}


