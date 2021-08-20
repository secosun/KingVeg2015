DOCKER_IMAGE_VERSION="v1"
#docker login ghcr.io -u secosun --password ghpjhvege_IcevwYJMfWGB306LCIe7bU3b1Knyjv3uOm1j
# 拉取最新的镜像
#docker pull ghcr.io/secosun/jhbase:latest || true

# 使用最新拉取的镜像作为缓存层
podman build \
  --cache-from ghcr.io/secosun/jhbase:latest \
  -t ghcr.io/secosun/jhbase:$DOCKER_IMAGE_VERSION \
  -t ghcr.io/secosun/jhbase:latest \
  -f "jhvege/JHVEGEBASE/Dockerfile" \
  "jhvege/JHVEGEBASE"
 

# 拉取最新的镜像
#docker pull ghcr.io/secosun/mysqlphpbase:latest || true
# 使用最新拉取的镜像作为缓存层
podman build \
  --cache-from ghcr.io/secosun/mysqlphpbase:latest \
  -t ghcr.io/secosun/mysqlphpbase:$DOCKER_IMAGE_VERSION \
  -t ghcr.io/secosun/mysqlphpbase:latest \
  -f "jhvege/BASEPHPMYSQL/Dockerfile" \
  "jhvege/BASEPHPMYSQL"

# 重新推送  
#docker push ghcr.io/secosun/jhbase:$DOCKER_IMAGE_VERSION
#docker push ghcr.io/secosun/jhbase:latest