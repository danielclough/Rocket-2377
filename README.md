# Rocket Issue #2377

[My tests](https://github.com/danielclough/Rocket-2377) have found a limit of 1MB for `curl` and 2MB for `2MB` for `python-requests`, but no other significant differences between the two clients.

I don't understand the difference in limits as both requests are `multipart/form-data`, but it may be related to `python-requests` using `Accept-Encoding: gzip, deflate`, which explains the size difference noted in the OP.

[Built-in Limits](https://api.rocket.rs/v0.5-rc/rocket/data/struct.Limits.html#built-in-limits) shows:

| Limit Name |	Default	| Type |	Description |
|--|--|--|--|
| data-form |	2MiB |	Form |	entire data-based form |
| file |	1MiB	| TempFile |	TempFile data guard or form field |
| json	| 1MiB |	Json	| JSON data and form payloads |

Perhaps the  problem relates to how Rocket classifies and parses compressed data vs raw data?

Is it possible that `requests` is considered a `data-form` and `curl` as a `file`?

---

| Test | Demonstrates |
|--|--|
| [test1.md](https://github.com/danielclough/Rocket-2377/blob/main/test2.md) | Rocket treats "out of the box" `curl` vs `python-requests` POSTs differenlty. |
| [test2.md](https://github.com/danielclough/Rocket-2377/blob/main/test2.md) | That the difference is probably related to `requests` using `Accept-Encoding: gzip, deflate` |

I guess the problem relates to how Rocket classifies and parses compressed data vs raw data, perhaps related [Built-in Limits](https://api.rocket.rs/v0.5-rc/rocket/data/struct.Limits.html#built-in-limits).

|[test3.md](https://github.com/danielclough/Rocket-2377/blob/main/test3.md)| Null Result after changing struct from `TempFile` to `String` |