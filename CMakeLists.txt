cmake_minimum_required(VERSION 3.16)

project(OpenCV_attempt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv/build")

find_package(Qt6 REQUIRED COMPONENTS Quick Core Sql)
find_package(OpenCV REQUIRED COMPONENTS core imgproc objdetect dnn)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appOpenCV_attempt
    main.cpp
)

qt_add_qml_module(appOpenCV_attempt
    URI OpenCV_attempt
    QML_FILES
        Main.qml
        SOURCES imageprocessor.h imageprocessor.cpp
        SOURCES returnimage.h returnimage.cpp
        SOURCES garbageclassifier.h garbageclassifier.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appOpenCV_attempt PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appOpenCV_attempt
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appOpenCV_attempt
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::Sql
    ${OpenCV_LIBS}
)
target_link_libraries(appOpenCV_attempt PRIVATE Qt6::Core)

add_custom_command(
    TARGET appOpenCV_attempt POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/haarcascade_frontalface_default.xml
        $<TARGET_FILE_DIR:appOpenCV_attempt>/haarcascade_frontalface_default.xml
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/mobilenet.onnx
        $<TARGET_FILE_DIR:appOpenCV_attempt>/mobilenet.onnx
)

include(GNUInstallDirs)
install(TARGETS appOpenCV_attempt
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


