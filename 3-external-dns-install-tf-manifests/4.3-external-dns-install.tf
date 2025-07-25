# Resource: HELM Release

resource "helm_release" "external_dns" {
  name       = "external-dns"
  depends_on = [ aws_iam_role.externaldns_iam_role ]

  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  namespace = "default"

  set {
      name  = "image.repository"
      value = "registry.k8s.io/external-dns/external-dns"
    }

  set {
      name  = "serviceAccount.create"
      value = "true"
    }
  
  set {
      name  = "serviceAccount.name"
      value = "external-dns"
    }

  set {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = "${aws_iam_role.externaldns_iam_role.arn}"
    }
  
  set {
      name  = "provider.name"
      value = "aws"
    }

  set {
      name  = "policy"
      value = "sync"
    }
}