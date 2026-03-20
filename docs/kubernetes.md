# Kubernetes 安装

我们有不同的方案在 Kubernetes 集群上安装 Homer，每种方案对应不同的需求。

## 目录

- [Helm Chart](#helm-chart)
- [使用 CRD 的控制器](#controller-crds)
- [使用 Ingress 注解的控制器](#controller-annotations)
- [Operator](#operator)

## Helm Chart

使用 Helm 在 Kubernetes 中部署 Homer。

感谢 [@djjudas21](https://github.com/djjudas21) 提供的 [charts](https://github.com/djjudas21/charts/tree/main/charts/homer)：

### 安装

```sh
helm repo add djjudas21 https://djjudas21.github.io/charts/
helm repo update djjudas21

# 使用默认配置安装
helm install homer djjudas21/homer

# 使用自定义配置安装
wget https://raw.githubusercontent.com/djjudas21/charts/main/charts/homer/values.yaml
# 编辑 values.yaml
helm install homer djjudas21/homer -f values.yaml
```

## Controller CRDs

使用 [自定义资源定义](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) 在 Kubernetes 中动态声明 Homer 服务来部署 Homer。

感谢 [@jplanckeel](https://github.com/jplanckeel) 提供的 [homer-k8s](https://github.com/bananaops/homer-k8s/tree/main/)：

### 安装

```sh
helm repo add bananaops https://bananaops.github.io/homer-k8s/
helm repo update bananaops

# 使用默认配置安装
helm install homer bananaops/homer-k8s

# 使用自定义配置安装
wget https://raw.githubusercontent.com/bananaops/homer-k8s/main/helm/homer-k8s/values.yaml
# 编辑 values.yaml
helm install homer bananaops/homer-k8s -f values.yaml
```

### 使用方法

- [使用方法](https://github.com/bananaops/homer-k8s/tree/main/?tab=readme-ov-file#crds-homerservices)

## Controller Annotations

使用控制器检查 Ingress 注解并修改 Homer 配置来在 Kubernetes 中部署 Homer。

感谢 [@paulfantom](https://github.com/paulfantom) 提供的 [homer-reloader](https://github.com/paulfantom/homer-reloader/tree/main/)：

## Operator

使用 [自定义资源定义](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) 在 Kubernetes 中部署多个 Homer 实例。

感谢 [@rajsinghtech](https://github.com/rajsinghtech) 提供的 [homer-operator](https://github.com/rajsinghtech/homer-operator/tree/main/)：

### 安装

```sh
# 使用自定义配置安装
wget https://raw.githubusercontent.com/rajsinghtech/homer-operator/main/deploy/operator.yaml
# 应用 operator 文件
kubectl apply -f operator.yaml
```

### 使用方法

- [使用方法](https://github.com/rajsinghtech/homer-operator?tab=readme-ov-file#usage)
