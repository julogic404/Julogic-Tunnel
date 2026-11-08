#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  Compila a biblioteca JNI do tun2socks (hev-socks5-tunnel) para o Android.
#
#  Porquê compilar e não descarregar: os binários publicados ("hev-socks5-tunnel-linux-*")
#  são para Linux — criam a sua própria TUN e não aceitam o descritor da VpnService.
#  No Android a forma oficial é a biblioteca JNI, usada pela classe
#  hev.htproxy.TProxyService (nucleo/src/main/java/hev/htproxy/).
#
#  Requisitos: git e o Android NDK (variável ANDROID_NDK_HOME ou ANDROID_NDK_ROOT,
#  ou o NDK instalado em $ANDROID_HOME/ndk/<versão>).
#
#  Resultado: app/src/main/jniLibs/<abi>/libhev-socks5-tunnel.so
# ---------------------------------------------------------------------------
set -euo pipefail

HEV_VER="${HEV_VER:-2.7.2}"
ABIS=(arm64-v8a armeabi-v7a x86_64 x86)
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
JNI="$RAIZ/app/src/main/jniLibs"
TMP="$RAIZ/build/hev-jni"

# ---- localizar o NDK ----
NDK="${ANDROID_NDK_HOME:-${ANDROID_NDK_ROOT:-}}"
if [ -z "$NDK" ] && [ -n "${ANDROID_HOME:-}" ] && [ -d "$ANDROID_HOME/ndk" ]; then
  NDK="$(ls -d "$ANDROID_HOME"/ndk/* 2>/dev/null | sort -V | tail -n1 || true)"
fi
if [ -z "$NDK" ] || [ ! -x "$NDK/ndk-build" ]; then
  echo "✗ Android NDK não encontrado." >&2
  echo "  Instala o NDK (Android Studio → SDK Manager → SDK Tools → NDK) e define" >&2
  echo "  ANDROID_NDK_HOME=/caminho/para/ndk/<versão> antes de correr este script." >&2
  exit 1
fi
command -v git >/dev/null 2>&1 || { echo "✗ git não encontrado." >&2; exit 1; }

# ---- já compilado? ----
todas=1
for abi in "${ABIS[@]}"; do [ -s "$JNI/$abi/libhev-socks5-tunnel.so" ] || todas=0; done
if [ "$todas" -eq 1 ] && [ "${FORCAR:-0}" != "1" ]; then
  echo "✓ libhev-socks5-tunnel.so já presente em todas as ABIs (FORCAR=1 para recompilar)."
  exit 0
fi

# ---- obter a fonte ----
echo "▶ hev-socks5-tunnel v$HEV_VER (NDK: $NDK)"
rm -rf "$TMP"; mkdir -p "$TMP"
git clone --quiet --recursive --depth 1 --branch "$HEV_VER" \
    https://github.com/heiher/hev-socks5-tunnel "$TMP/jni"

# ---- compilar (o projeto espera estar numa pasta "jni") ----
cd "$TMP"
"$NDK/ndk-build" \
  NDK_PROJECT_PATH=. \
  APP_BUILD_SCRIPT=jni/Android.mk \
  "APP_ABI=${ABIS[*]}" \
  APP_PLATFORM=android-21 \
  NDK_LIBS_OUT="$TMP/libs" \
  NDK_OUT="$TMP/obj" \
  "APP_CFLAGS=-O3 -DPKGNAME=hev/htproxy -DCLSNAME=TProxyService" \
  "APP_LDFLAGS=-Wl,--build-id=none -Wl,--hash-style=gnu"

# ---- copiar para a app ----
for abi in "${ABIS[@]}"; do
  origem="$TMP/libs/$abi/libhev-socks5-tunnel.so"
  if [ -s "$origem" ]; then
    mkdir -p "$JNI/$abi"
    cp "$origem" "$JNI/$abi/libhev-socks5-tunnel.so"
    printf "  ✓ %-12s libhev-socks5-tunnel.so (%s bytes)\n" "$abi" "$(wc -c < "$origem" | tr -d ' ')"
  else
    echo "  ✗ $abi — não foi gerada ($origem)"
  fi
done
echo "✅ Biblioteca do tun2socks pronta."
