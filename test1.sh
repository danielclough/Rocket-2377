#!/bin/bash
echo "# Rocket Issue #2377" > test1.md

echo -e 'This file is generated by `test1.sh` to demonstrate unintuitive filesize requirements for `curl` vs `python requests`. Perhaps related [Built-in Limits](https://api.rocket.rs/v0.5-rc/rocket/data/struct.Limits.html#built-in-limits).\n\nIt seems that the type `TempFile` should always involve a 1MB limit, but it can accept 2MB from `python requsts`.\n\nThe greatest problem for reconciling my results with the OP is that `curl` accepts a smaller filesize, and OP had it working with `curl` but not `python requests`.\n\n' >> test1.md
echo -e 'Full logs can be found in [test1-troubleshooting.md](https://github.com/danielclough/Rocket-2377/blob/main/test1-troubleshooting.md).' >> test1.md

echo -e "\n## 3 filesizes\n" >> test1.md
echo '```' >> test1.md
ls -al file-lg.txt file-sm.txt file-xs.txt >> test1.md
echo '```' >> test1.md

echo -e "\n## Try file-lg.txt (2097506) with python (expected pass)\n" >> test1.md
echo '```' >> test1.md
python3 post_lg.py 2>> test1.md
echo '```' >> test1.md

echo -e "\n## Try file-sm.txt (2096373) with python (unexpected pass)\n" >> test1.md
echo '```' >> test1.md
python3 post_sm.py >> test1.md
echo '```' >> test1.md

echo -e "\n## Try file-sm.txt (2096373) with curl (expected pass)\n" >> test1.md
echo '```' >> test1.md
curl -v \
 -F file=@file-sm.txt -F name=file-sm.txt \
 http://127.0.0.1:8000/upload  >> test1.md
echo -e '\n```' >> test1.md

echo -e "\n\n## Try file-xs.txt (954715) with curl (expected pass)\n" >> test1.md
echo '```' >> test1.md
curl -v \
 -F file=@file-xs.txt -F name=file-xs.txt \
 http://127.0.0.1:8000/upload  >> test1.md
echo -e '\n```' >> test1.md