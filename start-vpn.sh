docker run -it --rm --privileged --env-file=.env.edu \
  -v $(pwd)/hipreport-sdsu.sh:/etc/hipreport-sdsu.sh:ro \
  -p 8888:8888 -p 8889:8889 \
  openconnect-proxy:latest


