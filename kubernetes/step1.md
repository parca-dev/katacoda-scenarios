# Kubernetes

To quickly try out the Parca and Parca Agent with Kubernetes, you create a [minikube](https://minikube.sigs.k8s.io/docs/) cluster with an actual virtual machine, e.g. Virtualbox:

```
minikube start
```{{execute}}

> The Agent needs to access to Kernel and run as a privileged user to load necessary eBPF programs. Please check [our FAQ for further information](/docs/faq#since-parca-agent-has-to-run-as-root-for-ebpf-what-are-the-security-considerations).

## Setting up Parca Server

First, let's make sure we have the namespace we are going to use is created (if you haven't already done this in the previous step):

```
kubectl create namespace parca
```{{execute}}

To provision the Parca against any Kubernetes cluster, and use the API and UI:

```
kubectl apply -f https://github.com/parca-dev/parca/releases/download/v0.1.0-alpha/manifest.yaml
```{{execute}}

You can verify by selecting pods if everything runs as expected:

```
kubectl get pods -A
```{{execute}}

To view the Parca UI and access the API, we can port-forward using the default port `7070`:

```
kubectl -n parca port-forward service/parca 7070 &
```{{execute}}

Once the Parca is running, and you set up the port-forwarding. Now you can navigate through to the web interface on the browser by visiting visit `http://localhost:7070`.

[Parca Server](https://[[HOST_SUBDOMAIN]]-7070-[[KATACODA_HOST]].environments.katacoda.com/)

However, at this stage, you shouldn't see any data. Parca hasn't ingested any data because we haven't configured any data source.

So let's set up Parca Agent in our cluster and collect data from our cluster.

## Setting up Parca Agent

To provision the Parca Agent as a `DaemonSet`:

```
kubectl apply -f https://github.com/parca-dev/parca-agent/releases/download/v0.1.0-alpha/kubernetes-manifest.yaml
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

To continuously send every profile collected to a Parca server the configure the `--store-address` and the potential credentials needed.
For example, to send to a Parca server in the `parca` namespace set: `--store-address=parca.parca.svc:7070`.
This has already been set up for our current setup in the previously applied manifests.


> You can use `--insecure` and `--insecure-skip-verify` for simpler setups.

```
--insecure                           Send gRPC requests via plaintext instead of TLS.
--insecure-skip-verify               Skip TLS certificate verification.
```

Once Parca and Parca Agent are both running, you can navigate to the web interface on the browser.
You should shortly see the `Select profile...` dropdown menu populate with the profiles that Parca is retrieving from itself and receiving from the Agent.

Selecting `CPU Samples` as profile type and clicking the `Search` button will retrieve the profiles from Parca Agent for the time selection (default Last Hour).

This should result in a time series based on the profile that is interactable.
Clicking anywhere on the line graph should then bring up an icicle graph for the profile that you've selected.

You can then interact with the icicle graph to better understand how Parca is behaving.

> One of the cool features of Parca Agent is by default it discovers all the containers run on the nodes that it's been deployed.
So out of the box you should be seeing all the system containers running on the system.
If you go to query bar and enter `namespace="kube-system"` you can focus on them.

And you can click the samples on the graph to focus on the individual profiles.

## Kubernetes label selector for specific apps

To further sample targets on Kubernetes use the `--pod-label-selector=` flag.
For example, to only profile Pods with the `app.kubernetes.io/name=my-web-app` label, use `--pod-label-selector=app.kubernetes.io/name=my-web-app`.

The relevant manifest changes on `parca-agent-daemonSet.yaml` would like the following:

```diff
...
template:
  metadata:
    labels:
      app.kubernetes.io/component: observability
      app.kubernetes.io/instance: parca-agent
      app.kubernetes.io/name: parca-agent
  spec:
    containers:
    - args:
      - /bin/parca-agent
      - --log-level=info
      - --node=$(NODE_NAME)
      - --kubernetes
      - --store-address=parca.parca.svc.cluster.local:7070
+        - --pod-label-selector=app=my-web-app
      - --insecure
      - --insecure-skip-verify
      - --temp-dir=/tmp
...
```
