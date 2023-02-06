set(TARGET_iptables iptables)

set(TARGET_SRC_DIR "${SRC_DIR}/iptables/iptables")

set(TARGET_CFLAGS
	${iptables_default_cflags}
	"-Wno-missing-field-initializers"
	"-Wno-parentheses-equality"
	"-DNO_SHARED_LIBS=1"
	"-DALL_INCLUSIVE"
	"-DXTABLES_INTERNAL"
)

set(iptables_default_srcs
	"${TARGET_SRC_DIR}/xtables-legacy-multi.c"
	"${TARGET_SRC_DIR}/iptables-xml.c"
	"${TARGET_SRC_DIR}/xshared.c"
)

set(iptables_srcs
	${iptables_default_srcs}
	"${TARGET_SRC_DIR}/iptables-save.c"
	"${TARGET_SRC_DIR}/iptables-restore.c"
	"${TARGET_SRC_DIR}/iptables-standalone.c"
	"${TARGET_SRC_DIR}/iptables.c"
	"${TARGET_SRC_DIR}/ip6tables-standalone.c"
	"${TARGET_SRC_DIR}/ip6tables.c"
)

set(static_link_lib
	-Wl,--start-group
	ext_static
	ext4_static
	ext6_static
	xtables_static
	ip4tc_static
	ip6tc_static
	-lm
	-Wl,--end-group
)

add_executable(${TARGET_iptables} ${iptables_srcs})
target_include_directories(${TARGET_iptables} PRIVATE
	${iptables_headers}
	${iptables_config_header}
)
target_link_libraries(${TARGET_iptables} ${static_link_lib})
if (CMAKE_SYSTEM_NAME MATCHES "Linux")
	target_link_options(${TARGET_iptables} PRIVATE "-Wl,--no-fatal-warnings")
endif()
target_compile_options(${TARGET_iptables} PRIVATE ${TARGET_CFLAGS})

