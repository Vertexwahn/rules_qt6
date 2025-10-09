"""qt library fetch"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _qt_from_official_components_impl(ctx):
    """Fetch Qt 6.10.0 from official components using PowerShell and native Windows tools."""
    
    # Qt 6.10.0 component URLs from official download.qt.io  
    base_url = "https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/qt6_6100/qt6_6100/qt.qt6.6100.win64_msvc2022_64/"
    
    # Essential Qt components for Qt 6.10.0 MSVC2022
    components = [
        "6.10.0-0-202510021201qtbase-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z",
        "6.10.0-0-202510021201qtdeclarative-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z",
        "6.10.0-0-202510021201qttools-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z",
        "6.10.0-0-202510021201qtsvg-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z"
    ]
    
    # Create PowerShell script to download and extract 7z files
    ps_script = """
# Qt 6.10.0 Official Component Downloader and Extractor
# Downloads individual 7z components from download.qt.io and combines them

$ErrorActionPreference = "Stop"
$baseUrl = "{base_url}"
$components = @(
    "{qtbase}",
    "{qtdeclarative}",
    "{qttools}",
    "{qtsvg}"
)

Write-Host "Downloading Qt 6.10.0 components from official download.qt.io repository..."

# Download and extract each component
for ($i = 0; $i -lt $components.Length; $i++) {{
    $component = $components[$i]
    $url = $baseUrl + $component
    $archive = $component
    
    Write-Host "Downloading: $component"
    $retryCount = 0
    $maxRetries = 3
    do {{
        try {{
            Invoke-WebRequest -Uri $url -OutFile $archive -UseBasicParsing -TimeoutSec 120
            break
        }} catch {{
            $retryCount++
            if ($retryCount -ge $maxRetries) {{
                Write-Host "Failed to download $component after $maxRetries attempts"
                throw
            }}
            Write-Host "Download failed, retrying ($retryCount/$maxRetries)..."
            Start-Sleep -Seconds 5
        }}
    }} while ($retryCount -lt $maxRetries)
    
    Write-Host "Extracting: $component"
    # Extract directly - Qt archives already have the correct structure (bin/, lib/, include/, etc.)
    & tar -xf $archive
    
    Remove-Item $archive -Force
}}

Write-Host "Qt 6.10.0 installation complete - files extracted with original structure!"
""".format(
        base_url=base_url,
        qtbase=components[0],
        qtdeclarative=components[1], 
        qttools=components[2],
        qtsvg=components[3],
    )
    
    # Write PowerShell script
    ctx.file("download_qt.ps1", ps_script)
    
    # Execute PowerShell script
    result = ctx.execute([
        "powershell", "-ExecutionPolicy", "Bypass", "-File", "download_qt.ps1"
    ])
    
    if result.return_code != 0:
        fail("Failed to download Qt 6.10.0: %s\nStderr: %s" % (result.stdout, result.stderr))
    
    # Use dedicated BUILD file for Qt 6.10.0 Windows MSVC2022 x86_64 components
    ctx.template(
        "BUILD.bazel",
        Label("@rules_qt//:qt_6_10_0_windows_msvc2022_x86_x64_components.BUILD"),
    )

_qt_from_official_components = repository_rule(
    implementation = _qt_from_official_components_impl,
    attrs = {},
)

def fetch_qt6():
    """function which fetch remote prebuild qt libraries or use local qt(in macos)
    """

    # Qt 6.10.0 Windows x64 MSVC 2022 - Using official download.qt.io
    # Since individual Qt components need to be combined, let's use the custom repository rule
    _qt_from_official_components(name = "qt_windows_x86_64")

    http_archive(
        name = "qt_linux_x86_64",
        urls = [
            "https://vertexwahn.de/lfs/v1/qt_6.4.0_linux_desktop_gcc_64.tar.xz",
        ],
        sha256 = "809919895e2ac0567df9290676d4ec6cd1ed39c432dc5da0722b3104681fd376",
        strip_prefix = "6.4.0/gcc_64",
        build_file = "@rules_qt//:qt_linux_x86_64.BUILD",
    )

    http_archive(
        name = "qt_mac_aarch64",
        urls = [
            "https://vertexwahn.de/lfs/v1/qt_6.8.0_mac_aarch64_gamepad.tar.xz",
        ],
        sha256 = "07be3436bfb31b3a2e629907ca39a8652febe563046094cdc7373b7ff28228c4",
        strip_prefix = "Qt-6.8.0",
        build_file = "@rules_qt//:qt_mac_aarch64.BUILD",
    )
