# whisper.cpp server (powerant)

OpenAI-compatible speech-to-text endpoint on `0.0.0.0:8080`, GPU-accelerated.
Reachable over Tailscale as `http://powerant:8080`; consumed by voxtype, Home
Assistant and OpenClaw.

## Pieces

| What | Where |
|---|---|
| Unit (versioned here) | `systemd/system/whisper-server.service` |
| Installed as | symlink at `/etc/systemd/system/whisper-server.service` |
| Binary | `/usr/bin/whisper-server`, from `extra/whisper-cpp` |
| Model | `~/.local/share/voxtype/models/ggml-large-v3.bin` |
| Endpoint path | `/v1/audio/transcriptions` |

The unit is a symlink into this repo, so edit it here (no sudo) and
`sudo systemctl daemon-reload && sudo systemctl restart whisper-server`.

## Install on a fresh machine

```sh
sudo pacman -S whisper-cpp
sudo ln -sf ~/.dotfiles/systemd/system/whisper-server.service \
  /etc/systemd/system/whisper-server.service
sudo systemctl daemon-reload
sudo systemctl enable --now whisper-server.service
```

## GPU acceleration

Vulkan, via `libggml-vulkan` provided by `llama.cpp-vulkan` (AUR) — `whisper-cpp`
depends on plain `ggml`, and `llama.cpp-vulkan` satisfies that with
`provides=ggml ggml-vulkan`. So the official package gets GPU without needing a
Vulkan-specific whisper build.

Confirm it picked up the GPU:

```sh
journalctl -u whisper-server -b | grep ggml_vulkan
# ggml_vulkan: 0 = AMD Radeon 8060S Graphics (RADV STRIX_HALO) ...
```

If that line is missing it fell back to CPU — transcription still works, just
much slower.

## Smoke test

```sh
curl -X POST http://127.0.0.1:8080/v1/audio/transcriptions \
  -F file=@some.wav -F response_format=json
```

## History: the 2026-08 breakage

It used to be `whisper.cpp-vulkan` (AUR) with the package's own unit plus a
drop-in override. Two things broke it:

1. ffmpeg 8 → 9 moved `libavformat.so.62` to `.so.63`, and the prebuilt binary
   died with `error while loading shared libraries` (exit 127).
2. `whisper.cpp-vulkan` had been **deleted from the AUR**, so there was nothing
   left to rebuild against.

Replaced with `extra/whisper-cpp` (official, tracks ffmpeg bumps automatically)
plus the standalone unit above.

**Watch out:** `whisper-server` links against `llama.cpp-vulkan`'s libggml. A
soname bump there can still break it — the fix would be a `whisper-cpp` rebuild,
not a config change.
