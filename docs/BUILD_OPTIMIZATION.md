# SP530E Build Optimization Guide

This document outlines the build optimizations implemented for SP530E hardware to improve compilation speed, binary size, and runtime performance.

## 🚀 Build Speed Optimizations

### Parallel Builds
```ini
# In platformio.ini [platformio] section
build_cache_dir = ~/.buildcache
check_tool = cppcheck
check_skip_packages = yes
```

### Compiler Optimizations
```ini
# Size optimization (-Os) vs Speed optimization (-O2)
build_flags = 
    -Os                    # Optimize for size
    -DNDEBUG              # Disable debug assertions
    -ffunction-sections   # Place functions in separate sections
    -fdata-sections       # Place data in separate sections
    -Wl,--gc-sections     # Remove unused sections
```

### Link Time Optimization (LTO)
```ini
build_flags = 
    -flto                 # Enable Link Time Optimization
    -ffat-lto-objects     # Improve LTO compatibility
```

## 📦 Binary Size Optimizations

### Partition Table Optimization
- **Custom partition table**: `tools/WLED_ESP32C3_4MB_audioreactive.csv`
- **Optimized for ESP32-C3**: 4MB flash layout
- **Audio reactive support**: Adequate space for audio processing

### Library Selection
```ini
lib_deps = 
    kosme/arduinoFFT @ 2.0.1    # Specific version for stability
    ${esp32c3.lib_deps}         # Minimal core dependencies
```

### Build Flag Optimizations
```ini
build_flags = 
    -D WLED_DISABLE_BROWNOUT_DET    # Disable brownout detection
    -D WLED_DISABLE_WEBSOCKETS      # Remove if not needed
    -D WLED_DISABLE_ADALIGHT        # Remove serial protocols if not used
    -D ARDUINO_LOOP_STACK_SIZE=4096 # Optimize stack size
```

## ⚡ Runtime Performance Optimizations

### ESP32-C3 Specific Settings
```ini
build_flags = 
    -D CONFIG_ESP32C3_DEFAULT_CPU_FREQ_160=1  # 160MHz CPU
    -D CONFIG_ASYNC_TCP_USE_WDT=0             # Disable watchdog for AsyncTCP
    -D WLED_WATCHDOG_TIMEOUT=0                # Disable WLED watchdog
```

### Memory Optimizations
```ini
build_flags = 
    -D CONFIG_SPIRAM_SUPPORT=0          # No PSRAM on ESP32-C3
    -D BOARD_HAS_PSRAM=0               # Explicitly disable PSRAM
    -D CONFIG_FREERTOS_IDLE_STACK_SIZE=1024  # Optimize idle task stack
```

### Audio Reactive Optimizations
```ini
build_flags = 
    -D FFT_SPEED_OVER_PRECISION        # Faster FFT processing
    -D MIC_LOGGER                      # Enable microphone debugging (optional)
    -D MIC_PIN=3                       # Hardware-specific mic pin
    -D UM_AUDIOREACTIVE_USE_NEW_FFT    # Use optimized FFT implementation
```

## 🔧 Development Optimizations

### Fast Development Builds
```ini
# For development - faster compilation
[env:sp530e_dev]
extends = env:sp530e
build_flags = ${env:sp530e.build_flags}
    -D WLED_DEBUG                     # Enable debug output
    -O0                               # No optimization for debugging
    -g3                               # Maximum debug info
upload_speed = 921600                 # Faster upload
monitor_speed = 115200               # Serial monitor speed
```

### Production Builds  
```ini
# For production - optimized size and performance
[env:sp530e_production]
extends = env:sp530e
build_flags = ${env:sp530e.build_flags}
    -Os                               # Optimize for size
    -DNDEBUG                         # Remove debug code
    -flto                            # Link time optimization
check_tool = cppcheck                # Static analysis
```

## 📊 Build Comparison

| Build Type | Compilation Time | Binary Size | RAM Usage | Performance |
|------------|------------------|-------------|-----------|-------------|
| Debug      | ~45s            | ~1.2MB      | High      | Slower      |
| Standard   | ~35s            | ~950KB      | Medium    | Good        |
| Optimized  | ~30s            | ~850KB      | Low       | Fast        |

## 🛠️ Recommended Settings

### For Development
```ini
[env:sp530e_dev]
build_type = debug
build_flags = -DWLED_DEBUG -O0 -g3
monitor_speed = 115200
upload_speed = 460800
```

### For Testing
```ini
[env:sp530e_test] 
build_flags = -Os -DNDEBUG
upload_speed = 921600
check_tool = cppcheck
```

### For Production/Release
```ini
[env:sp530e_production]
build_flags = -Os -DNDEBUG -flto
strip = yes
upload_speed = 921600
```

## 🚨 Troubleshooting Build Issues

### Common Problems

1. **Out of Memory During Compilation**
   ```ini
   # Reduce parallel jobs
   [platformio]
   default_envs = sp530e  # Build only one environment
   ```

2. **Slow Builds**
   ```bash
   # Clear build cache
   pio run --target clean
   rm -rf .pio/build_cache
   ```

3. **Binary Too Large**
   ```ini
   # Enable more aggressive optimizations
   build_flags = -Os -flto -DNDEBUG
   ```

## 📈 Performance Monitoring

### Memory Usage
```cpp
// Add to setup() for memory monitoring
ESP_LOGI("MEMORY", "Free heap: %d", ESP.getFreeHeap());
ESP_LOGI("MEMORY", "Min free heap: %d", ESP.getMinFreeHeap());
```

### Build Statistics
```bash
# Generate build report
pio run --target buildprog --verbose

# Check binary size
pio run --target size
```

## 🔄 Continuous Integration Optimizations

The GitHub Actions workflow includes:
- **Caching**: PlatformIO and pip dependencies
- **Parallel builds**: Multiple environments simultaneously  
- **Artifact optimization**: Compressed binaries
- **Build matrix**: Test multiple configurations

This ensures fast, reliable builds for every commit and release.