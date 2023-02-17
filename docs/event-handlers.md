# Prometheus metric event handlers 


Metric updates are generally carried out inside event handlers. By overwriting these handlers, users can update metric values in response to various triggers ranging from HTTP requests to timer events.

The functions outlined below can be modified to allow a user to monitor events outside those exposed in `exporter.q` 

`.prom.`      **event handlers**<br>
[`on_poll`](#promon_poll)      Prometheus poll request<br>
[`on_pc`](#promon_pc)        IPC socket connection closing<br>
[`on_po`](#promon_po)        IPC socket connection opening<br>
[`on_wc`](#promon_wc)        Websocket connection closing<br>
[`on_wo`](#promon_wo)        Websocket connection opening<br>
[`after_pg`](#promafer_pg)      Synchronous IPC socket request handler, call after execution<br>
[`before_pg`](#prombefore_pg)    Synchronous IPC socket request handler, call before execution<br>
[`after_ps`](#promafter_ps)     Asynchronous IPC socket request handler, call after execution<br>
[`before_ps`](#prombefore_ps)    Asynchronous IPC socket request handler, call before execution<br>
[`after_ph`](#promafter_ph)     HTTP GET request handler, call after execution<br>
[`before_ph`](#prombefore_ph)    HTTP GET request handler, call before execution<br>
[`after_pp`](#promafter_pp)     HTTP POST request handler, call after execution<br>
[`before_pp`](#prombefore_pp)    HTTP POST request handler, call before execution<br>
[`after_ws`](#promafter_ws)     Websocket request handler, call after execution<br>
[`before_ws`](#prombefore_ws)    Websocket request handler, call before execution<br>
[`after_ts`](#promafter_ts)     Timer event handler, call after execution<br>
[`before_ts`](#prombefore_ts)    Timer event handler, call after execution

:point_right:
[Example invocations of these event handlers](../examples/kdb_user_example.q)

Once the relevant event handlers have been defined to update the metric values, initialize the library with a call to [`.prom.init`](reference.md#initialize-library)

:warning: 
Updating `.z.*` handlers after the call to `.prom.init` will overwrite the Prometheus logic. 
Correct usage is to load all process logic before loading the Prometheus library. 


## `.prom.after_pg`

_Synchronous IPC socket request handler, called after execution_

```txt
.prom.after_pg[tmp;msg;res]
```


Where

-   `tmp` is the object returned by `.prom.before_pg`
-   `msg` is the object that was executed
-   `res` is the object returned by the execution of `msg` 


## `.prom.after_ph`

_HTTP GET request handler, called after execution_

```txt
.prom.after_ph[tmp;(requestText;requestHeaderAsDictionary);res]
```


Where

-   `tmp` is the object returned by `.prom.before_ph`
-   `(requestText;requestHeaderAsDictionary)` is a HTTP GET request
-   `res` is the object returned by the execution of `msg` 


## `.prom.after_pp`

_HTTP POST request handler, called after execution_

```txt
.prom.after_pp[tmp;(requestText;requestHeaderAsDictionary);res]
```


Where

-   `tmp` is the object returned by `.prom.before_pp`
-   `(requestText;requestHeaderAsDictionary)` is a HTTP POST request
-   `res` is the object returned by the execution of `msg` 


## `.prom.after_ps`

_Asynchronous IPC socket request handler, called after execution_

```txt
.prom.after_ps[tmp;msg;res]
```


Where

-   `tmp` is the object returned by `.prom.before_ps`
-   `msg` is the object that was executed
-   `res` is the object returned by the execution of `msg` 


## `.prom.after_ts`

_Timer event handler, called after execution_

```txt
.prom.after_ts[tmp;dtm;res]
```


Where

-   `tmp` is the object returned by `.prom.before_ts`
-   `dtm` is the timestamp at the start of execution
-   `res` is the object returned by the execution of `dtm` 


## `.prom.after_ws`

_Websocket request handler, called after execution_

```txt
.prom.after_ws[tmp;msg;res]
```


Where

-   `tmp` is the object returned by `.prom.before_ws`
-   `msg` is the object that was executed
-   `res` is the object returned by the execution of `msg` 


## `.prom.before_pg`

_Synchronous IPC socket request handler, called before execution_

```txt
.prom.before_pg msg
```


Where `msg` is the object to be executed, returns a `tmp` object to be passed to the _after_ handler.


## `.prom.before_ph`

_HTTP GET request handler, called before execution_

```txt
.prom.before_ph(requestText;requestHeaderAsDictionary)
```


Where `(requestText;requestHeaderAsDictionary)` is an HTTP GET request, returns a `tmp` object to be passed to the _after_ handler.


## `.prom.before_pp`

_HTTP POST request handler, called before execution_

```txt
.prom.before_pp(requestText;requestHeaderAsDictionary)
```


Where `(requestText;requestHeaderAsDictionary)` is an HTTP POST request, returns a `tmp` object to be passed to the _after_ handler.


## `.prom.before_ps`

_Asynchronous IPC socket request handler, called before execution_

```txt
.prom.before_ps msg
```


Where `msg` is the object to be executed, returns a `tmp` object to be passed to the _after_ handler.


## `.prom.before_ts`

_Timer event handler, called before execution_

```txt
.prom.before_ts dtm
```


Where `dtm` is the timestamp at the start of execution, returns a `tmp` object to be passed to the _after_ handler.


## `.prom.before_ws`

_Websocket request handler, called before execution_

```txt
.prom.before_ws msg
```


Where `msg` is the object to be executed, returns a `tmp` object to be passed to the _after_ handler.


## `.prom.on_pc`

_Socket close handler_

```txt
.prom.on_pc hdl
```


Where `hdl` is the handle of a socket connection, closes the socket.


## `.prom.on_po`

_Socket open handler_

```txt
.prom.on_po hdl
```


Where `hdl` is the handle of a socket connection, opens the socket.


## `.prom.on_poll`

_Prometheus poll request handler_

```txt
.prom.on_poll(requestText;requestHeaderAsDictionary)
```

Where `(requestText;requestHeaderAsDictionary)` is an HTTP request

