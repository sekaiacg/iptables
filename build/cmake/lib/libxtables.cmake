set(TARGET xtables_static)

set(TARGET_SRC_DIR "${SRC_DIR}/iptables/libxtables")

set(TARGET_CFLAGS
	${iptables_default_cflags}
	"-DNO_SHARED_LIBS=1"
	"-DXTABLES_INTERNAL"
	"-DXTABLES_LIBDIR=\"xtables_libdir_not_used\""
	"-Wno-missing-field-initializers"
)

set(libxtables_static_srcs
	"${TARGET_SRC_DIR}/xtables.c"
	"${TARGET_SRC_DIR}/xtoptions.c"
)

add_library(${TARGET} STATIC ${libxtables_static_srcs})

target_include_directories(${TARGET} PRIVATE
	${iptables_headers}
	${iptables_iptables_headers}
	${iptables_config_header}
)

target_compile_options(${TARGET} PRIVATE
	"$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
	"$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
