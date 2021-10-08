And fetch the latest Parca Agent version:

```
PARCA_AGENT_VERSION=`curl -s https://api.github.com/repos/parca-dev/parca-agent/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`
```{{execute}}

 You can download the latest agent binary release for your architecture from our [releases page](https://github.com/parca-dev/parca-agent/releases).

```
curl -sL https://github.com/parca-dev/parca-agent/releases/download/"$PARCA_AGENT_VERSION"/parca-agent_"${PARCA_AGENT_VERSION#v}"_`uname -s`_`uname -m`.tar.gz | tar xvfz -
```{{execute}}

Move the binary to a place where we can refer:

```
mv ./parca-agent /usr/bin
```{{execute}}

You can run the Parca Agent as a `systemd` unit with the following simple configuration:

<pre class="file" data-filename="parca-agent.service" data-target="replace">
[Unit]
Description=Parca Agent

[Service]
Type=simple
User=root
Group=root

ExecStart=/usr/bin/parca-agent --http-address=":7071" --node=systemd-test --systemd-units=docker.service,parca.service,parca-agent.service --kubernetes=false --store-address=localhost:7070 --insecure

Restart=on-failure
RestartSec=10

StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=parcaagent

[Install]
WantedBy=multi-user.target
</pre>

The command in the above configuration targets the Parca server that is presumably running on your system. And it uses the `systemd` service discovery to find the cgroups that have been running on your system.

To use the configuration, we need to move it a directory that `systemd` can load:
```
cp editor/parca-agent.service /etc/systemd/system/parca-agent.service
```{{execute}}

And then simply start the unit:
```
systemctl start parca-agent
```{{execute}}

Check the status if it's healthy:
```
systemctl status parca
```{{execute}}

The `systemd` service will be collecting profiles from `docker.service`, `parca.service` and `parca-agent.service` that have been running on your system.

Once Parca and Parca Agent are both running, you can navigate to the web interface on the browser. Let's do that.
