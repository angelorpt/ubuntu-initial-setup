# Design

## Context

Moji is distributed via GitHub Releases as `.deb` assets for `amd64`.
Repository: `https://github.com/alexishida/Moji`.

## Goals / Non-Goals

**Goals:**
- Provide `install_moji()` in `install/tools_desktop.sh`.
- Automatically resolve the latest release asset download URL (`Moji-*-amd64.deb`) from GitHub API, with a pinned fallback version (e.g. `1.0.7`) if unauthenticated rate limit is reached.
- Use `download_to_temp` and `install_deb` from `lib/utils.sh` adhering to DRY and defensive shell guidelines.
- Register Moji in `lib/catalog.sh` with descriptions in `en` and `pt`.

**Non-Goals:**
- Compiling from source or running on non-Debian distributions.

## Decisions

- **Dynamic release detection:**
  Use `curl -fsSL https://api.github.com/repos/alexishida/Moji/releases/latest` to parse `browser_download_url` matching `.*amd64\.deb`. If parsing fails, fall back to `https://github.com/alexishida/Moji/releases/download/v1.0.7/Moji-1.0.7-amd64.deb`.
- **Classification:** Belongs to `TOOLS_DESKTOP`, automatically excluded in headless profile (`catalog_module_is_gui TOOLS_DESKTOP` returns true).

## Risks / Trade-offs

- **[Risk] GitHub API rate limiting** → **Mitigation:** Fallback URL guarantees installation succeeds even when rate-limited.
