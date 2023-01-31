#!/bin/bash
echo "# Rocket Issue #2377" > README.md

echo -e 'This file is generated by `test.sh` to demonstrate unintuitive filesize requirements for `curl` vs `python requests`. Perhaps related [Built-in Limits](https://api.rocket.rs/v0.5-rc/rocket/data/struct.Limits.html#built-in-limits). \n\nFull logs can be found in [troubleshooting.md](https://github.com/danielclough/Rocket-2377/blob/main/troubleshooting.md).\n\nIt seems that the type `TempFile` should always involve a 1MB filesize cap, but it can accept 2MB from `python requsts`.' >> README.md

echo -e "\n## 3 filesizes\n" >> README.md
echo '```' >> README.md
ls -al file-lg.txt file-sm.txt file-xs.txt >> README.md
echo '```' >> README.md

echo -e "\n## Try small file with python\n" >> README.md
echo '```' >> README.md
python3 post_sm.py >> README.md
echo '```' >> README.md

echo -e "\n## Try large file with python\n" >> README.md
echo '```' >> README.md
python3 post_lg.py 2>> README.md
echo '```' >> README.md

echo -e "\n## Try with small file with curl\n" >> README.md
echo '```' >> README.md
curl -v \
 -F file=@file-sm.txt -F name=file-sm.txt \
 http://127.0.0.1:8000/upload  >> README.md
echo -e '\n```' >> README.md

echo -e "\n\n## Try x-small file with curl\n" >> README.md
echo '```' >> README.md
curl -v \
 -F file=@file-xs.txt -F name=file-xs.txt \
 http://127.0.0.1:8000/upload  >> README.md
echo -e '\n```' >> README.md