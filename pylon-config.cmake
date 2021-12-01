if(NOT TARGET pylon::base)
  add_library(pylon::pylon_base SHARED IMPORTED)
  set_target_properties(pylon::pylon_base PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include"
    IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/libpylonbase-6.2.0.so"
  )
endif()

if(NOT TARGET pylon::utility)
  add_library(pylon::pylon_utility SHARED IMPORTED)
  set_target_properties(pylon::pylon_utility PROPERTIES
    IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/libpylonutility-6.2.0.so"
  )
endif()

if(NOT TARGET pylon::gen)
  add_library(pylon::pylon_gen SHARED IMPORTED)
  set_target_properties(pylon::pylon_gen PROPERTIES
    IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/libGenApi_gcc_v3_1_Basler_pylon.so"
  )
endif()

if(NOT TARGET pylon::gc)
  add_library(pylon::pylon_gc SHARED IMPORTED)
  set_target_properties(pylon::pylon_gc PROPERTIES
    IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/libGCBase_gcc_v3_1_Basler_pylon.so"
  )
endif()

if(NOT TARGET pylon::pylon)
  add_library(pylon::pylon INTERFACE IMPORTED)
  target_link_libraries(pylon::pylon INTERFACE pylon::base pylon::utility pylon::gen pylon::gc)
endif()
