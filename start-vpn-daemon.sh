docker run -d --privileged --env-file=.env.edu \
  -p 8888:8888 -p 8889:8889 \
  --name sdsu-vpn \
  wazum/openconnect-proxy:latest