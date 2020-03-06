# Prometheus Exporter for kdb+

[TOC]

## Introduction

Prometheus exporter for kdb+ metrics.

Prometheus is free software that facilitates metrics gathering, querying and alerting for a wealth of different 3rd party languages and applications. It also provides integration with Kubernetes for automatic discovery of supported applications.

Visualization and querying can be done through its built in expression browser, or more commonly via Grafana.

An  environment being administrated or analyzed by Prometheus will be able to include current and past metrics exposed by kdb+.

Aims

- To provide a script that provides useful general metrics that can be extended if required
- Allow correlation between different instances, metrics, exporters and installs to be easily identified

What this isn't

- This doesnt provide service discovery. Prometheus itself has support for multiple mechanisms such as DNS, Kubernetes, EC2, file based config, etc in order to discover all the kdb+ instances within your environment.
- You may need to extend this script to provide more relevant metrics for your environment. Please consider contributing if your change may be generic enough to have a wider user benefit
- General machine/kubernetes/cloud metrics on which kdb+ is running. Metrics can be gathered by such exporters as the node exporter. Metrics from multiple exporters can be correlated together to provide a bigger picture of your environment conditions.

### Example Use Cases

Some example use cases which could be generated from queries/alerts using the Prometheus framework

- Effects from version upgrades (e.g. performance before/after changes)
- Alerts when your license may be due to expire
- Bad use of symbol types within an instance
- Instances upon which garbage collection may be beneficial on long running processes
- etc

## New to kdb+ ?

kdb+ is the worlds fastest time-series database. Kdb+ is optimized for ingesting, analyzing, and storing massive amounts of structured data.
To access the free editions of kdb+, please visit https://code.kx.com/q/learn/ for downloads and developer information. For general information, visit https://kx.com/

## Quick Start

Run kdb+ with the supplied q script. For example, the following will expose metrics on port 8080 

```
q exporter.q -p 8080
```

Once running, you can use your web browser to view the currently exposed statistics on the metrics URL e.g. http://localhost:8080/metrics. The metrics exposed will be the current values from the time at which the URL is requested.

## Metrics Exposed

By running the exporter, you can view the metrics end point in your web browser for full list of current metrics and descriptions

## Web Based Dashboard Demo 

