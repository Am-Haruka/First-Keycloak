#!/bin/bash

# Keycloakルートディレクトリ
KC_HOME="/workspace/spring-petclinic/keycloak-16.1.1"

# 既存のKeycloakプロセスを停止
echo "🛑 既存のKeycloakプロセスを停止中..."
pkill -f "$KC_HOME"

# 数秒待機して確実に止める
sleep 2

# 再起動
echo "🚀 KeycloakをHTTPSとHTTPで再起動します..."
nohup "$KC_HOME/bin/standalone.sh" -b=0.0.0.0 > "$KC_HOME/standalone/log/server.log" 2>&1 &

# 起動待ち（ログの一部を監視）
echo "⏳ 起動待機中（/auth が登録されるまで待機）..."
while ! grep -q "Registered web context: '/auth'" "$KC_HOME/standalone/log/server.log"; do
  sleep 1
done

# GitpodのURLを自動抽出
GITPOD_HOST=$(gp url 8080 2>/dev/null)

echo "✅ 管理コンソールはこちら:"
echo "$GITPOD_HOST/auth"
