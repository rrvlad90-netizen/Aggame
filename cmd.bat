git fetch origin
git rev-parse origin/master
git ls-tree -r --name-only origin/master | findstr /i ".wai .w3o"
pause