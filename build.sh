BASE_DIR="$(pwd)"
BUILD_CMAKE_DIR="${BASE_DIR}/build/cmake"
OUT="${BASE_DIR}/out"
BIN_DIR="${OUT}/iptables"
rm *[.zip] > /dev/null 2>&1

cmake_build()
{
	local TARGET_PLAT=$1
	local COMPILE_ABI=$2
	local COMPILE_METHOD=$3
	local ANDROID_PLATFORM_VER=$4

	local BUILD_METHOD=""
	local MAKE_CMD=""
	if [ "$COMPILE_METHOD" == "Ninja" ]; then
		BUILD_METHOD="-G Ninja"
		echo ${CMAKE_CMD}
		MAKE_CMD="time -p ninja -C $OUT"
	elif [ "$COMPILE_METHOD" == "make" ]; then
		MAKE_CMD="time -p make -C $OUT -j$(nproc)"
	fi;

	if [ "$TARGET_PLAT" == "Android" ]; then
		cmake -S ${BUILD_CMAKE_DIR} -B $OUT ${BUILD_METHOD} \
			-DNDK_CCACHE="ccache" \
			-DCMAKE_BUILD_TYPE="Release" \
			-DANDROID_PLATFORM="${ANDROID_PLATFORM_VER}" \
			-DANDROID_ABI="${COMPILE_ABI}" \
			-DANDROID_STL="c++_static" \
			-DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake" \
			-DANDROID_USE_LEGACY_TOOLCHAIN_FILE="OFF"
	elif [ "$TARGET_PLAT" == "Linux" ]; then
		##指定第三方clang 路径：CLANG_PATH=""
		CLANG_PATH=""
		cmake -S ${BUILD_CMAKE_DIR} -B ${OUT} ${BUILD_METHOD} \
			-DCMAKE_C_COMPILER_LAUNCHER="ccache" \
			-DCMAKE_CXX_COMPILER_LAUNCHER="ccache" \
			-DCMAKE_C_COMPILER="${CLANG_PATH}clang" \
			-DCMAKE_CXX_COMPILER="${CLANG_PATH}clang++"
	fi

	${MAKE_CMD}
}

build()
{
	clear
	local TARGET_PLAT=$1
	local COMPILE_ABI=$2
	local ANDROID_PLATFORM=$3

	rm -r $OUT > /dev/null 2>&1

	local NINJA=`which ninja`
	local COMPILE_METHOD
	if [[ -f $NINJA ]]; then
		COMPILE_METHOD="Ninja"
	else
		COMPILE_METHOD="make"
	fi
	echo "skkk: TARGET_PLAT=${TARGET_PLAT}"
	echo "skkk: COMPILE_ABI=${COMPILE_ABI}"
	echo "skkk: ANDROID_PLATFORM=${ANDROID_PLATFORM}"
	time cmake_build "${TARGET_PLAT}" "${COMPILE_ABI}" "${COMPILE_METHOD}" "${ANDROID_PLATFORM}"

	local IPTABLES_BIN="$BIN_DIR/iptables"
	
	local RET=0
	[ -f "$IPTABLES_BIN" ] && RET=1

	if [ $RET -eq 1 ]; then
		echo "打包中..."
		touch -c -d "2009-01-01 08:00:00" ${BIN_DIR}/*
		rm $BIN_DIR/*.a  > /dev/null 2>&1
		rm $BIN_DIR/*.cmake > /dev/null 2>&1
		zip -9 -jy "iptables-${TARGET_PLAT}_${COMPILE_ABI}-$(TZ=UTC-8 date +%y%m%d%H%M).zip" $BIN_DIR/* > /dev/null 2>&1
		echo "打包完成！"
	else
		echo "error"
		exit -1
	fi
}

build "Android" "arm64-v8a" "android-29"
#build "Android" "armeabi-v7a" "android-29"
build "Android" "x86_64" "android-29"
#build "Android" "x86" "android-29"
build "Linux" "x86_64"
