resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.7.3"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "server.ingress.hostname"
    value = "argocd.vasylkly.devops12.test-danit.com"
  }
  set {
    name  = "server.ingress.tls"
    value = "true"
  }
  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  depends_on = [
    helm_release.nginx_ingress
  ]
}