To quickly try out the Parca and Parca Agent with Kubernetes,
you create a [minikube](https://minikube.sigs.k8s.io/docs/) cluster with an actual virtual machine,
e.g. Virtualbox. Since the minikube already installed our environment, let's start our environment:

```
minikube start
```{{execute}}

> The Agent needs to access to Kernel and run as a privileged user to load necessary eBPF programs. Please check [our FAQ for further information](/docs/faq#since-parca-agent-has-to-run-as-root-for-ebpf-what-are-the-security-considerations).

First, let's make sure we have the namespace we are going to use is created (if you haven't already done this in the previous step):

```
kubectl create namespace parca
```{{execute}}

Let's fetch the latest Parca version:

```
PARCA_VERSION=`curl -s https://api.github.com/repos/parca-dev/parca/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`
```{{execute}}

To provision the Parca against any Kubernetes cluster, and use the API and UI:

```
kubectl apply -f https://github.com/parca-dev/parca/releases/download/$PARCA_VERSION/kubernetes-manifest.yaml
```{{execute}}

You can verify by selecting pods if everything runs as expected:

```
kubectl get pods -n parca
```{{execute}}

When you see it's running, you can continue.

To view the Parca UI and access the API, we can port-forward using the default port `7070`:

```
kubectl -n parca port-forward --address=0.0.0.0 service/parca 7070:7070 > /dev/null 2>&1 &
```{{execute}}

Once the Parca is running, and you set up the port-forwarding. Now you can navigate through to the web interface on the browser by visiting visit `http://localhost:7070`.

[Go to Parca Server Dashboard](https://[[HOST_SUBDOMAIN]]-7070-[[KATACODA_HOST]].environments.katacoda.com/)

However, at this stage, you shouldn't see any data. Parca hasn't ingested any data because we haven't configured any data source.

So let's set up Parca Agent in our cluster and collect data from our cluster.
