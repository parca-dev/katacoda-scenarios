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

To view the Parca UI and access the API, we can port-forward using the default port `7070`:

```
kubectl -n parca port-forward --address=0.0.0.0 service/parca 7070:7070 > /dev/null 2>&1 &
```{{execute}}

Once the Parca is running, and you set up the port-forwarding. Now you can navigate through to the web interface on the browser by visiting visit `http://localhost:7070`.

[Go to Parca Server Dashboard](https://[[HOST_SUBDOMAIN]]-7070-[[KATACODA_HOST]].environments.katacoda.com/)

## Configuring Parca Agent to send data

However, at this stage, you shouldn't see any data. Parca hasn't ingested any data because we haven't configured any data source.

To continuously send every profile collected to a Parca server the configure the `--store-address` and the potential credentials needed.

For example, to send to a Parca server in the `parca` namespace set: `--store-address=parca.parca.svc:7070`.

This has already been set up for our current setup in the previously applied manifests.

```yaml
containers:
    - args:
    - /bin/parca-agent
    - --log-level=info
    - --node=$(NODE_NAME)
    - --kubernetes
    - --store-address=parca.parca.svc.cluster.local:7070
    - --insecure
    - --insecure-skip-verify
    - --temp-dir=/tmp
```

> You can use `--insecure` and `--insecure-skip-verify` for simpler setups.

```shell
--insecure                           Send gRPC requests via plaintext instead of TLS.
--insecure-skip-verify               Skip TLS certificate verification.
```
