# Rocket Issue #2377
This file is generated by `test2.sh` to demonstrate that `curl` vs `python requests` handle POST differently.

Full logs can be found in [test2-troubleshooting.md](https://github.com/danielclough/Rocket-2377/blob/main/test2-troubleshooting.md) and [test2-dumpcap.test](https://github.com/danielclough/Rocket-2377/blob/main/test2-dumpcap.test).

## Try file-xs.txt (954715) with python (unexpected pass)

```
reported size: 954715
stat size: 954715
```


## Try file-xs.txt (954715) with curl (expected pass)

```
{"name":"file-xs.txt","fsize":954715}
```
