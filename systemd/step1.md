Let's fetch the latest Parca version:

```
PARCA_VERSION=`curl -s https://api.github.com/repos/parca-dev/parca/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`
```{{execute}}

You can download the latest binary release for your architecture from our [releases page](https://github.com/parca-dev/parca/releases).

```
curl -sL https://github.com/parca-dev/parca/releases/download/$PARCA_VERSION/parca_$PARCA_VERSION_`uname -s`_`uname -m`.tar.gz | tar xvfz
```{{execute}}

Move the binary to a place where we can refer:
```shell
mv ./parca /usr/bin
```

> `/usr/bin` was selected as an example and used in the subsequent sections of this tutorial.


Now you can run the Parca as a `systemd` unit with the following simple configuration:
<pre class="file" data-filename="parca,service" data-target="replace">
[Unit]
Description=Parca service
Requires=network-online.target
After=network-online.target

[Service]
User=parca
Group=parca
Restart=on-failure
ExecStart=/usr/bin/parca --config-path=/etc/parca/parca.yaml
ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=65535
NoNewPrivileges=true
ProtectHome=true
ProtectSystem=full
ProtectHostname=true
ProtectControlGroups=true
ProtectKernelModules=true
ProtectKernelTunables=true
LockPersonality=true
RestrictRealtime=yes
RestrictNamespaces=yes
MemoryDenyWriteExecute=yes
PrivateDevices=yes
CapabilityBoundingSet=

[Install]
WantedBy=multi-user.target
</pre>

To use the configuration, we need to move it a directory that `systemd` can load:

```
cp editor/parca.service /etc/systemd/system/parca.service
```{{execute}}

And then simply start the unit:
```
systemctl start parca
```{{execute}}

Parca runs with an example configuration file by default, that makes Parca to scrape itself.

```yaml
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
      - targets: ["127.0.0.1:7070"]
```

This will start the Parca server on port `7070` and configure it to retrieve profiles from itself every 1 second automatically.

[Go to Parca Server Dashboard](https://[[HOST_SUBDOMAIN]]-7070-[[KATACODA_HOST]].environments.katacoda.com/)

Once Parca is running, you can navigate to the web interface on the browser.

![image](https://user-images.githubusercontent.com/8681572/133893063-8cc9fc8a-4d55-431d-80fc-6a2fe8de7019.png)
