# Prometheus Exporter for kdb+

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/kxsystems/prometheus-kdb-exporter)](https://github.com/kxsystems/prometheus-kdb-exporter/releases)

## Introduction

This interface provides a method by which to expose metrics from a kdb+ process or multiple processes to Prometheus for monitoring. This is done via the script `exporter.q` which exposes kdb+ process metrics which can be consumed by Prometheus.

This interface is part of the [_Fusion for kdb+_](https://code.kx.com/v2/interfaces/fusion/) project.

## New to kdb+ ?

Kdb+ is the world's fastest time-series database, optimized for ingesting, analyzing and storing massive amounts of structured data. To get started with kdb+, please visit https://code.kx.com/q/learn/ for downloads and developer information. For general information, visit https://kx.com/

## What is Prometheus ?

Prometheus is an open source monitoring solution which facilitates metrics gathering, querying and alerting for a wealth of different 3rd party languages and applications. It also provides integration with Kubernetes for automatic discovery of supported applications.

Visualization and querying can be done through the Prometheus built in expression browser, or more commonly via Grafana. An example of this using docker is provided with this interface [here](./example/).

## Quick Start

Run kdb+ with the supplied q script. This script will expose metrics on port 8080 which can be monitored by Prometheus

```
q exporter.q -p 8080
```

Once running, you can use your web browser to view the currently exposed statistics on the metrics URL e.g. http://localhost:8080/metrics. The metrics exposed will be the metric values at the time at which the URL is requested.

## Unsupported Functionality

* This interface does not provide service discovery. Prometheus itself has support for multiple mechanisms such as DNS, Kubernetes, EC2, file based config, etc in order to discover all the kdb+ instances within your environment.


## Documentation

Extensive documentation for this interface is available on the code.kx.com website [here](https://code.kx.com/q/interfaces/fusion/prom/exporter).

## Status

The prometheus-kdb-exporter interface is still in developement and is provided here as a beta release under an Apache 2.0 license.

If you find issues with the interface or have feature requests please consider raising an issue [here](https://github.com/KxSystems/prometheus-kdb-exporter/issues). 

If you wish to contribute to this project please follow the contributing guide [here](CONTRIBUTING.md).
