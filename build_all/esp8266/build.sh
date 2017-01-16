#!/bin/bash

set -o pipefail
set -e

script_dir=$(cd "$(dirname "$0")" && pwd)
build_root=$(cd "${script_dir}/../.." && pwd)
log_dir=$build_root
run_e2e_tests=OFF
run_longhaul_tests=OFF
build_amqp=OFF
build_http=OFF
build_mqtt=ON
use_openssl=OFF
use_socketio=OFF
use_condition=OFF
use_default_uuid=ON
skip_samples=ON
use_lock_adapter=OFF
no_blob=ON
use_wsio=OFF
run_unittests=OFF
build_python=OFF
build_javawrapper=OFF
run_valgrind=0
build_folder=$build_root"/cmake/iotsdk_esp8266"
toolchainfile=$script_dir"/esp8266.cmake"
toolchainfileflag="-DCMAKE_TOOLCHAIN_FILE=$toolchainfile"
cmake_install_prefix=" "
no_logging=OFF

rm -r -f $build_folder
mkdir -p $build_folder

pushd $build_folder

cmake $toolchainfileflag $cmake_install_prefix -Drun_valgrind:BOOL=$run_valgrind -DcompileOption_C:STRING="$extracloptions" -Drun_e2e_tests:BOOL=$run_e2e_tests -Drun_longhaul_tests=$run_longhaul_tests -Duse_amqp:BOOL=$build_amqp -Duse_http:BOOL=$build_http -Duse_mqtt:BOOL=$build_mqtt -Ddont_use_uploadtoblob:BOOL=$no_blob -Duse_wsio:BOOL=$use_wsio -Drun_unittests:BOOL=$run_unittests -Dbuild_python:STRING=$build_python -Dbuild_javawrapper:BOOL=$build_javawrapper -Dno_logging:BOOL=$no_logging -Duse_openssl=$use_openssl -Dskip_samples=$skip_samples -Duse_socketio=$use_socketio -Duse_condition=$use_condition -Duse_default_uuid=$use_default_uuid -Duse_lock_adapter=$use_lock_adapter $build_root

make

popd
