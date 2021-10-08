Let's configure Parca to scrape itself.

<pre class="file" data-filename="parca.yml" data-target="replace">
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

Let's overwrite the configmap with our new configuration file:

```
```{{execute}}

Once the Parca is running, and you set up the port-forwarding. Now you can navigate through to the web interface on the browser by visiting visit `http://localhost:7070`.

[Go to Parca Server Dashboard](https://[[HOST_SUBDOMAIN]]-7070-[[KATACODA_HOST]].environments.katacoda.com/)