This demonstration uses [Docker Compose](https://docs.docker.com/compose/install/) to run an instance of Prometheus and Grafana to gather metrics (via Prometheus) and present them in an interactive, pre-configured dashboard (via Grafana).

Its intended as a quick and simple way to run an environment, and not a suggestion of how you should run or maintain your environment.

This is not intended as a production ready example, only for demonstrations and development.

### Requirements

This demo requires a Docker instance capable of running Unix based containers e.g. Docker Desktop for Mac, Linux, Windows 10 Pro (and above), with Internet access.

### Setup 

Run kdb+ with the supplied q script on the host that Docker will be used.  This will expose metrics over http that will be gathered by Prometheus in the supplied demo

For example, the following will expose metrics on port 8080 

```
q exporter.q -p 8080
```

The next session details running an environment with a single prometheus instance and grafana dashboard, that accesses the kdb+ exporter from the local machine in port 8080. Please view the prometheus docs for using multiple targets and service discovery if wishing to use it for mulitple targets.

#### Linux and Mac

In order to run Prometheus and Grafana, enter the supplied DockerCompose directory and run

```
docker-compose up
```

Wait till images/etc downloaded and running. First time will take longer than subsequent times once images downloaded i.e. should take about a second to run if images have been downloaded previously.

When you have finished running the demo, ctrl-c in the running docker-compose and run 

```
docker-compose-down
```

#### Windows

As above, but run

```
docker-compose -f docker-compose-win.yml up
```

and then the following when you wish to finish with the environment.

```
docker-compose -f docker-compose-win.yml down
```

#### Example Resource Utilization

In order to show resources being consumed within the demo environment, we have supplied a q script that can connect to the q session being monitored and consumed resources (along with generating example errors).

The following script defaults to connecting to a remote q session on port 8080 (i.e. the q session being monitored above). To do this, run the following from the same machine.

```
q kdb_user_example.q
```

If the system is configured correctly, you should start to see the metrics changing within the Grafanas kdb+ dashboard after a few seconds.

### Accessing Components

After starting the environment, Prometheus and Grafana should accessible from your web browser in the port mentioned in the docker-compose.yml i.e. Prometheus expression browser should be running on port 9090 e.g. [http://localhost:9090](http://localhost:9090/) , Grafana should be running on port 3000 e.g. http://localhost:3000 (using admin/pass as the username/password)

While in the Prometheus front-end, you can try executing a basic expression such as 'up' for the current status of monitored exporters. A '1' value should appear for your configured kdb+ instance(s) to indicate that Prometheus can reach the provided host, and it sees that kdb+ is running.

On logging into Grafana, there should be a pre-configured dashboard called 'kdb+' with example metrics being displayed from your kdb instance. To find this, select 'Home'.

Once you are viewing the kdb+ dashboard, you can use the server drop down to select other configured kdb+ instances (if you have configured Prometheus to watch more than one instance).

Files contained with the grafana-config directory contain the defaults used for the data source and dashboards which may be altered or saved between invocations of the environment.

Example generated dashboard using the exposed metric data:

<img src="grafana.png" style="zoom:50%;" />

## Adding Your Own Metrics

### Creating Metrics

In order to create a new metric

- Define a metric class, using `.prom.newmetric`
- Create a metric instance, using `.prom.addmetric`

#### `.prom.newmetric`

_Define a metric class_

Syntax: `.prom.newmetric[metric;metrictype;labelnames;helptxt]`

Where

- `metric` is the name of the metric class (s)
- `metrictype` is the type of metric (s)
- `labelnames` are the names of labels used to differentiate metric characteristics (s|S)
- `helptxt` is the HELP text provided with the metric values (C)

Example

```
// Tables
q).prom.newmetric[`number_tables;`gauge;`region;"number of tables"]
// Updates
q).prom.newmetric[`size_updates;`summary;();"size of updates"]
```

#### `.prom.addmetric`

_Create a metric instance_

Syntax: `.prom.addmetric[metric;labelvals;params;startval]`

Where

- `metric` is the metric class being used (s)
- `labelvals` are the values of labels used to differentiate metric characteristics (s|S)
- `params` are the parameters relevant to the metric type (F)
- `startval` is the starting value of the metric (f)

returning an identifier (s) for the metric, to be used in future updates.

Example

```
// Tables
q)numtab1:.prom.addmetric[`number_tables;`amer;();0f]
q)numtab2:.prom.addmetric[`number_tables;`emea;();0f]
q)numtab3:.prom.addmetric[`number_tables;`apac;();0f]
// Updates
q)updsz:.prom.addmetric[`size_updates;();0.25 0.5 0.75;`float$()]
```

Once created, a metric will automatically be included in each http response to a request from Prometheus.

### Metric Types

There are [4 types of metric](https://prometheus.io/docs/concepts/metric_types/) in Prometheus

- counter
- gauge
- histogram
- summary

#### Single-value metrics

Both `counter` and `gauge` are single-value metrics, providing a number per instance.

When updating a single-value metric, a single number will be modified. On a request, this number will be reported directly as the metric value.

#### Sample metrics

Both `histogram` and `summary` are aggregate metrics, providing summary statistics (defined by the metric params) per instance.

When updating a sample metric, a list of numeric values will be appended to. On request, this list will be used to construct the metric values, depending on the metric type and params.

### Metric Labels

Metric labels are key-value pairs, used to differentiate the characteristics of the thing being measured (e.g. the same metric may be split by geographic region).

Label names form part of the metric class definition.

Label values are added as each instance of the metric is created.

### Updating Metric Values

Metric values for an instance can be updated using `.prom.updval`. 

#### `.prom.updval`

_Update a metric value_

Syntax: `.prom.updval[name;func;arg]`

Where

- `name` is the metric instance being updated (s)
- `func` is the function/operator used to update the value
- `arg` is the second argument provided to `func` (the first argument being the value itself)

When updating a single-value metric (`counter` or `gauge`), the value will typically be incremented, decremented or assigned to. This value will be reported directly to Prometheus.

When updating a sample metric (`histogram` or `summary`), a list of numeric values will typically be appended to. This list will be aggregated to provide statistics to Prometheus according to the metric type and parameters provided.

Example

```
// Tables
q).prom.updval[numtab1;:;count tables[]] // set
q).prom.updval[numtab2;+;1]              // increment
q).prom.updval[numtab3;-;1]              // decrement
// Updates
q).prom.updval[updsz;,;10 15 20f]        // append
```

### Event handlers

Metric updates are generally carried out inside event handlers. By overwriting these handlers, users can update metric values in response to 

- Prometheus poll requests (`on_poll`)
- ipc socket connections opening (`on_po`)
- ipc socket connections closing (`on_pc`)
- websocket connections closing (`on_wc`)
- websocket connections opening (`on_wo`)
- synchronous ipc socket requests (`before_pg` and `after_pg`)
- asynchoronous ipc socket requests (`before_ps` and `after_ps`)
- http GET requests (`before_ph` and `after_ph`)
- http POST requests (`before_pp` and `after_pp`)
- websocket requests (`before_ws` and `after_ws`)
- timer events (`before_ts` and `after_ts`)

#### `on_poll`

_Prometheus poll request handler_

Syntax: `on_poll[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

#### `on_po`

_Socket open handler_

Syntax: `on_po[hdl]`

Where

- `hdl` is the handle of the socket connection being opened

#### `on_pc`

_Socket close handler_

Syntax: `on_pc[hdl]`

Where

- `hdl` is the handle of the socket connection being closed

#### `before_pg`

_Synchronous ipc socket request handler, called before execution_

Syntax: `before_pg[msg]`

Where

- `msg` is the object to be executed 

returning a (tmp) object to be passed to the _after_ handler.

#### `after_pg`

_Synchronous ipc socket request handler, called after execution_

Syntax: `after_pg[tmp;msg;res]`

Where

- `tmp` is the object returned by `before_pg`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

#### `before_ps`

_Asynchronous ipc socket request handler, called before execution_

Syntax: `before_ps[msg]`

Where

- `msg` is the object to be executed 

returning a (tmp) object to be passed to the _after_ handler.

#### `after_ps`

_Asynchronous ipc socket request handler, called after execution_

Syntax: `after_ps[tmp;msg;res]`

Where

- `tmp` is the object returned by `before_ps`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

#### `before_ph`

_HTTP GET request handler, called before execution_

Syntax: `before_ph[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

returning a (`tmp`) object to be passed to the _after_ handler.

#### `after_ph`

_HTTP GET request handler, called after execution_

Syntax: `after_ph[tmp;msg;res]`

Where

- `tmp` is the object returned by `before_ph`
- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)
- `res` is the object returned by the execution of `msg` 

#### `before_pp`

_HTTP POST request handler, called before execution_

Syntax: `before_pp[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

returning a (`tmp`) object to be passed to the _after_ handler.

#### `after_pp`

_HTTP POST request handler, called after execution_

Syntax: `after_pp[tmp;msg;res]`

Where

- `tmp` is the object returned by `before_pp`
- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)
- `res` is the object returned by the execution of `msg` 

#### `before_ws`

_Websocket request handler, called before execution_

Syntax: `before_ws[msg]`

Where

- `msg` is the object to be executed 

returning a (tmp) object to be passed to the _after_ handler.

#### `after_ws`

_Websocket request handler, called after execution_

Syntax: `after_ws[tmp;msg;res]`

Where

- `tmp` is the object returned by `before_ws`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

#### `before_ts`

_Timer event handler, called before execution_

Syntax: `before_ts[dtm]`

Where

- `dtm` is the timestamp at the start of execution

returning a (tmp) object to be passed to the _after_ handler.

#### `after_ts`

_Timer event handler, called after execution_

Syntax: `after_ts[tmp;dtm;res]`

Where

- `tmp` is the object returned by `before_ts`
- `dtm` is the timestamp at the start of execution
- `res` is the object returned by the execution of `dtm` 

### Initialize library

Once the relevant event handlers have been defined to update the metric values, the library can by initialized with a call to `.prom.init`

```
q).prom.init[]
```

Note: Updating `.z.*` handlers after the call to `.prom.init` will overwrite the Prometheus logic. Correct usage is to load all process logic before loading the Prometheus library.
