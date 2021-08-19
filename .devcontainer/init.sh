DOCKER_IMAGE_VERSION="v1"

# 拉取最新的镜像
docker pull ghcr.io/secosun/jhbase:latest || true

# 使用最新拉取的镜像作为缓存层
docker build \
  --cache-from ghcr.io/secosun/jhbase:latest \
  -t ghcr.io/secosun/jhbase:$DOCKER_IMAGE_VERSION \
  -t ghcr.io/secosun/jhbase:latest \
  -f "../jhvege/JHVEGEBASE/Dockerfile" \
  "../jhvege/JHVEGEBASE"

# 重新推送  
docker push ghcr.io/secosun/jhbase:$DOCKER_IMAGE_VERSION
docker push ghcr.io/secosun/jhbase:latest