set(TARGET_SRC_DIR "${SRC_DIR}/iptables/libiptc")

set(TARGET_CFLAGS
	${iptables_default_cflags}
	"-Wno-pointer-sign"
)

###########################################ip4tc_static############################################
set(TARGET ip4tc_static)
set(libip4tc_static_srcs "${TARGET_SRC_DIR}/libip4tc.c")
add_library(${TARGET} STATIC ${libip4tc_static_srcs})
target_include_directories(${TARGET} PRIVATE ${iptables_headers})
target_compile_options(${TARGET} PRIVATE
	"$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
	"$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
##################################################################################################

###########################################ip6tc_static############################################
set(TARGET ip6tc_static)
set(libip6tc_static_srcs "${TARGET_SRC_DIR}/libip6tc.c")
add_library(${TARGET} STATIC ${libip6tc_static_srcs})
target_include_directories(${TARGET} PRIVATE ${iptables_headers})
target_compile_options(${TARGET} PRIVATE
	"$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
	"$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
##################################################################################################
