# Gitpod上での Keycloak (WildFly版 v16.1.1) 構築・起動手順まとめ

このドキュメントは、Gitpod上でKeycloak (WildFly版 16.1.1) をHTTPS環境で構築・起動するまでの、**実際に必要だった作業手順**を時系列で簡潔にまとめたものです。

---

## ✅ 環境前提

- Gitpod アカウント（GitHub連携済み）
- Gitpodで作業用リポジトリを作成済み（例: `First-Keycloak`）
- Gitpodが起動後、VSCode + bashターミナルで操作可能な状態

---

## 📦 Keycloak のダウンロードと展開

```bash
wget https://github.com/keycloak/keycloak/releases/download/16.1.1/keycloak-16.1.1.zip
unzip keycloak-16.1.1.zip
```

---

## 🔐 管理者ユーザーの追加

```bash
./keycloak-16.1.1/bin/add-user-keycloak.sh -u admin -p admin
```

---

## �� HTTPS対応：自己署名証明書の作成

```bash
cd keycloak-16.1.1/standalone/configuration
keytool -genkeypair \
  -alias selfsigned \
  -keyalg RSA \
  -keysize 2048 \
  -validity 365 \
  -storetype JKS \
  -keystore application.keystore \
  -storepass password \
  -keypass password \
  -dname "CN=localhost, OU=Dev, O=Company, L=Tokyo, S=Tokyo, C=JP"
```

> `application.keystore` は `standalone.xml` にあらかじめ設定済み

---

## 🔁 起動スクリプトの用意

`restart-keycloak.sh` を作成：

```bash
#!/bin/bash
echo "🛑 既存のKeycloakプロセスを停止中..."
pkill -f keycloak

echo "🚀 KeycloakをHTTPSとHTTPで再起動します..."
cd /workspace/spring-petclinic/keycloak-16.1.1
nohup ./bin/standalone.sh -b=0.0.0.0 -Djboss.https.port=8443 > standalone/log/server.log 2>&1 &

echo "⏳ 起動待機中（/auth が登録されるまで待機）..."
until grep -q "Registered web context: '/auth'" standalone/log/server.log; do
  sleep 1
done

echo "✅ Keycloak 起動完了"
```

---

## 🌐 Gitpod `.gitpod.yml` の自動起動設定

```yaml
tasks:
  - name: Start Keycloak
    init: ./restart-keycloak.sh
    openMode: open-preview

ports:
  - port: 8080
    onOpen: open-preview
```

---

## 🌍 管理コンソールアクセスURL

- HTTP: `https://8080-[ワークスペースID].gitpod.io/auth`
- ※ Gitpod では **HTTPS(8443)は中継非対応** のため、外部アクセスできません。

---

## 🧼 Spring Boot PetClinic の影響排除

`/workspace/spring-petclinic` に元々含まれていた Spring Boot の起動プロセスを `pkill` で停止。  
不要ファイルや `.git` の削除を行い、自身のリポジトリとして再構成。

---

## 📌 備考

- `application-users.properties` はコメントアウトされていても、`keycloak-add-user.json` によってユーザー登録済み。
- Gitpodでは `https` ポートが実質利用不可であるため、開発中は `http://8080-...` を利用。

---

⏱ 最終更新: 2025-04-16 06:47:31

