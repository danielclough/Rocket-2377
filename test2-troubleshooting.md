## Experiement 1

```sh
sudo dumpcap -i lo -f "port 8000"
bash test2.sh
# output ommited here

# move output to project using output from dumpcap
sudo cat /tmp/wireshark_LoopbackKWTBZ1.pcapng | grep -a "HTTP/1.1" -A10 | grep -av "Test" >> test2-dumpcap.test
```

The OP cites the `boundary` as a notable differnce.
But, I don't see it as being relevant after looking at the [dumpcap.test](https://github.com/danielclough/Rocket-2377/blob/main/dumpcap.test) file.

My assumption is that Rocket (using --X-BOUNDARY) is starting boundry with known hash and ending with `--` in some safe way, but I have not looked into it as it doesn't seem to the the souce of the problem

I think the difference in handling may be related to `Accept-Encoding: gzip, deflate` used by `requests` vs `Accept: */*` used by `curl`.

It accounts for the difference in Content-Length:

| Client | Content-Length |
|--|--|
| python-requests/2.25.1 | 954975 |
| curl/7.81.0 | 955008 |
```