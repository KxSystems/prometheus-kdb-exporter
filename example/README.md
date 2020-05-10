# kdb+ interface for Prometheus-Exporter (Example)

The demonstration documented below is outlined in full [here](https://code.kx.com/q/interfaces/prom/exporter/examples). For the purposes of this clarity the following is a summary.

## Requirements
This demonstration requires a Docker instance capable of running a Unix based container e.g. Docker Desktop for Mac/Linux/Windows 19 Pro with internet access

## Setup

Start a q session locally on port 8080, running `exporter.q` from this folder via the command

```bash
q ../exporter.q -p 8080
```

This will expose the metrics associated with this process on port 8080 for consumption by Prometheus.

Initialize a docker environment containing a pre-configured Prometheus and Grafana setup from within the `DockerCompose` folder via

**Windows/MacOS**

Initialize the docker instance

```
docker-compose up
```

When finished running the demonstration stop the process using `ctrl-c` or run

```
docker-compose down
```

**Linux**

Initialize the docker instance

```
docker-compose -f docker-compose-linux.yml up
```

Run the following when the environment is to be stopped

```
docker-compose -f docker-compose-linux.yml down
```

## Example resource Utilization

Provided with the interface is the script `kdb_user_example.q`. This can be used to show an example of resources being consumed and monitored using Prometheus. The script will connect to the q session running on port 8080 as outlined above and attempt to use resources in a number of ways

```
q kdb_user_example.q
```

## Accessing Prometheus and Grafana

Once the docker instance has been initialised Prometheus and Grafana should be running on the following ports

- Prometheus = http://localhost:9090
- Grafana = http://localhost:3000

On the Prometheus front end you can monitor specific metrics as desired. Executing `up` for example will allow a user to check that the exporter is 'up'. If the demo is running correctly this will be '1' for your configured kdb+ instance.

To log into Grafana on port 3000 use the following credentials

- Username = admin
- Password = pass

Once logged in a pre-configured dashboard named kdb+ should be available from the `Home` dropdown. This will give an example of monitoring which can be be completed using the interface but is by no means exhaustive

The following is an example of a generated dashboard from the above workflow

![Grafana](grafana.png)
