# Rocket Issue #2377

| Test | Demonstrates |
|--|--|
| [test1.md](https://github.com/danielclough/Rocket-2377/blob/main/test2-test1.md) | Rocket treats "out of the box" `curl` vs `python-requests` POSTs differenlty. |
| [test2.md](https://github.com/danielclough/Rocket-2377/blob/main/test2-test2.md) | That the difference is probably related to `requests` using `Accept-Encoding: gzip, deflate` |

I guess the problem relates to how Rocket classifies and parses compressed data vs raw data, perhaps related [Built-in Limits](https://api.rocket.rs/v0.5-rc/rocket/data/struct.Limits.html#built-in-limits).