# opensim-simulator

`opensim-simulator` is a containerized OpenSimulator build tailored for the OpenSim AI stack.

It is intended to be used as part of the **OpenSim Stack** project:
**"A docker stack to get an AI integrated virtual world up and running in minutes."**

## What This Image Does

- Intended for use as both *Robust* services, *Simulator* instances, and standalone mode 
- Launches appropriate simulator services depending on configuration files
- Allows for isolated configuration

## Required Volume Mounts

- `opensim-simulator-config` -> `/config`

## Quick Start

```
 my-config
    |
    |\___ OpenSim.ini
    |\___ startup_commands.txt    # optional
    |\___ shutdown_commands.txt    # optional
    |\___ Regions
    |      \__ Region.ini
     \___ config-include
            |\__ Standalone.ini
            |\__ StandaloneCommon.ini
            |\__ FloatsamCache.ini
             \__ storage
                    \__SQLiteStandalone.ini
```

Run the container.

```bash
docker run --rm \
  -p 9000:9000 \
  -v  my-config:/config \
  bithatch/opensim-simulator:latest
```

## Project Links

- Main AI Stack (`opensim-ai-docker`): https://github.com/opensim-stack/opensim-ai-docker
- `opensim-piper` on GitHub: https://github.com/opensim-stack/opensim-piper
- Piper project: https://github.com/OHF-Voice/piper1-gpl
- Related services:
  - `opensim-console2mcp`: https://github.com/opensim-stack/opensim-console2mcp
  - `opensim-metaverse2mcp`: https://github.com/opensim-stack/opensim-metaverse2mcp
  - `opensim-opencode`: https://github.com/opensim-stack/opensim-opencode
