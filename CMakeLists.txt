cmake_minimum_required(VERSION 3.16)

project(TrashGo VERSION 2.2.3 LANGUAGES CXX)
configure_file(version.h.in ${CMAKE_CURRENT_BINARY_DIR}/version.h @ONLY)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 请将 OpenCV 文件夹放在与 CMakeLists.txt 相同的目录下（建议 OpenCV 版本不低于 4.12.0）
# Place the OpenCV folder in the same directory as CMakeLists.txt (OpenCV version 4.12.0 or higher is recommended)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/opencv/build")
    set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv/build")
elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/cmake/opencv4")
    set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/cmake/opencv4")
endif()

set(COMPANY_NAME    "GitHub-ckckh2023")
set(PRODUCT_NAME    "TrashGo")
set(TARGET_NAME     "appTrashGo")
set(FILE_DESCRIPTION "TrashGo智识助手")
set(COPYRIGHT_NOTICE "版权所有@GitHub-ckckh2023")

find_package(Qt6 REQUIRED COMPONENTS Quick Core Sql Network Core5Compat)
find_package(OpenCV REQUIRED COMPONENTS core imgproc imgcodecs objdetect dnn)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appTrashGo
    main.cpp
)

qt_add_qml_module(appTrashGo
    URI TrashGo
    SOURCES include/GarbageClassifier.h src/GarbageClassifier.cpp
    SOURCES include/ImageProcessor.h src/ImageProcessor.cpp
    SOURCES include/ReturnImage.h src/ReturnImage.cpp
    SOURCES include/HistoryRecord.h src/HistoryRecord.cpp
    SOURCES include/GitHubOnline.h src/GitHubOnline.cpp
    SOURCES include/IniFileHandler.h src/IniFileHandler.cpp
    SOURCES include/GarbageData.h src/GarbageData.cpp

    QML_FILES Main.qml
    QML_FILES components/animation/CustomizeRipple.qml
    QML_FILES components/control/StandardButton.qml
    QML_FILES components/control/SideBarButton.qml
    QML_FILES components/control/SettingComboBox.qml
    QML_FILES components/control/SettingTextField.qml
    QML_FILES components/message/Toast.qml
    QML_FILES components/pages/HomePage.qml
    QML_FILES components/pages/GarbagePage.qml
    QML_FILES components/pages/SettingPage.qml
    QML_FILES components/pages/HistoryPage.qml
    QML_FILES components/pages/StarPage.qml
    QML_FILES components/pages/AboutDialog.qml
    QML_FILES components/settings/SettingItem.qml
    QML_FILES components/theme/Theme.qml
    QML_FILES components/pages/AboutDialog.qml
)

qt6_add_resources(appTrashGo "app_icons"
    PREFIX "/icons"
    FILES
        assets/images/icon_16.png
        assets/images/icon_32.png
        assets/images/icon_64.png
        assets/images/icon_128.png
        assets/images/home.png
        assets/images/classify.png
        assets/images/history.png
        assets/images/star.png
        assets/images/function.png
        assets/images/settings.png
        assets/images/TrashGo.png
        assets/images/TrashGo_dark.png

        assets/images/imageImport.png
        assets/images/recognizeResult.png
        assets/images/addImage.png
        assets/images/dragImage.png

        assets/images/unclassified.png
        assets/images/unclassified_dark.png
        assets/images/classified_FoodWaste.png
        assets/images/classified_HazardousWaste.png
        assets/images/classified_OtherWaste.png
        assets/images/classified_RecyclableWaste.png

        assets/images/comboBoxArrow.png

        assets/images/colorSetting.png
        assets/images/themeSetting.png
        assets/images/apiProviderSetting.png
        assets/images/apiKeySetting.png
        assets/images/localModel.png
        assets/images/rendererSetting.png

        assets/images/bookmarkHistory.png
        assets/images/bookmarkedHistory.png
        assets/images/deleteHistory.png

        assets/images/img_cy.jpg
        assets/images/img_khs.jpg
        assets/images/img_qt.jpg
        assets/images/img_yh.jpg
)
qt6_add_resources(appTrashGo "app_about"
    PREFIX "/about"
    FILES
        assets/images/GitHubicon.svg
        assets/images/Giteeicon.svg
        assets/images/Qticon.png
        assets/images/OpenCVicon.png
)

if(WIN32)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/version.rc.in ${CMAKE_CURRENT_BINARY_DIR}/version.rc @ONLY)
    target_sources(appTrashGo
        PRIVATE appicon.rc
        ${CMAKE_CURRENT_BINARY_DIR}/version.rc
    )
endif()

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTrashGo PROPERTIES
#   MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTrashGo
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
    PRIVATE Qt6::Core5Compat
    ${OpenCV_LIBS}
)

target_include_directories(appTrashGo PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

add_custom_command(
    TARGET appTrashGo POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:appTrashGo>/model
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:appTrashGo>/assets/fonts
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/model/haarcascade_frontalface_default.xml
        $<TARGET_FILE_DIR:appTrashGo>/model/haarcascade_frontalface_default.xml
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/model/ResNet.onnx
        $<TARGET_FILE_DIR:appTrashGo>/model/ResNet.onnx
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/model/MobileNet.onnx
        $<TARGET_FILE_DIR:appTrashGo>/model/MobileNet.onnx
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/assets/fonts/FZPinShangHei.ttf
        $<TARGET_FILE_DIR:appTrashGo>/assets/fonts/FZPinShangHei.ttf
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/assets/fonts/DingTalkJinBuTi.ttf
        $<TARGET_FILE_DIR:appTrashGo>/assets/fonts/DingTalkJinBuTi.ttf
)

include(GNUInstallDirs)

install(TARGETS appTrashGo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
