#
# Qt modules configuration organized by platform and version
# Note: SHA256 hashes can be left empty initially - Bazel will report the correct hash on first download
#

# Other mirror
# https://mirror.netcologne.de/qtproject/online/qtsdkrepository/
QT_BASE_DOWNLOAD_URL = "https://download.qt.io/online/qtsdkrepository/"

QT_MODULES = {
    "linux": {
        "6.4.0": {
        "qt3d": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qt3d.gcc_64/6.4.0-0-202209270704qt3d-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "d8b34d32549b42b51785675d73ee593a968f9225b9e8ddbed1a294cb27c3b156",
        },
        "qtcharts": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtcharts.gcc_64/6.4.0-0-202209270704qtcharts-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "ee4fc2285c49496e1966557642c1a961fd989081ccfd81430b750b7bf2b84ad4",
        },
        "qtconnectivity": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtconnectivity.gcc_64/6.4.0-0-202209270704qtconnectivity-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "294542a2b89dd48a2d22085e85d5097b72975cb82c1a445bbaf0e3982aad41f6",
        },
        "qtdatavis3d": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtdatavis3d.gcc_64/6.4.0-0-202209270704qtdatavis3d-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "899e068b861543059467bbf12b43ccf4f0d60d13befe31ecfe62392f18b0c7ba",
        },
        "qthttpserver": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qthttpserver.gcc_64/6.4.0-0-202209270704qthttpserver-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "61ff18911a078b8b25420a86e4728d5f51f30b3a3ee211e660d31cd7486b8d32",
        },
        "qtimageformats": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtimageformats.gcc_64/6.4.0-0-202209270704qtimageformats-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "657f6af0fe3c489b6b413528918b1f055f6e047d75776a3b9b2e697e349d0477",
        },
        "qtlanguageserver": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtlanguageserver.gcc_64/6.4.0-0-202209270704qtlanguageserver-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "c25001d10161bc31a76348c44ed8244338849a17d66d4c4ee54ebcb14e98463f",
        },
        "qtlottie": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtlottie.gcc_64/6.4.0-0-202209270704qtlottie-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "2747018803b7b972bd9c76d775ecc6d296fd44eee4dc4f50da75cf08d6126c0a",
        },
        "qtmultimedia": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtmultimedia.gcc_64/6.4.0-0-202209270704qtmultimedia-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "53a29965311700c50d124856ddb80980ca8e8de14acf7f0cf13682099f361778",
        },
        "qtnetworkauth": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtnetworkauth.gcc_64/6.4.0-0-202209270704qtnetworkauth-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "f3ac84b94ad4869e41d4b6767d62dbe6a5ccb6e1c262b31db638b5e7f4064fd1",
        },
        "qtpdf": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtpdf.gcc_64/6.4.0-0-202209270704qtpdf-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "055bf9f904e44a89ef6d9c540fd180e3854f8792045c147323c722f16f624eb6",
        },
        "qtpositioning": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtpositioning.gcc_64/6.4.0-0-202209270704qtpositioning-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "fe3aa78d23496c0f89310239fe96f1b150a53bebd29e86608737f9b1072ff7fc",
        },
        "qtquick3dphysics": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtquick3dphysics.gcc_64/6.4.0-0-202209270704qtquick3dphysics-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "e0fc383db0cd80060ba38dbee2959b083aaa6c3d59bd4ba107976f4e2a1b9019",
        },
        "qtremoteobjects": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtremoteobjects.gcc_64/6.4.0-0-202209270704qtremoteobjects-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "17c3de554a9f7f2f87946d519d66b837cb679779af74ad3857f97097b6fc08b3",
        },
        "qtscxml": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtscxml.gcc_64/6.4.0-0-202209270704qtscxml-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "6128bc05ad7109cef4aaef51723f07447bfc6b8ed8da636caf340a36969bb62c",
        },
        "qtsensors": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtsensors.gcc_64/6.4.0-0-202209270704qtsensors-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "8cbb0e481ffc8cca16fe00800e104dd5effecdabbead2366add51d2c3fbfb183",
        },
        "qtserialbus": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtserialbus.gcc_64/6.4.0-0-202209270704qtserialbus-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "604e847072750d992c2f068334a9c13497ca601c9d3a45573f6970a50cfae67b",
        },
        "qtserialport": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtserialport.gcc_64/6.4.0-0-202209270704qtserialport-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "216e603e20ef82478b4a04f6226ba6a4488b0ea92a03349abcf9812914a8f4b0",
        },
        "qtspeech": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtspeech.gcc_64/6.4.0-0-202209270704qtspeech-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "a4b2e50db40f1e290acd794fdf17dd956cba17d5a20d29d93e94c10176198032",
        },
        "qtvirtualkeyboard": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtvirtualkeyboard.gcc_64/6.4.0-0-202209270704qtvirtualkeyboard-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "8e087e5c68b1e0009ce065ef03aa38a64ebc83b64d11f697f68811c963de9edf",
        },
        "qtwebchannel": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtwebchannel.gcc_64/6.4.0-0-202209270704qtwebchannel-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "46b91fa1e2d2e20e2d52522012e8704b6911c1bca2de30cea256f037c5d34cac",
        },
        "qtwebengine": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtwebengine.gcc_64/6.4.0-0-202209270704qtwebengine-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "dd4740fed3816fc9cab30d22397ccd81bfcf43ffbd7b0997012b96ebc999d680",
        },
        "qtwebsockets": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtwebsockets.gcc_64/6.4.0-0-202209270704qtwebsockets-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "3e523e029f18b991a078e818418430d76a1b9e8d0a3ffb1d00f3101a34762996",
        },
        "qtwebview": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.addons.qtwebview.gcc_64/6.4.0-0-202209270704qtwebview-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "5e681a2190c49e108ae1b91f2d160171e3ad0bde4e120ca6b4d01e1be1b745c0",
        },
        "qtbase": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.gcc_64/6.4.0-0-202209270704qtbase-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "247952825916fab207d258c41ddf1a5c0ab0007c7c02940fa995a4ead5cc03ea",
        },
        "qtsvg": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.gcc_64/6.4.0-0-202209270704qtsvg-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "96db59549864a205c83b0e4a7095c7d8a868af6930ce791f2df79b2fcb3245f1",
        },
        "qtdeclarative": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.gcc_64/6.4.0-0-202209270704qtdeclarative-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "ffebc23f2afa5cb75b7d59f9b2b1bf28a7120bf2b16ead2ad32e49812b9cd8f8",
        },
        "qttools": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.gcc_64/6.4.0-0-202209270704qttools-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "9c0eb05e86e129e38643af6fa17e5dfe75d5b49e8e1bbef2baa348066537efb7",
        },
        "qttranslations": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.gcc_64/6.4.0-0-202209270704qttranslations-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "72a644c4e6de3bdcbb8e85b8790b10858405c876ba19feac95a5b5087b72da18",
        },
        "qtwayland": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.qtwaylandcompositor.gcc_64/6.4.0-0-202209270704qtwayland-compositor-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "f902214a1ab83cfd5f1399ffefca9d45f1763b14acebcc2e0abcde279be98efb",
        },
        "icu": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.gcc_64/6.4.0-0-202209270704icu-linux-Rhel7.2-x64.7z",
            "sha256": "2ca8e8fb1af43cfd654bf89f82b1cc8d3d7bcb30db52ee0181231f7a2692a5d3",
        },
        "qt5compat": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.qt5compat.gcc_64/6.4.0-0-202209270704qt5compat-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "03d71fb047a5e1dc5fe80a633f8b628ebd75f0d6052931fb82c6a8c858b0cfbe",
        },
        "qtquick3d": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.qtquick3d.gcc_64/6.4.0-0-202209270704qtquick3d-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "108c375d2c1b743f3cece096f7f256dc46a9b99f3bd6e70e8427e06ba4f5ed92",
        },
        "qtquicktimeline": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.qtquicktimeline.gcc_64/6.4.0-0-202209270704qtquicktimeline-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "deeb73bcfae72a40676187058dab814ed8e8515f997176cf5a5f23d57c69ea46",
        },
        "qtshadertools": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_640/qt.qt6.640.qtshadertools.gcc_64/6.4.0-0-202209270704qtshadertools-Linux-RHEL_8_4-GCC-Linux-RHEL_8_4-X86_64.7z",
            "sha256": "23e7231917cee000350c85c3f7d6018df6f7a67ebe4ef3c0bbff51c69bbd118d",
        },
    },
    "6.8.3": {
        "qt3d": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qt3d.linux_gcc_64/6.8.3-0-202503201345qt3d-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "ca6d1b80336685f4f8c8fc755d816f9eb702c2198239c3d401693a27241a436c",
        },
        "qtcharts": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtcharts.linux_gcc_64/6.8.3-0-202503201345qtcharts-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "b3fa562b30ac7674d973b6174d04beb5f2aaba15e279aa50c502d540f0783c4a",
        },
        "qtdatavis3d": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtdatavis3d.linux_gcc_64/6.8.3-0-202503201345qtdatavis3d-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "313ce6a1ae10a722a964b27c9bf8df0d0f618b7d2672f1db9beed6a58422d3ce",
        },
        "qtlottie": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtlottie.linux_gcc_64/6.8.3-0-202503201345qtlottie-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "101ce039062ec9182324e395d30663bb30bcbbcea863760df9a152883f8b3184",
        },
        "qtscxml": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtscxml.linux_gcc_64/6.8.3-0-202503201345qtscxml-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "1cf7b326afa3e73c3a54b6648d10caa15adc0d93d499ebfba3832572ab20f476",
        },
        "qtvirtualkeyboard": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtvirtualkeyboard.linux_gcc_64/6.8.3-0-202503201345qtvirtualkeyboard-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "4964efb80031c17c4df1750e66927af43e51dce3649b33ac637b6004e0668212",
        },
        "qtwebchannel": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtwebchannel.linux_gcc_64/6.8.3-0-202503201345qtwebchannel-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "63baf38a2041a11aec1b71ad6f67cafb03d300394d729d18aca154de9f58b3e9",
        },
        "qtwebsockets": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtwebsockets.linux_gcc_64/6.8.3-0-202503201345qtwebsockets-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "66ff50a43a2b0c32ba01e061e932961d4a112ab04bd8c6fd337330135c7fac43",
        },
        "qtimageformats": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtimageformats.linux_gcc_64/6.8.3-0-202503201345qtimageformats-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "671f08723c657ff3b1d657dbda958a328711540a6b7221e5d42f9c5a573dc19c",
        },
        "qtnetworkauth": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtnetworkauth.linux_gcc_64/6.8.3-0-202503201345qtnetworkauth-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "ab1edbd363f28841c3a5e73f1040f49bf4bb70df1e2eec46184a194cbc2f5c21",
        },
        "qtsensors": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtsensors.linux_gcc_64/6.8.3-0-202503201345qtsensors-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "73b631f3a672a6166c7681caaf4dd4f0f09465fa3e1d26de37fb99606126d77f",
        },
        "qtserialport": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtserialport.linux_gcc_64/6.8.3-0-202503201345qtserialport-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "cd7cfbcb896a99155ecc262d2dfbcb2bff9f49620ed469e7ba33ee0772bda775",
        },
        "qtserialbus": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtserialbus.linux_gcc_64/6.8.3-0-202503201345qtserialbus-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "b18e301e92bdb5f4b4f62723be11813bf8def77eb5b41b122885a805fed287da",
        },
        "qtpositioning": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtpositioning.linux_gcc_64/6.8.3-0-202503201345qtpositioning-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "d476e66deac70527886a8a3ab18b69cc71e1004853253a931268b7737f774e37",
        },
        "qtconnectivity": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtconnectivity.linux_gcc_64/6.8.3-0-202503201345qtconnectivity-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "146e6210ea88b3394e16b2caa6b6df29c67e4e80949b3c409c1a145f270ca59b",
        },
        "qtmultimedia": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtmultimedia.linux_gcc_64/6.8.3-0-202503201345qtmultimedia-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "5d4fa3b0f8b84ad0d83b423362ccba8a77f295fbaf0bcdc19f1d355b8eb7cfaa",
        },
        "qtremoteobjects": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtremoteobjects.linux_gcc_64/6.8.3-0-202503201345qtremoteobjects-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "9683d05587b1d53415c8804eb6170d991e1b68c76cb60f7ad4816cbfcb847975",
        },
        "qtwebview": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtwebview.linux_gcc_64/6.8.3-0-202503201345qtwebview-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "7e9f72ae26b0576cb1063807dfb7ea10e9c63edf38a4d5361c5b68bb11f3305d",
        },
        "qt5compat": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qt5compat.linux_gcc_64/6.8.3-0-202503201345qt5compat-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "df9d7a94d647406055d48671b28580c252d035883db6d506bbf7fa5c5b73677c",
        },
        "qtshadertools": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtshadertools.linux_gcc_64/6.8.3-0-202503201345qtshadertools-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "47690a6b5047560f60bd0426d7ed950aaf4ae45c51ade025964d4dd8be9589b3",
        },
        "qtquicktimeline": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquicktimeline.linux_gcc_64/6.8.3-0-202503201345qtquicktimeline-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "c4b889fbf25e09a36a0d98b8965b153d74c609b36894519dc6bafe617d4330a2",
        },
        "qtquick3d": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquick3d.linux_gcc_64/6.8.3-0-202503201345qtquick3d-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "94f4239108d7bf2e89c4d9d1694d7ed71f3cc545557c6c586046ba2ea1338e10",
        },
        "qtlanguageserver": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtlanguageserver.linux_gcc_64/6.8.3-0-202503201345qtlanguageserver-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "e6157c382a9ceff00a6b0eb8ae189344befb468081be937291fa5265403fb0bc",
        },
        "qthttpserver": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qthttpserver.linux_gcc_64/6.8.3-0-202503201345qthttpserver-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "40bb6ce12f52bd49f0a851875ab003828ce6307b999500cc22f40518eb5b9e60",
        },
        "qtgrpc": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtgrpc.linux_gcc_64/6.8.3-0-202503201345qtgrpc-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "afeeaa68e0f06a17dec9bce64f5de81ffdbcd29732832a5e111f68ba309aabaa",
        },
        "qtquick3dphysics": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquick3dphysics.linux_gcc_64/6.8.3-0-202503201345qtquick3dphysics-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "53c577f88c97b97d9e302e9cbfb272e3cd033dca6e44c6a7a17e4a18bc48feb0",
        },
        "qtspeech": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtspeech.linux_gcc_64/6.8.3-0-202503201345qtspeech-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "d8008595bf21bcb86827c2fbf7b006432a55862e3979e0f32f25addbbffb0f50",
        },
        "qtlocation": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtlocation.linux_gcc_64/6.8.3-0-202503201345qtlocation-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "964079994991e421fe51d237d8a359cc4a000fc8cb2a0392f8cf9763ecec2e37",
        },
        "qtquickeffectmaker": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquickeffectmaker.linux_gcc_64/6.8.3-0-202503201345qtquickeffectmaker-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "940a6675f448ad686be011ac77a10a9a26fa7b3f48c9e71164b725da4b34524a",
        },
        "qtwaylandcompositor": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtwaylandcompositor.linux_gcc_64/6.8.3-0-202503201345qtwayland-compositor-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "60cd5bd4b486d60d44f5bf214c19f8ce13353cb072df38e51dfae3deb8b20995",
        },
        "qtgraphs": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtgraphs.linux_gcc_64/6.8.3-0-202503201345qtgraphs-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "8854a961629f92aa2ed05b480ebcde2d53ccc06603cee92edeb46c746cbbbd8d",
        },
        "icu": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.linux_gcc_64/6.8.3-0-202503201345icu-linux-Rhel8.6-x86_64.7z",
            "sha256": "a2543496e1280c6fa348e0791def5026d5bde9e5749d9fc2244866ab0bee8aed",
        },
        "qtbase": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.linux_gcc_64/6.8.3-0-202503201345qtbase-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "d8fe882cae71284a7ca906b70b42840376882fe96f22fce1ba5a7a70ceeec799",
        },
        "qtdeclarative": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.linux_gcc_64/6.8.3-0-202503201345qtdeclarative-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "6330a5ed0138393468be3ddcca458606e14a607f7191d8dbad3978004bdf29ee",
        },
        "qtsvg": {
            "url": QT_BASE_DOWNLOAD_URL + "linux_x64/desktop/qt6_683/qt6_683/qt.qt6.683.linux_gcc_64/6.8.3-0-202503201345qtsvg-Linux-RHEL_8_10-GCC-Linux-RHEL_8_10-X86_64.7z",
            "sha256": "e330eb3abed3e0b9c9a278da971ec67306969f35020a3d54350a6ee86d57983d",
        },
    },
},
"macos": {
    "6.8.3": {
        "qtbase": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.clang_64/6.8.3-0-202503201723qtbase-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtdeclarative": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.clang_64/6.8.3-0-202503201723qtdeclarative-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtsvg": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.clang_64/6.8.3-0-202503201723qtsvg-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qt5compat": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qt5compat.clang_64/6.8.3-0-202503201723qt5compat-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtconnectivity": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtconnectivity.clang_64/6.8.3-0-202503201723qtconnectivity-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qt3d": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qt3d.clang_64/6.8.3-0-202503201723qt3d-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtcharts": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtcharts.clang_64/6.8.3-0-202503201723qtcharts-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtdatavis3d": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtdatavis3d.clang_64/6.8.3-0-202503201723qtdatavis3d-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtmultimedia": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtmultimedia.clang_64/6.8.3-0-202503201723qtmultimedia-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtshadertools": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtshadertools.clang_64/6.8.3-0-202503201723qtshadertools-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtquick3d": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquick3d.clang_64/6.8.3-0-202503201723qtquick3d-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtquicktimeline": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquicktimeline.clang_64/6.8.3-0-202503201723qtquicktimeline-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtlottie": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtlottie.clang_64/6.8.3-0-202503201723qtlottie-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtscxml": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtscxml.clang_64/6.8.3-0-202503201723qtscxml-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtremoteobjects": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtremoteobjects.clang_64/6.8.3-0-202503201723qtremoteobjects-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtserialport": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtserialport.clang_64/6.8.3-0-202503201723qtserialport-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtserialbus": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtserialbus.clang_64/6.8.3-0-202503201723qtserialbus-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtsensors": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtsensors.clang_64/6.8.3-0-202503201723qtsensors-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtpositioning": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtpositioning.clang_64/6.8.3-0-202503201723qtpositioning-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtnetworkauth": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtnetworkauth.clang_64/6.8.3-0-202503201723qtnetworkauth-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtimageformats": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtimageformats.clang_64/6.8.3-0-202503201723qtimageformats-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qthttpserver": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qthttpserver.clang_64/6.8.3-0-202503201723qthttpserver-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtlanguageserver": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtlanguageserver.clang_64/6.8.3-0-202503201723qtlanguageserver-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtgrpc": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtgrpc.clang_64/6.8.3-0-202503201723qtgrpc-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtquick3dphysics": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquick3dphysics.clang_64/6.8.3-0-202503201723qtquick3dphysics-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtspeech": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtspeech.clang_64/6.8.3-0-202503201723qtspeech-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtlocation": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtlocation.clang_64/6.8.3-0-202503201723qtlocation-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtquickeffectmaker": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtquickeffectmaker.clang_64/6.8.3-0-202503201723qtquickeffectmaker-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtgraphs": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtgraphs.clang_64/6.8.3-0-202503201723qtgraphs-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtvirtualkeyboard": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtvirtualkeyboard.clang_64/6.8.3-0-202503201723qtvirtualkeyboard-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtwebchannel": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtwebchannel.clang_64/6.8.3-0-202503201723qtwebchannel-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtwebsockets": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtwebsockets.clang_64/6.8.3-0-202503201723qtwebsockets-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
        "qtwebview": {
            "url": QT_BASE_DOWNLOAD_URL + "mac_x64/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qtwebview.clang_64/6.8.3-0-202503201723qtwebview-MacOS-MacOS_14-Clang-MacOS-MacOS_14-X86_64-ARM64.7z",
            "sha256": "",
        },
    },
},
"windows": {
    "6.4.0": {
        "qtbase": {
            "url": QT_BASE_DOWNLOAD_URL + "windows_x86/desktop/qt6_640/qt.qt6.640.win64_msvc2022_64/6.4.0-0-202209270704qtbase-Windows-Windows_11_21H2-MSVC2022-Windows-Windows_11_21H2-X86_64.7z",
            "sha256": "",
        },
        "qtdeclarative": {
            "url": QT_BASE_DOWNLOAD_URL + "windows_x86/desktop/qt6_640/qt.qt6.640.win64_msvc2022_64/6.4.0-0-202209270704qtdeclarative-Windows-Windows_11_21H2-MSVC2022-Windows-Windows_11_21H2-X86_64.7z",
            "sha256": "",
        },
        "qtsvg": {
            "url": QT_BASE_DOWNLOAD_URL + "windows_x86/desktop/qt6_640/qt.qt6.640.win64_msvc2022_64/6.4.0-0-202209270704qtsvg-Windows-Windows_11_21H2-MSVC2022-Windows-Windows_11_21H2-X86_64.7z",
            "sha256": "",
        },
    },
    "6.8.3": {
        "qtbase": {
            "url": QT_BASE_DOWNLOAD_URL + "windows_x86/desktop/qt6_683/qt6_683/qt.qt6.683.win64_msvc2022_64/6.8.3-0-202503201308qtbase-Windows-Windows_11_23H2-MSVC2022-Windows-Windows_11_23H2-X86_64.7z",
            "sha256": "",
        },
        "qtdeclarative": {
            "url": QT_BASE_DOWNLOAD_URL + "windows_x86/desktop/qt6_683/qt6_683/qt.qt6.683.win64_msvc2022_64/6.8.3-0-202503201308qtdeclarative-Windows-Windows_11_23H2-MSVC2022-Windows-Windows_11_23H2-X86_64.7z",
            "sha256": "",
        },
        "qtsvg": {
            "url": QT_BASE_DOWNLOAD_URL + "windows_x86/desktop/qt6_683/qt6_683/qt.qt6.683.win64_msvc2022_64/6.8.3-0-202503201308qtsvg-Windows-Windows_11_23H2-MSVC2022-Windows-Windows_11_23H2-X86_64.7z",
            "sha256": "",
        },
        "qt5compat": {
            "url": QT_BASE_DOWNLOAD_URL + "windows_x86/desktop/qt6_683/qt6_683/qt.qt6.683.addons.qt5compat.win64_msvc2022_64/6.8.3-0-202503201308qt5compat-Windows-Windows_11_23H2-MSVC2022-Windows-Windows_11_23H2-X86_64.7z",
            "sha256": "",
        },
    },
},
}
