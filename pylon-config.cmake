set(PYLON_LIBS "${CMAKE_CURRENT_LIST_DIR}/lib/libpylonbase-6.2.0.so"
               "${CMAKE_CURRENT_LIST_DIR}/lib/libpylonutility-6.2.0.so"
               "${CMAKE_CURRENT_LIST_DIR}/lib/libGenApi_gcc_v3_1_Basler_pylon.so"
               "${CMAKE_CURRENT_LIST_DIR}/lib/libGCBase_gcc_v3_1_Basler_pylon.so")

if(NOT TARGET pylon::pylon)
  add_library(pylon::pylon SHARED IMPORTED)
  set_target_properties(pylon::pylon PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include"
    IMPORTED_LOCATION "${PYLON_LIBS}"
  )
endif()
