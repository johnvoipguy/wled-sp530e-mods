# SP530E WLED Upgrade Checklist

## Overview
This checklist ensures all SP530E customizations are properly applied when upgrading to newer WLED versions.

## Pre-Upgrade Backup
- [ ] **Backup current working firmware:** Copy `build_output/release/WLED_0.15.1_SP530E-JW.bin`
- [ ] **Backup custom files:** Save copies of all modified files (see file list below)
- [ ] **Document current version:** Note the current WLED version and commit hash

## Custom Files to Preserve/Recreate

### 1. PlatformIO Configuration
- [ ] **File:** `platformio.ini` 
- [ ] **Section:** `[env:sp530e]` environment
- [ ] **Key settings:**
  ```ini
  [env:sp530e]
  extends = esp32c3
  board = esp32-c3-devkitm-1
  board_build.partitions = tools/WLED_ESP32C3_4MB_audioreactive.csv
  build_flags = 
    -D WLED_RELEASE_NAME=\"SP530E-JW\"
    -D LEDPIN=19
    -D DATA_PINS=19
    -D BTNPIN=8,-1
    -D USERMOD_AUDIOREACTIVE
    -D MIC_PIN=3
    -D USERMOD_PWM_OUTPUTS
    -D USERMOD_PWM_OUTPUT_PINS=5
    -D USERMOD_WIFI_STATUS_LED
    -D WIFI_STATUS_LED_PIN=0
    -D WIFI_STATUS_LED_INVERTED=1
    -D USERMOD_BOOT_STATUS_LED
    -D BOOT_STATUS_LED_PIN=1
    -D BOOT_STATUS_LED_INVERTED=1
  lib_deps = kosme/arduinoFFT @ 2.0.1
  ```

### 2. Core WLED Integration Files
- [ ] **File:** `wled00/usermods_list.cpp`
- [ ] **Add includes:**
  ```cpp
  #ifdef USERMOD_WIFI_STATUS_LED
  #include "../usermods/wifi_status_led/wifi_status_led.h"
  #endif
  #ifdef USERMOD_BOOT_STATUS_LED
  #include "../usermods/boot_status_led/boot_status_led.h"
  #endif
  ```
- [ ] **Add registrations in `registerUsermods()`:**
  ```cpp
  #ifdef USERMOD_WIFI_STATUS_LED
    UsermodManager::add(new WiFiStatusLEDUsermod());
  #endif
  #ifdef USERMOD_BOOT_STATUS_LED
    UsermodManager::add(new BootStatusLEDUsermod());
  #endif
  ```

- [ ] **File:** `wled00/const.h`
- [ ] **Add usermod IDs:**
  ```cpp
  #define USERMOD_ID_WIFI_STATUS_LED    55
  #define USERMOD_ID_BOOT_STATUS_LED    56
  ```

### 3. Custom Usermod Files
- [ ] **Directory:** `usermods/wifi_status_led/`
  - [ ] **File:** `wifi_status_led.h` (WiFi connection status LED)
- [ ] **Directory:** `usermods/boot_status_led/`
  - [ ] **File:** `boot_status_led.h` (Boot success indicator LED)

### 4. Partition Table
- [ ] **File:** `tools/WLED_ESP32C3_4MB_audioreactive.csv`
- [ ] **Verify:** Custom partition layout for 4MB flash with AudioReactive support

## Upgrade Process

### Step 1: Prepare for New WLED Version

**Option A: Safe Parallel Installation (Recommended)**
```bash
# Clone fresh copy alongside current installation
cd /workspace
git clone https://github.com/Aircoookie/WLED.git WLED_new
cd WLED_new
git log --oneline -10       # Note new version/commit

# Your current WLED stays in /workspace (untouched)
# New version is in /workspace/WLED_new
```

**Option B: Update Current Installation (Riskier)**
```bash
# Backup first! Run backup_sp530e.sh
git stash                    # Stash current changes
git pull origin main        # Get latest version
git log --oneline -10       # Note new version/commit
```

### Step 2: Check for Breaking Changes
- [ ] **Review:** CHANGELOG.md for breaking changes
- [ ] **Check:** AudioReactive usermod compatibility
- [ ] **Verify:** ArduinoFFT library version requirements
- [ ] **Confirm:** ESP32-C3 support status

### Step 3: Reapply SP530E Customizations
- [ ] **Restore:** SP530E environment in `platformio.ini`
- [ ] **Recreate:** Custom usermod directories and files
- [ ] **Update:** `usermods_list.cpp` includes and registrations
- [ ] **Add:** Usermod ID constants to `const.h`
- [ ] **Verify:** Partition table exists or recreate if needed

### Step 4: Handle Version-Specific Updates
- [ ] **ArduinoFFT:** Check if syntax has changed (v1.x vs v2.x)
- [ ] **ESP32-C3:** Verify platform and framework versions
- [ ] **Dependencies:** Update library versions if needed
- [ ] **Build flags:** Check for new or changed build options

### Step 5: Test Build
```bash
# Clean build to ensure no cached issues
platformio run -e sp530e --target clean
platformio run -e sp530e
```

### Step 6: Verify Build Output
- [ ] **Check:** Build completes without errors
- [ ] **Verify:** Flash usage is reasonable (<80%)
- [ ] **Confirm:** All expected features are included
- [ ] **Test:** Generate full flash image if needed

## Post-Upgrade Testing

### Build Verification
- [ ] **Size check:** Firmware fits in partition (should be <1.9MB)
- [ ] **Feature test:** All usermods compile successfully
- [ ] **Dependency test:** ArduinoFFT links correctly

