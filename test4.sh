#!/bin/bash
echo "# Rocket Issue #2377" > test4.md

echo -e 'This file is generated by `test4.sh`' >> test4.md

echo -e "\n## Try file-lg.txt (954715) with python (unexpected fail)\n" >> test4.md
echo '```' >> test4.md
python3 post_lg.py >> test4.md
echo '```' >> test4.md

echo -e "\n\n## Try file-lg.txt (954715) with curl (expected fail)\n" >> test4.md
echo '```' >> test4.md
curl -v \
 -F file=@file-lg.txt -F name=file-lg.txt \
 http://127.0.0.1:8000/upload  >> test4.md
echo -e '\n```' >> test4.md

