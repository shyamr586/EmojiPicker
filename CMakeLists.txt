cmake_minimum_required(VERSION 3.16)

project(EmojiPicker VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appEmojiPicker
    main.cpp
)

qt_add_qml_module(appEmojiPicker
    URI EmojiPicker
    VERSION 1.0
    QML_FILES
        Main.qml
        Model.qml
)

set_target_properties(appEmojiPicker PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

set(RESOURCE_FILES
    "emojipicker.qrc"
)


target_link_libraries(appEmojiPicker
    PRIVATE Qt6::Quick
)

install(TARGETS appEmojiPicker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
