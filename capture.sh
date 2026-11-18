#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${CAPTURE_URL:?Set CAPTURE_URL to the exact preview URL to capture.}"
: "${CAPTURE_DIR:?Set CAPTURE_DIR to the evidence output directory.}"
: "${RUNTIME_DIR:?RUNTIME_DIR must point to the installed OMGithub runtime.}"

case "$CAPTURE_URL" in http://*|https://*) ;; *) echo 'CAPTURE_URL must be an absolute HTTP(S) URL.' >&2; exit 1 ;; esac
case "$CAPTURE_DIR" in /*) ;; *) echo 'CAPTURE_DIR must be an absolute path.' >&2; exit 1 ;; esac
case "$CAPTURE_DIR/" in "$PROJECT_DIR/"*) echo 'Capture evidence must be outside the project source tree.' >&2; exit 1 ;; esac

run() { /usr/bin/time -p "$@"; }
run mkdir -p "$CAPTURE_DIR"
# A visible canvas is the rendered-content readiness check for this game.
export CAPTURE_READY_SELECTOR="${CAPTURE_READY_SELECTOR:-canvas}"
export CAPTURE_START_SELECTOR="${CAPTURE_START_SELECTOR:-#start}"
run node "$RUNTIME_DIR/scripts/default-capture.mjs"
for screenshot in "$CAPTURE_DIR/final-desktop.png" "$CAPTURE_DIR/final-mobile.png"; do
  [[ -s "$screenshot" ]] || { echo "Missing rendered screenshot: $screenshot" >&2; exit 1; }
done
