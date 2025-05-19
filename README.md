# real-gitops

This is a high-level abstraction example of how you can structure your GitOps repository.

This project was created to demonstrate core concepts and ideas. It is not intended to serve as the foundation for a production-grade system.
However, if you'd like to use it as a sandbox for experimentation, the Argo CD Applications defined in this project can be deployed accordingly.

Since this is a GitOps repository, any Argo CD instance you deploy using this configuration must have access to the repository.
You can grant access using a Personal Access Token (PAT). Clone this repository and use your clone as the source of truth for your GitOps workflows.

Follow the step-by-step guide below to install the applications included in this project onto your Kubernetes clusters:

#### Install ArgoCD

1. Please follow https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd;

2. Fill out the ArgoCD repo secret. Create a a Personal Access Token (PAT):

Account -> Settings -> Development Settings -> Personal Access Tokens -> create new token -> ... Permissions -> Contents -> read-only

and copy the token.

```sh
mv argocd-repo-secret.yamloff argocd-repo-secret.yaml
```

and paste the PAT to the secret manifest.

3. Create the k8s secret of ArgoCD repo secret:

```sh
kubectl apply -f argocd/<dev|prod>/argocd-repo-secret.yaml
```

#### Create namespaces

```sh
kubectl create ns real-gitops
kubectl create ns prometheus-stack
```

#### Create self-signed TLS certificate

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout tls.key \
 -out tls.crt \
 -subj "/CN=real-gitops.dev/O=real-gitops.<dev|prod>"


kubectl create secret tls shared-tls-secret-<dev|prod> \
 --cert=tls.crt \
 --key=tls.key \
 --namespace real-gitops

kubectl create secret tls shared-tls-secret-<dev|prod> \
 --cert=tls.crt \
 --key=tls.key \
 --namespace prometheus-stack

rm tls.crt tls.key
```

#### Manually create ArgoCD root application

```sh
kubectl apply -f argocd/<dev|prod>/root.yaml
```
