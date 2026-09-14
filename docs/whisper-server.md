# whisper.cpp server (powerant)

**La fuente de verdad de este servicio vive en el repo `homelab`:
[`powerant/whisper/README.md`](../../homelab/powerant/whisper/README.md).**
Ahi estan la unidad versionada, el despliegue, la aceleracion Vulkan y el historial.

Este documento solo cubre lo que toca a dotfiles: el cliente.

## Que es

Endpoint de speech-to-text compatible con OpenAI en `0.0.0.0:8080` de `powerant`,
acelerado por GPU. Accesible por LAN/Tailscale como `http://powerant:8080`.
Lo consumen voxtype, Home Assistant y OpenClaw.

## Lo que hay aqui

| Que | Donde |
|---|---|
| Config de voxtype | `hyprland/.config/voxtype/config.toml` (`backend = "remote"`) |
| Limpieza de transcripcion | `bin/.local/bin/voxtype-clean-transcript` |
| Servicio voxtype | unidad de usuario, ver [hyprland.md](hyprland.md#voxtype) |

Los modelos (`ggml-large-v3.bin` y compania) viven en `~/.local/share/voxtype/models/`
y los comparten voxtype y el servidor.

## Lo que ya NO esta aqui

Hasta el `2026-09-14` este repo versionaba `systemd/system/whisper-server.service`,
instalado como symlink en `/etc/systemd/system/`.

**Eso rompia el arranque.** `/home` es un subvolumen btrfs de la raiz LUKS: cuando systemd
enumera unidades en el boot, el destino del symlink aun no es legible, el enlace queda
colgante y la unidad no existe para systemd. El sintoma despista, porque `is-enabled`
sigue diciendo `enabled` mientras `status` dice `could not be found`.

La unidad se migro a **servicio de usuario** y se movio al repo `homelab`. Como no necesita
privilegios (puerto > 1024, `/dev/dri/renderD128` accesible por cualquiera, modelo bajo
`$HOME`), un servicio de usuario le sobra, y ademas arranca tras montar `/home`.

**Regla general:** no symlinkear unidades de sistema desde `$HOME`. O fichero real en `/etc`
desplegado con `install`, o unidad de usuario.

## Smoke test

```sh
curl -X POST http://powerant:8080/v1/audio/transcriptions \
  -F file=@some.wav -F response_format=json
```
