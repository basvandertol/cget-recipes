cmake_minimum_required(VERSION 2.8)

project(nas C)

file(STRINGS RELEASE RELEASE_CONTENT LIMIT_COUNT 1)
file(WRITE ${CMAKE_BINARY_DIR}/release.h "
static const char *release = \"${RELEASE_CONTENT}\";
")

include ( CheckFunctionExists )
include ( CheckIncludeFiles )

set(CONFIG_VARS)
macro(set_config VAR)
    set(${VAR} ${ARGN})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()
macro(nas_check_include_files INCLUDE VAR)
    check_include_files(${INCLUDE} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(nas_check_function_exists FUNC VAR)
    check_function_exists(${FUNC} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

nas_check_function_exists(daemon HAVE_DAEMON)
nas_check_function_exists(fileno HAVE_FILENO)
nas_check_function_exists(getmsg HAVE_GETMSG)
nas_check_function_exists(poll HAVE_POLL)
nas_check_function_exists(select HAVE_SELECT)
nas_check_function_exists(setitimer HAVE_SETITIMER)
nas_check_function_exists(setpgrp HAVE_SETPGRP)
nas_check_function_exists(snprintf HAVE_SNPRINTF)
nas_check_function_exists(strerror HAVE_STRERROR)
nas_check_function_exists(strstr HAVE_STRSTR)
nas_check_function_exists(vprintf HAVE_VPRINTF)
nas_check_function_exists(vsnprintf HAVE_VSNPRINTF)

nas_check_include_files(dlfcn.h HAVE_DLFCN_H)
nas_check_include_files(fcntl.h HAVE_FCNTL_H)
nas_check_include_files(inttypes.h HAVE_INTTYPES_H)
nas_check_include_files(limits.h HAVE_LIMITS_H)
nas_check_include_files(machine/soundcard.h HAVE_MACHINE_SOUNDCARD_H)
nas_check_include_files(malloc.h HAVE_MALLOC_H)
nas_check_include_files(memory.h HAVE_MEMORY_H)
nas_check_include_files(poll.h HAVE_POLL_H)
nas_check_include_files(stdint.h HAVE_STDINT_H)
nas_check_include_files(stdlib.h HAVE_STDLIB_H)
nas_check_include_files(strings.h HAVE_STRINGS_H)
nas_check_include_files(string.h HAVE_STRING_H)
nas_check_include_files(stropts.h HAVE_STROPTS_H)
nas_check_include_files(sys/ioctl.h HAVE_SYS_IOCTL_H)
nas_check_include_files(sys/select.h HAVE_SYS_SELECT_H)
nas_check_include_files(sys/soundcard.h HAVE_SYS_SOUNDCARD_H)
nas_check_include_files(sys/stat.h HAVE_SYS_STAT_H)
nas_check_include_files(sys/times.h HAVE_SYS_TIMES_H)
nas_check_include_files(sys/time.h HAVE_SYS_TIME_H)
nas_check_include_files(sys/types.h HAVE_SYS_TYPES_H)
nas_check_include_files(termios.h HAVE_TERMIOS_H)
nas_check_include_files(termio.h HAVE_TERMIO_H)
nas_check_include_files(time.h HAVE_TIME_H)
nas_check_include_files(unistd.h HAVE_UNISTD_H)
nas_check_include_files(values.h HAVE_VALUES_H)
nas_check_include_files(zlib.h HAVE_ZLIB_H)

function(patch_file FILE MATCH REPLACEMENT)
    message(STATUS "Patch: ${FILE}")
    file(READ ${FILE} CONTENT)
    string(REPLACE 
        "${MATCH}"
        "${REPLACEMENT}" 
        OUTPUT_CONTENT "${CONTENT}")
    file(WRITE ${FILE} "${OUTPUT_CONTENT}")
endfunction()

patch_file(config/config.h.in "#undef" "#cmakedefine")
foreach(VAR ${CONFIG_VARS})
    if(${VAR})
        patch_file(config/config.h.in "#cmakedefine ${VAR}" "#define ${VAR} 1")
    endif()
endforeach()
configure_file(config/config.h.in ${CMAKE_BINARY_DIR}/config.h)

set(HEADERS 
lib/audio/Alibint.h
lib/audio/Alibnet.h
lib/audio/Xtutil.h
lib/audio/audiolib.h
lib/audio/audioutil.h
lib/audio/snd.h
lib/audio/wave.h
lib/audio/voc.h
lib/audio/aiff.h
lib/audio/sound.h
lib/audio/soundlib.h
lib/audio/fileutil.h
lib/audio/8svx.h
lib/audio/Astreams.h
lib/audio/audio.h
lib/audio/Afuncproto.h
lib/audio/Afuncs.h
lib/audio/Amd.h
lib/audio/Amd.h
lib/audio/Aos.h
lib/audio/Aosdefs.h
lib/audio/Aproto.h
lib/audio/mutex.h
${CMAKE_BINARY_DIR}/release.h
${CMAKE_BINARY_DIR}/config.h
)

set(SRCS 
lib/audio/AlibAsync.c
lib/audio/Alibint.c
lib/audio/AuErrDes.c
lib/audio/AuFreeEData.c
lib/audio/CloseSvr.c
lib/audio/ConnSvr.c
lib/audio/CrFlow.c
lib/audio/DesFlow.c
lib/audio/Flush.c
lib/audio/HandleEv.c
lib/audio/IDOfEvent.c
lib/audio/KillClient.c
lib/audio/NextEvent.c
lib/audio/OpenSvr.c
lib/audio/ReqEvent.c
lib/audio/ScanEvents.c
lib/audio/ScanTEvent.c
lib/audio/SetElState.c
lib/audio/GetElState.c
lib/audio/SetElement.c
lib/audio/GetElement.c
lib/audio/SvrName.c
lib/audio/Sync.c
lib/audio/ReadEl.c
lib/audio/WriteEl.c
lib/audio/Util.c
lib/audio/SetElParms.c
lib/audio/GetDevAttr.c
lib/audio/SetDevAttr.c
lib/audio/CrBucket.c
lib/audio/DesBucket.c
lib/audio/GetBucAttr.c
lib/audio/ListBucket.c
lib/audio/ListDevice.c
lib/audio/GetSvrTime.c
lib/audio/SetClsDwnMd.c
lib/audio/GetClsDwnMd.c
lib/audio/convutil.c
lib/audio/fileutil.c
lib/audio/monitor.c
lib/audio/bcache.c
lib/audio/globals.c
lib/audio/Astreams.c
lib/audio/ErrHndlr.c
lib/audio/snd.c
lib/audio/wave.c
lib/audio/voc.c
lib/audio/aiff.c
lib/audio/8svx.c
lib/audio/sound.c
lib/audio/soundlib.c
lib/audio/mutex.c)

include_directories(${CMAKE_BINARY_DIR})
include_directories(config)
include_directories(lib)
add_definitions(-Dlinux -D__amd64__ -D_POSIX_C_SOURCE=199309L -D_POSIX_SOURCE -D_XOPEN_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE)
add_library(audio ${SRCS})
install(TARGETS 
    audio 
DESTINATION
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
)
install(FILES ${HEADERS} DESTINATION include/audio)


