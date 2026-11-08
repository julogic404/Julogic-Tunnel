#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  setup-deps.sh — baixa tudo o que a app precisa antes do build.
#
#  Gera:
#    app/src/main/jniLibs/<abi>/libxray.so       (Xray-core, standalone)
#    app/src/main/jniLibs/<abi>/libhev-socks5-tunnel.so  (hev-socks5-tunnel, JNI — compilada com o NDK)
#    app/src/main/assets/xray/geoip.dat
#    app/src/main/assets/xray/geosite.dat
#
#  ABIs cobertas: arm64-v8a, armeabi-v7a, x86_64, x86
#  (têm de coincidir com abiFilters em app/build.gradle.kts)
#
#  Ficheiros já presentes (e não vazios) são ignorados — é seguro correr
#  várias vezes. Para forçar novo download, apaga o ficheiro em questão.
#
#  Uso:  ./scripts/setup-deps.sh [versao-xray]     ex: ./scripts/setup-deps.sh 1.8.24
# ---------------------------------------------------------------------------
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
JNI="$RAIZ/app/src/main/jniLibs"
ASSETS="$RAIZ/app/src/main/assets/xray"
LIBS="$RAIZ/app/libs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

XRAY_VER="${1:-1.8.24}"
TUN2SOCKS_VER="${TUN2SOCKS_VER:-2.7.2}"

need() { command -v "$1" >/dev/null 2>&1 || { echo "✗ falta a ferramenta '$1'"; exit 1; }; }
need curl
need unzip

# abi_android -> nome do artefacto Xray
xray_asset() {
  case "$1" in
    arm64-v8a)   echo "Xray-android-arm64-v8a.zip" ;;
    armeabi-v7a) echo "Xray-linux-arm32-v7a.zip" ;;
    x86_64)      echo "Xray-linux-64.zip" ;;
    x86)         echo "Xray-linux-32.zip" ;;
  esac
}

# abi_android -> nome do binário hev-socks5-tunnel
tun2socks_asset() {
  case "$1" in
    arm64-v8a)   echo "hev-socks5-tunnel-linux-arm64" ;;
    armeabi-v7a) echo "hev-socks5-tunnel-linux-arm32" ;;
    x86_64)      echo "hev-socks5-tunnel-linux-x86_64" ;;
    x86)         echo "hev-socks5-tunnel-linux-x86_32" ;;
  esac
}

ABIS=(arm64-v8a armeabi-v7a x86_64 x86)

mkdir -p "$ASSETS"

# ---------------------------------------------------------------------------
#  Xray-core (+ geoip.dat / geosite.dat extraídos do zip)
# ---------------------------------------------------------------------------
echo "▶ Xray-core v$XRAY_VER"
for abi in "${ABIS[@]}"; do
  asset="$(xray_asset "$abi")"
  destino="$JNI/$abi/libxray.so"
  mkdir -p "$JNI/$abi"

  geo_em_falta=0
  [ -s "$ASSETS/geoip.dat" ]   || geo_em_falta=1
  [ -s "$ASSETS/geosite.dat" ] || geo_em_falta=1

  if [ -s "$destino" ] && [ "$geo_em_falta" -eq 0 ]; then
    echo "  • $abi — já presente, ignorado"
    continue
  fi

  url="https://github.com/XTLS/Xray-core/releases/download/v$XRAY_VER/$asset"
  echo "  • $abi ← $asset"
  if ! curl -fsSL -o "$TMP/$asset" "$url"; then
    echo "    ✗ download falhou ($url)"; continue
  fi
  rm -rf "$TMP/x-$abi"; mkdir -p "$TMP/x-$abi"
  unzip -qo "$TMP/$asset" -d "$TMP/x-$abi"
  cp "$TMP/x-$abi/xray" "$destino"
  chmod 755 "$destino"
  [ -s "$ASSETS/geoip.dat" ]   || cp "$TMP/x-$abi/geoip.dat"   "$ASSETS/geoip.dat"   2>/dev/null || true
  [ -s "$ASSETS/geosite.dat" ] || cp "$TMP/x-$abi/geosite.dat" "$ASSETS/geosite.dat" 2>/dev/null || true
done

# ---------------------------------------------------------------------------
#  tun2socks (hev-socks5-tunnel) — biblioteca JNI, compilada com o NDK.
#  (O executável "hev-socks5-tunnel-linux-*" é para Linux e não funciona numa app Android:
#   cria a sua própria TUN e ignora o descritor da VpnService.)
# ---------------------------------------------------------------------------
echo "▶ tun2socks (hev-socks5-tunnel v$TUN2SOCKS_VER, JNI)"
precisa_hev=0
for abi in "${ABIS[@]}"; do
  [ -s "$JNI/$abi/libhev-socks5-tunnel.so" ] || precisa_hev=1
