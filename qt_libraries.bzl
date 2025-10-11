"""qt library defines - Qt 6.10.0 from qtbase, qtdeclarative, qttools, qtsvg"""

QT_LIBRARIES = [
    ## qtbase libraries
    ("core", "QtCore", "Qt6Core", []),
    ("concurrent", "QtConcurrent", "Qt6Concurrent", [":qt_core"]),
    ("dbus", "QtDBus", "Qt6DBus", []),
    ("gui", "QtGui", "Qt6Gui", [":qt_core", ":qt_dbus"]),
    ("network", "QtNetwork", "Qt6Network", [":qt_core"]),
    ("opengl", "QtOpenGL", "Qt6OpenGL", [":qt_gui", ":qt_core"]),
    ("opengl_widgets", "QtOpenGLWidgets", "Qt6OpenGLWidgets", [":qt_opengl", ":qt_widgets", ":qt_gui", ":qt_core"]),
    ("print_support", "QtPrintSupport", "Qt6PrintSupport", [":qt_widgets", ":qt_gui", ":qt_core"]),
    ("sql", "QtSql", "Qt6Sql", [":qt_core"]),
    ("test", "QtTest", "Qt6Test", [":qt_core"]),
    ("widgets", "QtWidgets", "Qt6Widgets", [":qt_core", ":qt_gui"]),
    ("xml", "QtXml", "Qt6Xml", [":qt_core"]),

    ("core5_compat", "QtCore5Compat", "Qt6Core5Compat", [":qt_core"]),

    ## qttools libraries  
    ("designer", "QtDesigner", "Qt6Designer", [":qt_xml", ":qt_opengl_widgets", ":qt_widgets", ":qt_gui", ":qt_core"]),
    ("designer_components", "QtDesignerComponents", "Qt6DesignerComponents", [":qt_designer", ":qt_xml", ":qt_widgets", ":qt_gui", ":qt_core"]),
    ("help", "QtHelp", "Qt6Help", [":qt_sql", ":qt_widgets", ":qt_gui", ":qt_core"]),
    ("ui_tools", "QtUiTools", "Qt6UiTools", [":qt_opengl_widgets", ":qt_widgets", ":qt_gui", ":qt_core"]),

    ## qtsvg libraries
    ("svg", "QtSvg", "Qt6Svg", [":qt_gui", ":qt_core"]),
    ("svg_widgets", "QtSvgWidgets", "Qt6SvgWidgets", [":qt_svg", ":qt_gui", ":qt_core"]),

    ## qtdeclarative - QML and Quick
    ("qml", "QtQml", "Qt6Qml", [":qt_core", ":qt_network"]),
    ("qml_compiler", "QtQmlCompiler", "Qt6QmlCompiler", [":qt_qml", ":qt_core"]),
    ("qml_core", "QtQmlCore", "Qt6QmlCore", [":qt_qml", ":qt_core"]),
    ("qml_local_storage", "QtQmlLocalStorage", "Qt6QmlLocalStorage", [":qt_qml", ":qt_sql", ":qt_core"]),
    ("qml_meta", "QtQmlMeta", "Qt6QmlMeta", [":qt_qml", ":qt_core"]),
    ("qml_models", "QtQmlModels", "Qt6QmlModels", [":qt_qml", ":qt_core"]),
    ("qml_network", "QtQmlNetwork", "Qt6QmlNetwork", [":qt_qml", ":qt_network", ":qt_core"]),
    ("qml_workerscript", "QtQmlWorkerScript", "Qt6QmlWorkerScript", [":qt_qml", ":qt_network", ":qt_core"]),
    ("qml_xml_list_model", "QtQmlXmlListModel", "Qt6QmlXmlListModel", [":qt_qml", ":qt_network", ":qt_core"]),

    ## Qt Quick
    ("quick", "QtQuick", "Qt6Quick", [":qt_gui", ":qt_qml"]),
    ("quick_controls2", "QtQuickControls2", "Qt6QuickControls2", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_basic", "QtQuickControls2Basic", "Qt6QuickControls2Basic", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_basic_style_impl", "QtQuickControls2BasicStyleImpl", "Qt6QuickControls2BasicStyleImpl", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    # Note: Windows-specific style implementations are excluded as they're not available on macOS/Linux
    # ("quick_controls2_fluent_win_ui3_style_impl", "QtQuickControls2FluentWinUI3StyleImpl", "Qt6QuickControls2FluentWinUI3StyleImpl", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_fusion", "QtQuickControls2Fusion", "Qt6QuickControls2Fusion", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_fusion_style_impl", "QtQuickControls2FusionStyleImpl", "Qt6QuickControls2FusionStyleImpl", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_imagine", "QtQuickControls2Imagine", "Qt6QuickControls2Imagine", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_imagine_style_impl", "QtQuickControls2ImagineStyleImpl", "Qt6QuickControls2ImagineStyleImpl", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_impl", "QtQuickControls2Impl", "Qt6QuickControls2Impl", [":qt_quick_templates2", ":qt_quick", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_material", "QtQuickControls2Material", "Qt6QuickControls2Material", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_material_style_impl", "QtQuickControls2MaterialStyleImpl", "Qt6QuickControls2MaterialStyleImpl", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_universal", "QtQuickControls2Universal", "Qt6QuickControls2Universal", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_controls2_universal_style_impl", "QtQuickControls2UniversalStyleImpl", "Qt6QuickControls2UniversalStyleImpl", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    # Note: Windows-specific style implementation excluded as it's not available on macOS/Linux
    # ("quick_controls2_windows_style_impl", "QtQuickControls2WindowsStyleImpl", "Qt6QuickControls2WindowsStyleImpl", [":qt_quick_templates2", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_dialogs2", "QtQuickDialogs2", "Qt6QuickDialogs2", [":qt_quick_dialogs2_quick_impl", ":qt_quick_dialogs2_utils", ":qt_quick", ":qt_gui", ":qt_qml", ":qt_core"]),
    ("quick_dialogs2_quick_impl", "QtQuickDialogs2QuickImpl", "Qt6QuickDialogs2QuickImpl", [":qt_quick_templates2", ":qt_quick_controls2_impl", ":qt_quick", ":qt_gui", ":qt_qml", ":qt_quick_dialogs2_utils", ":qt_core"]),
    ("quick_dialogs2_utils", "QtQuickDialogs2Utils", "Qt6QuickDialogs2Utils", [":qt_gui", ":qt_core"]),
    # Note: QtQuickEffects is new in Qt 6.10.0 and not available in Qt 6.8.0 (macOS)
    # ("quick_effects", "QtQuickEffects", "Qt6QuickEffects", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    ("quick_layouts", "QtQuickLayouts", "Qt6QuickLayouts", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    ("quick_particles", "QtQuickParticles", "Qt6QuickParticles", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    ("quick_shapes", "QtQuickShapes", "Qt6QuickShapes", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    # Note: The following libraries are new in Qt 6.10.0 and not available in Qt 6.8.0 (macOS)
    # ("quick_shapes_design_helpers", "QtQuickShapesDesignHelpers", "Qt6QuickShapesDesignHelpers", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    ("quick_templates2", "QtQuickTemplates2", "Qt6QuickTemplates2", [":qt_quick", ":qt_qml", ":qt_qml_models", ":qt_gui", ":qt_core"]),
    ("quick_test", "QtQuickTest", "Qt6QuickTest", [":qt_quick", ":qt_gui", ":qt_qml", ":qt_test", ":qt_core"]),
    # Note: QuickVectorImage libraries are new in Qt 6.10.0 and not available in Qt 6.8.0 (macOS)
    # ("quick_vector_image", "QtQuickVectorImage", "Qt6QuickVectorImage", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    # ("quick_vector_image_generator", "QtQuickVectorImageGenerator", "Qt6QuickVectorImageGenerator", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    # ("quick_vector_image_helpers", "QtQuickVectorImageHelpers", "Qt6QuickVectorImageHelpers", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    ("quick_widgets", "QtQuickWidgets", "Qt6QuickWidgets", [":qt_quick", ":qt_qml", ":qt_widgets", ":qt_opengl", ":qt_gui", ":qt_core"]),

    ## Qt Labs (from qtdeclarative)
    ("labs_animation", "QtLabsAnimation", "Qt6LabsAnimation", [":qt_qml", ":qt_core"]),
    ("labs_folder_list_model", "QtLabsFolderListModel", "Qt6LabsFolderListModel", [":qt_qml", ":qt_core"]),
    ("labs_platform", "QtLabsPlatform", "Qt6LabsPlatform", [":qt_qml", ":qt_gui", ":qt_core"]),
    ("labs_qml_models", "QtLabsQmlModels", "Qt6LabsQmlModels", [":qt_qml_models", ":qt_qml", ":qt_core"]),
    ("labs_settings", "QtLabsSettings", "Qt6LabsSettings", [":qt_qml", ":qt_core"]),
    ("labs_shared_image", "QtLabsSharedImage", "Qt6LabsSharedImage", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
    # Note: QtLabsSynchronizer and QtLabsWavefrontMesh are new in Qt 6.10.0
    # ("labs_synchronizer", "QtLabsSynchronizer", "Qt6LabsSynchronizer", [":qt_qml", ":qt_core"]),
    # ("labs_wavefront_mesh", "QtLabsWavefrontMesh", "Qt6LabsWavefrontMesh", [":qt_quick", ":qt_qml", ":qt_gui", ":qt_core"]),
]
