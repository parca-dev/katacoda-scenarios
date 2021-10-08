Let's update the configuration file for Parca to scrape itself.

<pre class="file" data-filename="parca.yaml" data-target="replace">
debug_info:
  bucket:
    type: "FILESYSTEM"
    config:
      directory: "./tmp"
  cache:
    type: "FILESYSTEM"
    config:
      directory: "./tmp"

scrape_configs:
  - job_name: "default"
    scrape_interval: "1s"
    static_configs:
      - targets: [ '127.0.0.1:7070' ]
</pre>

Now Parca has an updated configuration file and previously we configured it using a configmap.
Let's overwrite the configmap with our new configuration file:

```
kubectl create configmap -n parca parca-config --from-file=parca.yaml=editor/parca.yaml -o yaml --dry-run  | kubectl apply -f -
```{{execute}}

Once the configuration is updated, now we can rollout our changes to our running instances:

```
kubectl rollout restart deployment/parca -n parca
```{{execute}}

Check and verify the rollout complete and new pods are there:

```
kubectl get pods -n parca
```{{execute}}

Now you can navigate through to the web interface on the browser by visiting visit `http://localhost:7070`.

[Go to Parca Server Dashboard](https://[[HOST_SUBDOMAIN]]-7070-[[KATACODA_HOST]].environments.katacoda.com/)
