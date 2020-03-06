\d .prom

h:hopen 8080;
h"N:100000"
h".prom.tab:([]N?1f;N?10;N?0b;N?`2;N?0p)"
md:0;
// split a minute into appropriately sized random time bins
tsplit:0 20 35 45 55_neg[count t]?t:til 60;
.z.ts:{
  // current second of a minute
  min_val:`ss$.z.t;
    // upsert 10000 rows for the first 20 seconds of a minute
  $[(min_val in tsplit 0);
    h"N:50000+first 1?100000;`.prom.tab upsert([]N?1f;N?10;N?0b;N?`3;N?0p)";
    // remove 10000 rows for the second 20 seconds
    min_val in tsplit 1;neg[h]"delete from `.prom.tab where i<10000+first 1?100000";
    // run a select statement on the table 
    min_val in tsplit 2;
    // run either a HTTP request or sync select statement
    $[0~md mod 2;(.Q.hg["http://localhost:8080/?1+1"];);h"select first x from .prom.tab"]
    min_val in tsplit 3;
    // Cause either a sync or async error
    $[0~md mod 3;(h"1+`a");(neg[h]"1+`a")];
    neg[h]"select first x from .prom.tab"];
  // run garbage collection on the server and local process every 30s
  if[0~first md mod 30;h".Q.gc[]";.Q.gc[]];md+:1;
  }

-1".z.ts set to execute every second";
system"t 1000"
