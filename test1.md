# Rocket Issue #2377
This file is generated by `test1.sh` to demonstrate unintuitive filesize requirements for `curl` vs `python requests`. Perhaps related [Built-in Limits](https://api.rocket.rs/v0.5-rc/rocket/data/struct.Limits.html#built-in-limits).

It seems that the type `TempFile` should always involve a 1MB limit, but it can accept 2MB from `python requsts`.

The greatest problem for reconciling my results with the OP is that `curl` accepts a smaller filesize, and OP had it working with `curl` but not `python requests`.


Full logs can be found in [test1-troubleshooting.md](https://github.com/danielclough/Rocket-2377/blob/main/test1-troubleshooting.md).

## 3 filesizes

```
-rw-rw-r-- 1 daniel daniel 2097506 Jan 30 18:25 file-lg.txt
-rw-rw-r-- 1 daniel daniel 2096373 Jan 30 18:25 file-sm.txt
-rw-rw-r-- 1 daniel daniel  954715 Jan 30 21:57 file-xs.txt
```

## Try file-lg.txt (2097506) with python (expected fail)

```
Traceback (most recent call last):
  File "/home/daniel/git/Rocket-2377/post_lg.py", line 11, in <module>
    assert r.text == os.path.getsize(file), 'different file size due to response being html'
AssertionError: different file size due to response being html
```

## Try file-sm.txt (2096373) with python (unexpected pass)

```
reported size: 2096373
stat size: 2096373
```

## Try file-sm.txt (2096373) with curl (expected fail)

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>413 Payload Too Large</title>
</head>
<body align="center">
    <div role="main" align="center">
        <h1>413: Payload Too Large</h1>
        <p>The request is larger than the server is willing or able to process.</p>
        <hr />
    </div>
    <div role="contentinfo" align="center">
        <small>Rocket</small>
    </div>
</body>
</html>
```


## Try file-xs.txt (954715) with curl (expected pass)

```
{"name":"file-xs.txt","fsize":954715}
```
