#!/bin/bash
echo "# Rocket Issue #2377" > test2.md

echo -e 'This file is generated by `test2.sh` to demonstrate that `curl` vs `python requests` handle POST differently.\n' >> test2.md
echo -e 'Full logs can be found in [test2-troubleshooting.md](https://github.com/danielclough/Rocket-2377/blob/main/test2-troubleshooting.md) and [test2-dumpcap.test](https://github.com/danielclough/Rocket-2377/blob/main/test2-dumpcap.test).' >> test2.md

echo -e "\n## Try file-xs.txt (954715) with python (unexpected pass)\n" >> test2.md
echo '```' >> test2.md
python3 post_xs.py >> test2.md
echo '```' >> test2.md

echo -e "\n\n## Try file-xs.txt (954715) with curl (expected pass)\n" >> test2.md
echo '```' >> test2.md
curl -v \
 -F file=@file-xs.txt -F name=file-xs.txt \
 http://127.0.0.1:8000/upload  >> test2.md
echo -e '\n```' >> test2.md