### Hardware Testing (if possible)
- [ ] **Flash test:** Firmware flashes successfully to SP530E
- [ ] **Boot test:** Device boots and WiFi connects
- [ ] **LED test:** Status LEDs function correctly
- [ ] **PWM test:** 5-channel output works
- [ ] **Audio test:** AudioReactive responds to input

## Troubleshooting Common Issues

### Build Failures
- [ ] **ArduinoFFT errors:** Check syntax for v1.x vs v2.x compatibility
- [ ] **Missing includes:** Verify usermod header files exist
- [ ] **Undefined references:** Check usermod registration in `usermods_list.cpp`
- [ ] **Partition errors:** Verify custom partition table exists

### Flash/Size Issues
- [ ] **Firmware too large:** Consider disabling non-essential features
- [ ] **Partition mismatch:** Ensure using correct partition table
- [ ] **Library conflicts:** Check for duplicate or incompatible dependencies

### ESP32-C3 Specific
- [ ] **Platform version:** Ensure ESP32 platform supports features used
- [ ] **AudioReactive warnings:** Expected limitations, check functionality
- [ ] **GPIO conflicts:** Verify pin assignments don't conflict

## Full Flash Image Creation

If you need a complete flash image for production:

```bash
# Create merged flash image with all components
esptool.py --chip esp32c3 merge_bin -o SP530E_complete.bin \
  --flash_mode dio --flash_freq 80m --flash_size 4MB \
  0x0 .pio/build/sp530e/bootloader.bin \
  0x8000 .pio/build/sp530e/partitions.bin \
  0x10000 .pio/build/sp530e/firmware.bin
```

## File Backup & Management Scripts

### Backup Script
Create this script to quickly backup SP530E customizations:

```bash
#!/bin/bash
# backup_sp530e.sh - Run this before any upgrades!
WLED_DIR=${1:-"."}  # Allow specifying WLED directory
BACKUP_DIR="sp530e_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Backing up SP530E customizations from: $WLED_DIR"

# Copy custom files
cp "$WLED_DIR/platformio.ini" "$BACKUP_DIR/" 2>/dev/null || echo "Warning: platformio.ini not found"
cp "$WLED_DIR/wled00/usermods_list.cpp" "$BACKUP_DIR/" 2>/dev/null || echo "Warning: usermods_list.cpp not found"
cp "$WLED_DIR/wled00/const.h" "$BACKUP_DIR/" 2>/dev/null || echo "Warning: const.h not found"
cp -r "$WLED_DIR/usermods/wifi_status_led" "$BACKUP_DIR/" 2>/dev/null || echo "Warning: wifi_status_led usermod not found"
cp -r "$WLED_DIR/usermods/boot_status_led" "$BACKUP_DIR/" 2>/dev/null || echo "Warning: boot_status_led usermod not found"
cp "$WLED_DIR/tools/WLED_ESP32C3_4MB_audioreactive.csv" "$BACKUP_DIR/" 2>/dev/null || echo "Warning: partition table not found"

# Copy built firmware
cp "$WLED_DIR/build_output/release/"WLED_*_SP530E-JW.bin "$BACKUP_DIR/" 2>/dev/null || echo "Warning: built firmware not found"

# Document current version
cd "$WLED_DIR" && git log --oneline -5 > "../$BACKUP_DIR/git_version.txt" 2>/dev/null || echo "Not a git repository" > "../$BACKUP_DIR/git_version.txt"

echo "SP530E backup created in: $BACKUP_DIR"
echo "Contents:"
ls -la "$BACKUP_DIR"
```

### Restoration Script
Create this script to restore SP530E customizations:

```bash
#!/bin/bash
# restore_sp530e.sh - Apply SP530E customizations to new WLED version
BACKUP_DIR=$1
TARGET_DIR=${2:-"."}

if [ -z "$BACKUP_DIR" ]; then
    echo "Usage: restore_sp530e.sh <backup_directory> [target_wled_directory]"
    echo "Example: restore_sp530e.sh sp530e_backup_20250922_123456 WLED_new"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory '$BACKUP_DIR' not found"
    exit 1
fi

echo "Restoring SP530E customizations to: $TARGET_DIR"
echo "From backup: $BACKUP_DIR"

# Create usermod directories
mkdir -p "$TARGET_DIR/usermods/wifi_status_led"
mkdir -p "$TARGET_DIR/usermods/boot_status_led"

# Copy usermod files
cp -r "$BACKUP_DIR/wifi_status_led/"* "$TARGET_DIR/usermods/wifi_status_led/" 2>/dev/null || echo "Warning: Could not restore wifi_status_led"
cp -r "$BACKUP_DIR/boot_status_led/"* "$TARGET_DIR/usermods/boot_status_led/" 2>/dev/null || echo "Warning: Could not restore boot_status_led"

# Copy partition table
cp "$BACKUP_DIR/WLED_ESP32C3_4MB_audioreactive.csv" "$TARGET_DIR/tools/" 2>/dev/null || echo "Warning: Could not restore partition table"

echo "Files restored! Now manually update:"
echo "1. platformio.ini - add SP530E environment"
echo "2. wled00/usermods_list.cpp - add usermod includes/registrations"
echo "3. wled00/const.h - add usermod ID constants"
echo ""
echo "Reference files available in: $BACKUP_DIR"
```

## Notes
- Always test on a development board first before flashing production devices
- Keep the previous working firmware as a fallback option  
- Document any new customizations added during upgrade process
- Consider version pinning for critical production deployments