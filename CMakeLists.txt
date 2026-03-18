cmake_minimum_required(VERSION 3.16)

project(TrashGo VERSION 1.1.1 LANGUAGES CXX)
configure_file(version.h.in ${CMAKE_CURRENT_BINARY_DIR}/version.h @ONLY)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv/build")
set(COMPANY_NAME    "GitHub-ckckh2023")
set(PRODUCT_NAME    "TrashGo")
set(TARGET_NAME     "appTrashGo")
set(FILE_DESCRIPTION "TrashGo信息识别")
set(COPYRIGHT_NOTICE "版权所有@GitHub-ckckh2023")

find_package(Qt6 REQUIRED COMPONENTS Quick Core Sql Network Core5Compat)
find_package(OpenCV REQUIRED COMPONENTS core imgproc objdetect dnn)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appTrashGo
    main.cpp
)

qt_add_qml_module(appTrashGo
    URI TrashGo
    QML_FILES
        Main.qml
        SOURCES GarbageClassifier.h GarbageClassifier.cpp
        SOURCES ImageProcessor.h ImageProcessor.cpp
        SOURCES ReturnImage.h ReturnImage.cpp
        SOURCES HistoryRecord.h HistoryRecord.cpp
        SOURCES GitHubOnline.h GitHubOnline.cpp
    QML_FILES
        QML_FILES components/button/SideBarButton.qml
        QML_FILES components/pages/HomePage.qml
        QML_FILES components/animation/CustomizeRipple.qml
        QML_FILES components/button/StandardButton.qml
)

qt6_add_resources(appTrashGo "app_icons"
    PREFIX "/icons"
    FILES
        images/icon_16.png
        images/icon_32.png
        images/icon_64.png
        images/icon_128.png
        images/home.png
        images/classify.png
        images/history.png
        images/star.png
        images/function.png
        images/settings.png
        images/TrashGo.png
)

if(WIN32)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/version.rc.in ${CMAKE_CURRENT_BINARY_DIR}/version.rc @ONLY)
    target_sources(appTrashGo
        PRIVATE appicon.rc
        ${CMAKE_CURRENT_BINARY_DIR}/version.rc
    )
    target_link_libraries(appTrashGo
        PRIVATE dwmapi
    )
endif()

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTrashGo PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTrashGo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTrashGo
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::Sql
    PRIVATE Qt6::Network
    PUBLIC Qt6::Core5Compat
    ${OpenCV_LIBS}
)

target_include_directories(appTrashGo PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

add_custom_command(
    TARGET appTrashGo POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:appTrashGo>/model
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:appTrashGo>/fonts
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/haarcascade_frontalface_default.xml
        $<TARGET_FILE_DIR:appTrashGo>/model/haarcascade_frontalface_default.xml
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/ResNet.onnx
        $<TARGET_FILE_DIR:appTrashGo>/model/ResNet.onnx
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/FZPinShangHei.ttf
        $<TARGET_FILE_DIR:appTrashGo>/fonts/FZPinShangHei.ttf
)

include(GNUInstallDirs)

install(TARGETS appTrashGo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