done
if [ "$precisa_hev" -eq 0 ]; then
  echo "  • já presente em todas as ABIs, ignorado"
else
  HEV_VER="$TUN2SOCKS_VER" "$(dirname "$0")/build-hev-jni.sh" || \
    echo "  ✗ compilação do tun2socks falhou — vê a mensagem acima (precisa do Android NDK)"
fi

# ---------------------------------------------------------------------------
#  dnstt-client (DNS Tunnel) — OPCIONAL. Compilado a partir da fonte com Go.
#  Sem Go (ex.: Termux/IDE mobile), este passo é ignorado com aviso; a app
#  continua a compilar e todos os outros protocolos funcionam — só o DNS
#  Tunnel reportará "binário em falta" se for usado.
# ---------------------------------------------------------------------------
echo "▶ dnstt-client (opcional)"
dnstt_goarch() {
  case "$1" in
    arm64-v8a)   echo "arm64" ;;
    armeabi-v7a) echo "arm" ;;
    x86_64)      echo "amd64" ;;
    x86)         echo "386" ;;
  esac
}

precisa_dnstt=0
for abi in "${ABIS[@]}"; do
  [ -s "$JNI/$abi/libdnstt.so" ] || precisa_dnstt=1
done

if [ "$precisa_dnstt" -eq 0 ]; then
  echo "  • já presente em todas as ABIs, ignorado"
elif ! command -v go >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
  echo "  ⚠ 'go'/'git' não disponíveis — a saltar (DNS Tunnel ficará indisponível)"
  echo "    Todos os outros protocolos funcionam normalmente."
else
  SRC="$TMP/dnstt"
  if git clone --depth 1 https://www.bamsoftware.com/git/dnstt.git "$SRC" >/dev/null 2>&1; then
    for abi in "${ABIS[@]}"; do
      destino="$JNI/$abi/libdnstt.so"
      mkdir -p "$JNI/$abi"
      if [ -s "$destino" ]; then echo "  • $abi — já presente, ignorado"; continue; fi
      echo "  • $abi ← build (GOARCH=$(dnstt_goarch "$abi"))"
      if (cd "$SRC/dnstt-client" && CGO_ENABLED=0 GOOS=linux GOARCH="$(dnstt_goarch "$abi")" \
            GOARM=7 go build -trimpath -ldflags "-s -w" -o "$destino" . >/dev/null 2>&1); then
        chmod 755 "$destino"
      else
        rm -f "$destino"
        echo "    ✗ build falhou para $abi"
      fi
    done
  else
    echo "  ✗ não foi possível clonar a fonte do dnstt"
  fi
fi

# ---------------------------------------------------------------------------
#  JSch — vem do Gradle (com.github.mwiede:jsch). O jar legado em app/libs
#  duplica as classes com.jcraft.jsch.* e faz falhar o build; é removido.
# ---------------------------------------------------------------------------
echo "▶ JSch"
if ls "$LIBS"/jsch-*.jar >/dev/null 2>&1; then
  rm -f "$LIBS"/jsch-*.jar
  echo "  • jar legado removido (usa-se com.github.mwiede:jsch via Gradle)"
else
  echo "  • nada a fazer (JSch vem do Gradle)"
fi

# ---------------------------------------------------------------------------
#  Verificação final
# ---------------------------------------------------------------------------
echo "▶ Verificação final"
falta=0
for abi in "${ABIS[@]}"; do
  for lib in libxray.so libhev-socks5-tunnel.so libdnstt.so; do
    if [ -s "$JNI/$abi/$lib" ]; then
      printf "  ✓ %-12s %s (%s bytes)\n" "$abi" "$lib" "$(wc -c < "$JNI/$abi/$lib" | tr -d ' ')"
    elif [ "$lib" = "libdnstt.so" ]; then
      printf "  ⚠ %-12s %s ausente (opcional — DNS Tunnel indisponível)\n" "$abi" "$lib"
    else
      printf "  ✗ %-12s %s EM FALTA\n" "$abi" "$lib"; falta=1
    fi
  done
done
for f in "$ASSETS/geoip.dat" "$ASSETS/geosite.dat"; do
  if [ -s "$f" ]; then
    printf "  ✓ assets: %s (%s bytes)\n" "$(basename "$f")" "$(wc -c < "$f" | tr -d ' ')"
  else
    printf "  ✗ assets: %s EM FALTA\n" "$(basename "$f")"; falta=1
  fi
done

if [ "$falta" -eq 0 ]; then
  echo "✅ Tudo pronto — podes compilar (./gradlew assembleDebug)."
else
  echo "⚠️  Faltam ficheiros. Sem eles, o Xray/tun2socks não funcionará em runtime."
  exit 1
fi
