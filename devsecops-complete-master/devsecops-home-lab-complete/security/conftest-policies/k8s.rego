package k8s.security

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.securityContext.runAsNonRoot
  msg := "Containers should set securityContext.runAsNonRoot=true"
}
