# 自动构建部署腾讯云函数

## 创建子账户获取认证凭证

> <https://cloud.tencent.com/document/product/583/44786>

```shell
# .env
TENCENT_SECRET_ID=xxxxxxxxxx #您账号的 SecretId
TENCENT_SECRET_KEY=xxxxxxxx #您账号的 SecretKey
```

## 自动部署

> <https://cloud.tencent.com/document/product/1154/47290>

### 1、构建二进制

```shell
docker build -t scf_app . -f ./SCF/CustomRuntime/Dockerfile.build
docker create --name extract scf_app
docker cp extract:/app app
```

### 2、自定义运行时

```shell
touch ./app/scf_bootstrap && chmod +x ./app/scf_bootstrap
cat > ./app/scf_bootstrap<<EOF
#!/usr/bin/env bash
# export LD_LIBRARY_PATH=/opt/swift/usr/lib:${LD_LIBRARY_PATH}
./Run serve --env production --hostname 0.0.0.0 --port 9000
EOF
```

### 3、部署

```shell
npm install -g serverless
npm install -g @slsplus/cli

slsJson=$(cat ./SCF/CustomRuntime/sls.json)
slsplus parse --output --auto-create --sls-options="$slsJson" && cat serverless.yml

sls deploy --force --debug
```

> 详情参考 `.github/workflows/deploy-sls.yml`
