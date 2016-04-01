#!/bin/bash
STL_VERSION=libc++

print_step() {
  STEP_MESSAGE=${1}
  echo " "
  echo "-----------------------------------------------------------------------------"
  echo "${STEP_MESSAGE}"
  echo "-----------------------------------------------------------------------------"
  echo " "
}

error_exit() {
  ERROR_MESSAGE=${1}
  echo " "
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "!! ${ERROR_MESSAGE} !!"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo " "
  exit 1
}

error_check () {
  if [ $? -ne 0 ];then
    error_exit "Error"
  fi
}

if test -z "${ANDROID_NDK_DIR}"; then
  error_exit "ANDROID_NDK_DIR must be defined"
fi

if test -z "${ANDROID_NDK_TOOLCHAIN}"; then
  error_exit "ANDROID_NDK_TOOLCHAIN must be defined"
fi

if test -z "${PLATFORM}"; then
  error_exit "PLATFORM must be defined"
fi

if test -z "${ARCHS}"; then
  error_exit "ARCHS must be defined"
fi

echo " "
echo "============================================================================="
echo "Making standalone toolchain..."
echo " "
echo ANDROID_NDK_DIR = ${ANDROID_NDK_DIR}
echo ANDROID_NDK_TOOLCHAIN = ${ANDROID_NDK_TOOLCHAIN}
echo PLATFORM = ${PLATFORM}
echo STL_VERSION = ${STL_VERSION}
echo "============================================================================="
echo " "

print_step "Cleanup..."
rm -rf ${ANDROID_NDK_TOOLCHAIN}

for arch in $ARCHS
do
  print_step "Creating $arch toolchain..."
  ${ANDROID_NDK_DIR}/build/tools/make-standalone-toolchain.sh --platform=${PLATFORM} --arch=$arch --use-llvm --stl=${STL_VERSION} --install-dir="${ANDROID_NDK_TOOLCHAIN}/${arch}"
  error_check
done

print_step "DONE"
