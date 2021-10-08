To quickly try out the Parca and Parca Agent with Kubernetes, you create a [minikube](https://minikube.sigs.k8s.io/docs/) cluster with an actual virtual machine, e.g. Virtualbox. Since the minikube already installed our environment, let's start our environment:

```
minikube start
```{{execute}}

> The Agent needs to access to Kernel and run as a privileged user to load necessary eBPF programs. Please check [our FAQ for further information](/docs/faq#since-parca-agent-has-to-run-as-root-for-ebpf-what-are-the-security-considerations).

## Setting up Parca Agent

First, let's make sure we have the namespace we are going to use is created (if you haven't already done this in the previous step):

```
kubectl create namespace parca
```{{execute}}

And fetch the latest Parca version:

```
PARCA_AGENT_VERSION=`curl -s https://api.github.com/repos/parca-dev/parca-agent/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`
``````{{execute}}

To provision the Parca Agent as a `DaemonSet`:

```
kubectl apply -f https://github.com/parca-dev/parca-agent/releases/download/$PARCA_AGENT_VERSION/kubernetes-manifest.yaml
```{{execute}}

You can verify by selecting pods if everything runs as expected:

```
kubectl get pods -n parca
```{{execute}}

Let's setup a port-forward using the default port `7071`.

```
kubectl -n parca port-forward `kubectl -n parca get pod -lapp.kubernetes.io/name=parca-agent -ojsonpath="{.items[0].metadata.name}"` 7071 &
```{{execute}}

Now we can view the active profilers by visiting `http://localhost:7071`:

[Parca Agent](https://[[HOST_SUBDOMAIN]]-7071-[[KATACODA_HOST]].environments.katacoda.com/)

This is similar to what you should be seeing:

![image](./assets/active_profilers.png)
