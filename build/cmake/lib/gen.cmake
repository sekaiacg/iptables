function(listRemoveAll source_list remove_list)
	set (new_source_list ${${source_list}})
	foreach (item ${${remove_list}})
		list(REMOVE_ITEM new_source_list ${item})
		#message("exc:=${item}")
	endforeach(item)
	#[[foreach (item ${new_source_list})
		message("list:=${item}")
	endforeach(item)]]
	set(${source_list} ${new_source_list} PARENT_SCOPE)
endfunction(listRemoveAll)

set(gen_init "${CMAKE_CURRENT_SOURCE_DIR}/gen_init")
set(filter_init "${CMAKE_CURRENT_SOURCE_DIR}/filter_init")

function(genrule flag target_srcs out_src)
	set(_target_srcs)
	foreach (item ${${target_srcs}})
		STRING(REGEX REPLACE ".+/(.+)" "\\1" FILE_NAME ${item})
		#message("skkk=${FILE_NAME}")
		list(APPEND _target_srcs ${FILE_NAME})
	endforeach(item)
	string (REPLACE ";" " " files "${_target_srcs}")
	execute_process(COMMAND sh -c "${gen_init} '${flag}' ${files} > ${out_src}")
	set(${target_srcs}
		${${target_srcs}}
		${out_src}
		PARENT_SCOPE
	)
endfunction(genrule)

function(gensrcs output_extension target_srcs)
	foreach (item ${${target_srcs}})
		string(REGEX REPLACE "\\.[^.]*$" "" FILE_NAME ${item})
		#message("skkk=${FILE_NAME}")
		execute_process(COMMAND
			sh -c
			"${filter_init} ${item}"
			OUTPUT_VARIABLE OUTBUF
		)
		file(WRITE "${FILE_NAME}.${output_extension}" "${OUTBUF}")
	endforeach(item)
endfunction(gensrcs)
