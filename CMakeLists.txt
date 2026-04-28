cmake_minimum_required(VERSION 3.16)

project(TrashGo VERSION 2.0.1 LANGUAGES CXX)
configure_file(version.h.in ${CMAKE_CURRENT_BINARY_DIR}/version.h @ONLY)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/opencv/build")
    set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv/build")
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
    QML_FILES
        Main.qml
        SOURCES include/GarbageClassifier.h src/GarbageClassifier.cpp
        SOURCES include/ImageProcessor.h src/ImageProcessor.cpp
        SOURCES include/ReturnImage.h src/ReturnImage.cpp
        SOURCES include/HistoryRecord.h src/HistoryRecord.cpp
        SOURCES include/GitHubOnline.h src/GitHubOnline.cpp
        SOURCES include/IniFileHandler.h src/IniFileHandler.cpp

        QML_FILES components/control/SideBarButton.qml
        QML_FILES components/pages/HomePage.qml
        QML_FILES components/pages/GarbagePage.qml
        QML_FILES components/animation/CustomizeRipple.qml
        QML_FILES components/control/StandardButton.qml
        QML_FILES components/pages/SettingPage.qml
        QML_FILES components/settings/SettingItem.qml
        QML_FILES components/message/Toast.qml
        QML_FILES components/control/SettingComboBox.qml
        QML_FILES components/pages/HistoryPage.qml
        QML_FILES components/control/SettingTextField.qml
        QML_FILES components/pages/StarPage.qml
        QML_FILES components/message/CustomDialog.qml
        QML_FILES components/theme/Theme.qml
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
        images/TrashGo_dark.png

        images/imageImport.png
        images/recognizeResult.png
        images/addImage.png
        images/dragImage.png

        images/unclassified.png
        images/unclassified_dark.png
        images/classified_FoodWaste.png
        images/classified_HazardousWaste.png
        images/classified_OtherWaste.png
        images/classified_RecyclableWaste.png

        images/comboBoxArrow.png

        images/colorSetting.png
        images/themeSetting.png
        images/apiProviderSetting.png
        images/apiKeySetting.png
        images/rendererSetting.png

        images/bookmarkHistory.png
        images/bookmarkedHistory.png
        images/deleteHistory.png

        images/img_cy.jpg
        images/img_khs.jpg
        images/img_qt.jpg
        images/img_yh.jpg
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
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:appTrashGo>/fonts
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/model/haarcascade_frontalface_default.xml
        $<TARGET_FILE_DIR:appTrashGo>/model/haarcascade_frontalface_default.xml
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/model/ResNet.onnx
        $<TARGET_FILE_DIR:appTrashGo>/model/ResNet.onnx
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/fonts/FZPinShangHei.ttf
        $<TARGET_FILE_DIR:appTrashGo>/fonts/FZPinShangHei.ttf
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/fonts/DingTalkJinBuTi.ttf
        $<TARGET_FILE_DIR:appTrashGo>/fonts/DingTalkJinBuTi.ttf
)

include(GNUInstallDirs)

install(TARGETS appTrashGo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
