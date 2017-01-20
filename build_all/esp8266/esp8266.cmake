# use "Generic" for an embedded system
set(CMAKE_SYSTEM_NAME Generic)

# skip the compiler checks since they fail with the esp-open-sdk
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

set(ESP8266_RTOS_SDK $ENV{ESP8266_RTOS_SDK})

# this is the location of the toolchain targeting the ESP8266
set(CMAKE_C_COMPILER xtensa-lx106-elf-gcc)
# setting the cxx compiler to some binary that exists so that cmake does not complain
set(CMAKE_CXX_COMPILER xtensa-lx106-elf-gcc)

# this is the file system root of the target
set(CMAKE_FIND_ROOT_PATH ${ESP8266_RTOS_SDK})

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DREFCOUNT_ATOMIC_DONTCARE" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DFREERTOS_ARCH_ESP8266 -DESP8266_RTOS" CACHE STRING "" FORCE)
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DICACHE_FLASH -D__STDC_NO_ATOMICS__=1 -DESP8266_RTOS -D__STDC_VERSION__=201112L -DFREERTOS_ARCH_ESP8266" CACHE STRING "" FORCE)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${ESP8266_RTOS_SDK}/include/lwip" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${ESP8266_RTOS_SDK}/include/lwip/ipv4" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${ESP8266_RTOS_SDK}/include/lwip/ipv6" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${ESP8266_RTOS_SDK}/include/espressif" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${ESP8266_RTOS_SDK}/extra_include" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${ESP8266_RTOS_SDK}/include" CACHE STRING "" FORCE)

# below from https://github.com/rpoisel/esp8266-cmake/blob/5f8686380e1e9f12e81e5d43d1be338080785e4b/cmake/toolchain.ESP8266.cmake#L44
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w -Os -g -std=gnu99 -Wpointer-arith -Wno-implicit-function-declaration -Wundef -pipe -D__ets__ -DICACHE_FLASH -fno-inline-functions -ffunction-sections -nostdlib -mlongcalls -mtext-section-literals -falign-functions=4 -fdata-sections" CACHE STRING "" FORCE)
