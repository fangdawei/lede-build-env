docker buildx build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) --build-arg userpasswd=xxx -t build_lede .
