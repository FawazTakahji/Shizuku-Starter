# Shizuku Starter

A Magisk / KernelSU / APatch module that automatically starts Shizuku on boot — using either **root** or **ADB** privileges.

## Installation

1. Flash the module via your root manager.
2. Edit the config file using a root-capable file manager before rebooting (see [Configuration](#configuration) below).
3. Reboot your device. Shizuku will start automatically.

> [!IMPORTANT]
> The module will **not** start Shizuku until the config file has been properly set up. A notification will remind you if the configuration is incomplete.

## Configuration

The config file is located at `/data/adb/shizuku-starter/config.txt`.

| Option | Description | Default |
|---|---|---|
| `mode` | Privilege level used to start Shizuku. Set to `adb` or `root`. | `adb` |
| `libshizuku` | Path to `libshizuku.so`. Set to `AUTO_SEARCH` or provide the full absolute path. | *(empty — must be set)* |

> [!TIP]
> **Manually specifying `libshizuku`** is recommended for stability and security. To find the path, search for `libshizuku.so` under `/data/app/` using a root file manager. It will look something like:
> ```
> /data/app/~~XXXXXXXX==/moe.shizuku.privileged.api-XXXXXXXX==/lib/arm64/libshizuku.so
> ```
> Using `AUTO_SEARCH` is convenient but will pick the **first result** found, which may result in the execution of malicious code.

## Manual Start (Action)

The module supports the **Action** feature in compatible root managers. Tapping the Action button will:

1. Check if Shizuku is already running — if so, it exits early.
2. Read your config file and attempt to start Shizuku immediately, without requiring a reboot.

## Credits

- [shizuku-auto-starter](https://github.com/merbah3266/shizuku-auto-starter) by merbah3266 — the original inspiration for this module.
