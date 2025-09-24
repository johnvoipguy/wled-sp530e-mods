# SP530E Configuration Package

This package contains all the SP530E-specific modifications that can be applied to any WLED version.

## 📦 Package Contents:
- `platformio_sp530e.ini` - SP530E environment configuration
- `tools/` - ESP32-C3 partition tables and tools
- `.github/workflows/` - Automated build and release system
- `apply_sp530e.sh` - Automatic application script

## 🚀 Quick Setup (Any WLED Version):

```bash
# 1. Clone fresh WLED (any version)
git clone https://github.com/Aircoookie/WLED.git wled-v0.16-sp530e
cd wled-v0.16-sp530e

# 2. Apply SP530E package
curl -sSL https://raw.githubusercontent.com/johnvoipguy/wled-sp530e-mods/main/sp530e_config_package/apply_sp530e.sh | bash

# 3. Build
pio run -e sp530e
```

## 📋 Manual Application:

If you prefer manual setup:

1. **Add to platformio.ini:**
   ```ini
   [env:sp530e]
   board = lolin_c3_mini
   platform = espressif32@6.8.1
   # ... (see platformio_sp530e.ini)
   ```

2. **Copy tools/** directory for ESP32-C3 partition tables

3. **Copy .github/workflows/** for automated builds

4. **Build:** `pio run -e sp530e`

## 🔄 Version Management:

Each WLED version gets its own directory:
```
workspace/
├── wled-v0.15.x-sp530e/  ← Stable
├── wled-v0.16.x-sp530e/  ← Testing  
└── wled-main-sp530e/     ← Bleeding edge
```

Switch between versions by simply changing directories!