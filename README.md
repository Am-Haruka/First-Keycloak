# First-Keycloak (WildFly版 Keycloak 16.1.1 on Gitpod)

このリポジトリは、Gitpod 上に Keycloak (WildFly版) をセットアップし、ブラウザから管理コンソールを使用する環境構築例です。

---

## 🚀 起動手順

### 🔧 事前準備（Gitpodで一度セットアップした後）
```bash
# ① Keycloak管理ユーザーを作成（初回のみ）
./keycloak-16.1.1/bin/add-user-keycloak.sh -u admin -p admin
```

---

### 🏁 起動方法
```bash
./restart-keycloak.sh
```

> 上記スクリプトは 8080 (HTTP) / 8443 (HTTPS) の両方で起動され、`/auth` のエンドポイントが使用可能になります。

---

## 🌐 アクセス方法（Gitpod）

### 🔗 管理コンソール
`https://8080-<Gitpodのワークスペース名>.gitpod.io/auth`

例:  
```
https://8080-abcdef1234.ws-us123.gitpod.io/auth
```

🔑 初期ログイン情報:
- ユーザー名: `admin`
- パスワード: `admin`

---

## 📦 内容物

| ディレクトリ/ファイル            | 説明                                       |
|----------------------------------|--------------------------------------------|
| `keycloak-16.1.1/`               | Keycloak本体（WildFlyベース）             |
| `restart-keycloak.sh`           | 起動スクリプト（プロセス再起動＋待機処理） |
| `application.keystore`          | HTTPS用の自己署名証明書                   |

---

## 📚 補足情報

- WildFlyベースのKeycloakは2022年に16.1.1で終了し、以降はQuarkusベースに移行しています。
- Gitpodではポート公開に制限があり、**HTTPS (8443)** は外部公開できないため、**HTTP (8080)** を利用してください。

---

## 🧪 開発環境

- Gitpod (Ubuntu Linuxベース)
- OpenJDK 11
- Keycloak 16.1.1
- curl / wget / unzip など標準ユーティリティ

---

## 📝 ライセンス

MIT License
