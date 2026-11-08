# Changelog

All notable changes to Pigeon Indicators are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

- **Major** versions can need changes to your configuration or other resources. Read the **Upgrade notes**.
- **Minor** versions add features without breaking existing setups.
- **Patch** versions fix bugs only.

## [Unreleased]

First release.

### Highlights

- Indicators and hazards on the arrow keys
- Synced for every player, even ones who arrive later
- Indicators off by themselves after a turn
- Driver only, checked by the server
- 23 languages

### Added

- Left and right indicators and hazard lights on three keys (the Left, Right and Down arrows by default, which players can change in GTA's key bindings) or `/indicatorleft`, `/indicatorright` and `/hazards`.
- Lights synced to every player through a server-set `pigeonIndicators` vehicle state bag, with the server checking the player is the driver.
- `Config.AutoCancel` and `Config.CancelDegrees`: the indicator turns off once the vehicle has turned and the wheel is straight.
- `Config.BlockedClasses`, and a `GetIndicators` client export.
- Key binding names in 23 languages, following ox_lib's language with `Config.Locale = 'auto'`.
- Update checker from the Pigeon Studios version registry.

[Unreleased]: https://github.com/pigeon-studios-uk/pigeon-indicators/commits/main
