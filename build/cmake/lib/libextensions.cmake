include(gen.cmake)

set(TARGET_SRC_DIR "${SRC_DIR}/iptables/extensions")

set(libext_default_cflags
	${iptables_default_cflags}
	"-DNO_SHARED_LIBS=1"
	"-DXTABLES_INTERNAL"
	"-Wno-format"
	"-Wno-missing-field-initializers"
	# libxt_recent.c:202:11: error: address of array 'info->name' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
	"-Wno-pointer-bool-conversion"
	"-Wno-tautological-pointer-compare"
)

###########################################ext_static############################################
set(TARGET ext_static)

file(GLOB libext_static_srcs "${TARGET_SRC_DIR}/libxt_*.c")

set(libext_static_excluse_srcs
        # Exclude some modules that are problematic to compile (types/headers)
        "${TARGET_SRC_DIR}/libxt_TCPOPTSTRIP.c"
        "${TARGET_SRC_DIR}/libxt_connlabel.c"
        "${TARGET_SRC_DIR}/libxt_cgroup.c"
        "${TARGET_SRC_DIR}/libxt_dccp.c"
        "${TARGET_SRC_DIR}/libxt_ipvs.c"
)
listRemoveAll(libext_static_srcs libext_static_excluse_srcs)
gensrcs("c" libext_static_srcs)
genrule("" libext_static_srcs "${TARGET_SRC_DIR}/initext.c")

add_library(${TARGET} STATIC ${libext_static_srcs})

target_include_directories(${TARGET} PRIVATE
	${iptables_headers}
	${iptables_config_header}
)

target_compile_options(${TARGET} PRIVATE
	"$<$<COMPILE_LANGUAGE:C>:${libext_default_cflags}>"
	"$<$<COMPILE_LANGUAGE:CXX>:${libext_default_cflags}>"
)
##################################################################################################

###########################################ext4_static############################################
set(TARGET ext4_static)

file(GLOB libext4_static_srcs "${TARGET_SRC_DIR}/libipt_*.c")

gensrcs("c" libext4_static_srcs)
genrule("4" libext4_static_srcs "${TARGET_SRC_DIR}/initext4.c")

add_library(${TARGET} STATIC ${libext4_static_srcs})

target_include_directories(${TARGET} PRIVATE
	${iptables_headers}
	${iptables_config_header}
)

target_compile_options(${TARGET} PRIVATE
	"$<$<COMPILE_LANGUAGE:C>:${libext_default_cflags}>"
	"$<$<COMPILE_LANGUAGE:CXX>:${libext_default_cflags}>"
)
##################################################################################################

###########################################ext6_static############################################

set(TARGET ext6_static)

file(GLOB libext6_static_srcs "${TARGET_SRC_DIR}/libip6t_*.c")

gensrcs("c" libext6_static_srcs)
genrule("6" libext6_static_srcs "${TARGET_SRC_DIR}/initext6.c")

add_library(${TARGET} STATIC ${libext6_static_srcs})

target_include_directories(${TARGET} PRIVATE
	${iptables_headers}
	${iptables_config_header}
)

target_compile_options(${TARGET} PRIVATE
	"$<$<COMPILE_LANGUAGE:C>:${libext_default_cflags}>"
	"$<$<COMPILE_LANGUAGE:CXX>:${libext_default_cflags}>"
)
##################################################################################################
