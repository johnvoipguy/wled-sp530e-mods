# 🎯 WLED for SP530E Controllers (ESP32-C3 Modified Hardware)

[![Build SP530E Binaries](https://github.com/johnvoipguy/wled-sp530e-mods/actions/workflows/build-sp530e.yml/badge.svg)](https://github.com/johnvoipguy/wled-sp530e-mods/actions/workflows/build-sp530e.yml)

## 🚨 **WLED for SP530E Controllers** 🚨

**This repository contains WLED modifications specifically optimized for SP530E LED controllers with ESP32-C3 chips.** 

⚠️ **CAUTION: Requires modification by soldering connections to use UART for flashing this firmware** ⚠️

---

## 📥 **Quick Download**

**Need firmware for your modified SP530E?** 

👉 **[Download Latest Release](https://github.com/johnvoipguy/wled-sp530e-mods/releases)** 👈

Choose:
- **AudioReactive**: Full featured with sound-reactive lighting
- **Standard**: Basic LED control without audio features

## ⚠️ Important Notice

**This firmware is ONLY for SP530E controllers that have been physically modified to use ESP32-C3 chips.** Do not flash this to unmodified SP530E controllers - it will not work and may cause damage.

## 🔧 Hardware Requirements

- **Stock SP530E LED Controller** (ESP32-C3 based)
- **UART access via soldering** for initial firmware flashing
- **Required modifications**:
  - Solder connections to UART pins (TX, RX, GND, 3.3V)
  - Access to GPIO0 for boot mode (optional for easier flashing)
  - No chip replacement needed - uses stock ESP32-C3

## 📋 Features

### Custom User Modules
- **Boot Status LED**: Visual indication of boot process and system status
- **WiFi Status LED**: Real-time WiFi connection status indicator
- **Audio Reactive**: Enhanced audio processing for ESP32-C3

### ESP32-C3 Optimizations
- **4MB Flash Support**: Optimized memory layout for ESP32-C3
- **GPIO Mapping**: Correct pin assignments for modified SP530E hardware
- **Performance Tuning**: ESP32-C3 specific optimizations

## 🚀 Quick Start

### Option 1: Download Pre-built Binaries

1. Go to the [Releases](https://github.com/johnvoipguy/wled-sp530e-mods/releases) page
2. Download the latest `WLED_SP530E_esp32c3dev_4MB_audioreactive_*.bin`
3. Flash using your preferred method (see [Flashing Instructions](#-flashing-instructions))

### Option 2: Download from Actions (Latest Builds)

1. Go to [Actions](https://github.com/johnvoipguy/wled-sp530e-mods/actions)
2. Click on the latest successful build
3. Download the appropriate artifact for your configuration

## 💾 Flashing Instructions

### Prerequisites
- **ESPTool** or **ESP Flash Download Tool**
- **USB connection** to your modified SP530E controller

### Using ESPTool (Command Line)
```bash
# Install esptool if not already installed
pip install esptool

# Put SP530E in download mode (connect GPIO0 to GND during power-on)
# Flash the firmware via UART (replace COM_PORT with your UART adapter port)
esptool.py --chip esp32c3 --port COM_PORT write_flash 0x0000 WLED_SP530E_*.bin
```

### UART Wiring for SP530E
You need to solder wires to these points on the SP530E board:
- **TX** → UART RX
- **RX** → UART TX  
- **GND** → UART GND
- **3.3V** → UART VCC (or use external 3.3V supply)
- **GPIO0** → GND (for download mode, release after flashing starts)

### Using ESP Flash Download Tool (GUI)
1. Download [ESP Flash Download Tool](https://www.espressif.com/en/support/download/other-tools)
2. Select ESP32-C3
3. Load the `.bin` file at address `0x0000`
4. Connect and flash

### Using Web Installer
*Coming soon - web-based installer for easier flashing*

## 🛠️ Configuration

### First Boot
1. After flashing, the SP530E will create a WiFi access point named `WLED-AP`
2. Connect to this network (password: `wled1234`)
3. Navigate to `http://4.3.2.1` in your browser
4. Complete the WiFi setup

### LED Configuration
- **Default GPIO**: Configured for modified SP530E pinout
- **LED Count**: Set according to your strip length
- **Color Order**: Typically GRB for most WS2812B strips

### Audio Reactive Setup (if using audioreactive build)
1. Go to Settings → Sound Reactive
2. Configure microphone input (GPIO settings pre-configured)
3. Adjust sensitivity and gain as needed

## 📁 Available Builds

### `esp32c3dev_4MB_audioreactive`
- **Full featured** build with audio reactive capabilities
- **Recommended** for most users
- Includes all custom user modules

### `esp32c3dev_4MB`
- **Standard** build without audio reactive features
- **Smaller size** for basic LED control
- Good for simple installations

## 🔧 Development

### Building from Source
```bash
# Clone the repository
git clone https://github.com/johnvoipguy/wled-sp530e-mods.git
cd wled-sp530e-mods

# Install dependencies
npm install
pip install -r requirements.txt

# Build firmware
platformio run -e esp32c3dev_4MB_audioreactive
```

### Custom Modifications
If you need to modify the configuration:
1. Edit `platformio.ini` for build settings
2. Modify user modules in `usermods/` directory
3. Update pin assignments in `wled00/const.h`

## 📚 Documentation

- [WLED Official Documentation](https://kno.wled.ge/)
- [ESP32-C3 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-c3_datasheet_en.pdf)
- [SP530E Hardware Modification Guide](SP530E_UPGRADE_CHECKLIST.md)

## 🤝 Support

### Hardware Issues
- Ensure all hardware modifications are completed correctly
- Verify ESP32-C3 chip installation and connections
- Check power supply specifications

### Software Issues  
- Check [Issues](https://github.com/johnvoipguy/wled-sp530e-mods/issues) for known problems
- Create a new issue with detailed description and logs
- Include hardware modification details

### Community
- Join the [WLED Discord](https://discord.gg/KuqP7NE) for community support
- Visit [WLED Community](https://github.com/Aircoookie/WLED/discussions)

## 📄 License

This project maintains the same license as WLED. See the original [WLED LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- **Aircoookie** and the WLED team for the amazing base firmware
- **ESP32-C3 community** for development resources and support  
- **SP530E modders** who made the hardware modifications possible

## ⚡ Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and updates.

---

**⚠️ Reminder: This firmware is specifically for hardware-modified SP530E controllers with ESP32-C3 chips. Ensure your hardware modifications are complete before flashing!**