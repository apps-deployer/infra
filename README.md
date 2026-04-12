# infra

Terraform-конфигурация облачной инфраструктуры платформы [apps-deployer](https://github.com/apps-deployer) в Yandex Cloud.

## Что создаётся

| Ресурс | Описание |
|---|---|
| VPC + подсеть | Основная сеть `10.1.0.0/16`, зона `ru-central1-a` |
| Managed Kubernetes | Кластер с 2 preemptible-нодами (2 vCPU, 6 GB RAM) |
| Статический IP | Внешний IP для Ingress (Traefik) |
| Container Registry × 2 | Для образов платформы и пользовательских приложений |
| DNS-зона | Публичная зона с A-записями `@` и `*` → Ingress IP |
| KMS-ключ | Шифрование секретов в кластере |
| Сервисные аккаунты | Для кластера, CI/CD и жизненного цикла образов |
| S3-бакет | Хранение Terraform state (версионирование + KMS) |

## Требования

- [Terraform](https://www.terraform.io) ≥ 0.13
- [yc CLI](https://cloud.yandex.ru/docs/cli/quickstart)
- Аккаунт Yandex Cloud с созданным облаком и каталогом

## Структура

```
bootstrap/          # однократная инициализация (SA, S3-бакет)
envs/dev/
  network/          # VPC и подсеть
  dns/              # DNS-зона и записи
  k8s/              # кластер Kubernetes
  registry/         # Container Registry
  ci-cd/            # сервисные аккаунты для CI/CD
  dev.tfvars        # переменные окружения (не в git)
  dev.tfvars.example
scripts/
  auth.sh           # экспорт credentials для Terraform (bash)
  auth.fish         # экспорт credentials для Terraform (fish)
```

## Первый запуск

### 1. Инициализация (однократно)

```bash
# Создать SA для Terraform и S3-бакет для хранения state
bash bootstrap/sa.sh
bash bootstrap/bucket.sh
bash bootstrap/access-key.sh
```

### 2. Настроить переменные

```bash
cp envs/dev/dev.tfvars.example envs/dev/dev.tfvars
# Заполнить cloud_id, folder_id, domain_zone
```

### 3. Аутентификация

```bash
source scripts/auth.sh   # или auth.fish для Fish shell
```

### 4. Применить модули по порядку

```bash
# Зависимости: network → dns → k8s → registry → ci-cd

cd envs/dev/network  && terraform init && terraform apply -var-file=../dev.tfvars
cd envs/dev/dns      && terraform init && terraform apply -var-file=../dev.tfvars
cd envs/dev/k8s      && terraform init && terraform apply -var-file=../dev.tfvars
cd envs/dev/registry && terraform init && terraform apply -var-file=../dev.tfvars
cd envs/dev/ci-cd    && terraform init && terraform apply -var-file=../dev.tfvars
```

### 5. Подключиться к кластеру

```bash
yc managed-kubernetes cluster get-credentials \
  --name apps-deployer-dev-k8s \
  --external
```

### 6. Получить ключи для CI/CD

```bash
cd envs/dev/ci-cd
terraform output -raw ci_infra_sa_key  # → YC_SA_KEY в infra-k8s репо
terraform output -raw ci_apps_sa_key   # → YC_SA_KEY в репозиториях сервисов
```

## Сервисные аккаунты

| SA | Роли | Используется в |
|---|---|---|
| `sa-terraform` | `admin` на каталог | Terraform (создаёт SA и назначает IAM-роли, поэтому нужен `admin`, а не `editor`) |
| `k8s-sa` | `k8s.clusters.agent`, `vpc.publicAdmin`, `container-registry.images.puller` | Кластером Kubernetes |
| `registry-pusher-sa` | `container-registry.images.pusher` на user-apps registry | Build-воркером deployments-service |
| `lifecycle-manager-sa` | `container-registry.editor` на user-apps registry | CronJob очистки образов |
| `ci-infra-sa` | `k8s.cluster-api.cluster-admin` | infra-k8s пайплайн |
| `ci-apps-sa` | `k8s.cluster-api.editor`, `container-registry.images.pusher` | Пайплайны сервисов |

## Полезные команды

```bash
terraform plan  -var-file=../dev.tfvars   # предварительный просмотр изменений
terraform apply -var-file=../dev.tfvars   # применить
terraform destroy -var-file=../dev.tfvars # удалить все ресурсы

yc managed-kubernetes cluster list
yc container registry list
yc dns zone list
```
