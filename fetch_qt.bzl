"""qt library fetch"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _qt_from_official_components_impl(ctx):
    """Fetch Qt 6.10.0 from official components using PowerShell and native Windows tools."""
    
    # Qt 6.10.0 component URLs from official download.qt.io  
    base_url = "https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/qt6_6100/qt6_6100/qt.qt6.6100.win64_msvc2022_64/" # does not work on BMW environment
    base_url = "https://mirror.netcologne.de/qtproject/online/qtsdkrepository/windows_x86/desktop/qt6_6100/qt6_6100/qt.qt6.6100.win64_msvc2022_64/" # works on BMW environment
    
    # Essential Qt components for Qt 6.10.0 MSVC2022
    components = [
        "6.10.0-0-202510021201qtbase-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z",
        "6.10.0-0-202510021201qtdeclarative-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z",
        "6.10.0-0-202510021201qttools-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z",
        "6.10.0-0-202510021201qtsvg-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z"
    ]
    
    # Qt5Compat addon module
    qt5compat_url = "https://mirror.netcologne.de/qtproject/online/qtsdkrepository/windows_x86/desktop/qt6_6100/qt6_6100/qt.qt6.6100.addons.qt5compat.win64_msvc2022_64/"
    qt5compat_component = "6.10.0-0-202510021201qt5compat-Windows-Windows_11_24H2-MSVC2022-Windows-Windows_11_24H2-X86_64.7z"
    
    # Create PowerShell script to download and extract 7z files
    ps_script = """
# Qt 6.10.0 Official Component Downloader and Extractor
# Downloads individual 7z components from download.qt.io and combines them

$ErrorActionPreference = "Stop"
$baseUrl = "{base_url}"
$qt5compatUrl = "{qt5compat_url}"
$components = @(
    "{qtbase}",
    "{qtdeclarative}",
    "{qttools}",
    "{qtsvg}"
)
$qt5compatComponent = "{qt5compat}"

Write-Host "Downloading Qt 6.10.0 components from official download.qt.io repository..."

# Install 7-Zip if not available (needed for Windows Server 2022 which has tar without LZMA support)
$7zipPath = "C:\\Program Files\\7-Zip\\7z.exe"
if (-not (Test-Path $7zipPath)) {{
    Write-Host "Installing 7-Zip..."
    $7zipInstaller = "7z-installer.exe"
    Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z2408-x64.exe" -OutFile $7zipInstaller -UseBasicParsing
    Start-Process -FilePath $7zipInstaller -ArgumentList "/S" -Wait
    Remove-Item $7zipInstaller -Force
    Write-Host "7-Zip installed successfully"
}}

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
    # Use 7-Zip instead of tar for reliable 7z extraction
    & $7zipPath x $archive -y
    
    Remove-Item $archive -Force
}}

# Download and extract Qt5Compat addon
Write-Host "Downloading Qt5Compat addon: $qt5compatComponent"
$qt5compatUrl_full = $qt5compatUrl + $qt5compatComponent
$retryCount = 0
$maxRetries = 3
do {{
    try {{
        Invoke-WebRequest -Uri $qt5compatUrl_full -OutFile $qt5compatComponent -UseBasicParsing -TimeoutSec 120
        break
    }} catch {{
        $retryCount++
        if ($retryCount -ge $maxRetries) {{
            Write-Host "Failed to download Qt5Compat after $maxRetries attempts"
            throw
        }}
        Write-Host "Download failed, retrying ($retryCount/$maxRetries)..."
        Start-Sleep -Seconds 5
    }}
}} while ($retryCount -lt $maxRetries)

Write-Host "Extracting Qt5Compat: $qt5compatComponent"
& $7zipPath x $qt5compatComponent -y
Remove-Item $qt5compatComponent -Force

# Verify critical DLLs are present
Write-Host "Verifying Qt installation..."
$criticalDlls = @("Qt6Core.dll", "Qt6Gui.dll", "Qt6Widgets.dll", "Qt6Qml.dll", "Qt6Quick.dll")
$missingDlls = @()
foreach ($dll in $criticalDlls) {{
    $dllPath = Join-Path "bin" $dll
    if (-not (Test-Path $dllPath)) {{
        $missingDlls += $dll
        Write-Host "ERROR: Missing critical DLL: $dll at $dllPath"
    }} else {{
        Write-Host "Found: $dll"
    }}
}}

if ($missingDlls.Count -gt 0) {{
    Write-Host "ERROR: Qt installation incomplete. Missing DLLs: $($missingDlls -join ', ')"
    exit 1
}}

Write-Host "Qt 6.10.0 installation complete with Qt5Compat addon - files extracted with original structure!"
""".format(
        base_url=base_url,
        qt5compat_url=qt5compat_url,
        qtbase=components[0],
        qtdeclarative=components[1], 
        qttools=components[2],
        qtsvg=components[3],
        qt5compat=qt5compat_component,
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
        Label("@rules_qt//:qt_windows_x86_64.BUILD"),
    )

_qt_from_official_components = repository_rule(
    implementation = _qt_from_official_components_impl,
    attrs = {},
)

def _qt_from_official_components_linux_impl(ctx):
    """Fetch Qt 6.10.0 from official components for Linux using Python for hermetic extraction."""
    
    # Qt 6.10.0 component URLs from official mirror
    base_url = "https://mirror.netcologne.de/qtproject/online/qtsdkrepository/linux_x64/desktop/qt6_6100/qt6_6100/qt.qt6.6100.linux_gcc_64/"
    
    # Essential Qt components for Qt 6.10.0 Linux GCC
    components = [
        "6.10.0-0-202510021201icu-linux-Rhel8.6-x86_64.7z",
        "6.10.0-0-202510021201qtbase-Linux-RHEL_9_4-GCC-Linux-RHEL_9_4-X86_64.7z",
        "6.10.0-0-202510021201qtdeclarative-Linux-RHEL_9_4-GCC-Linux-RHEL_9_4-X86_64.7z",
        "6.10.0-0-202510021201qttools-Linux-RHEL_9_4-GCC-Linux-RHEL_9_4-X86_64.7z",
        "6.10.0-0-202510021201qtsvg-Linux-RHEL_9_4-GCC-Linux-RHEL_9_4-X86_64.7z",
        "6.10.0-0-202510021201qttranslations-Linux-RHEL_9_4-GCC-Linux-RHEL_9_4-X86_64.7z",
        "6.10.0-0-202510021201qtwayland-Linux-RHEL_9_4-GCC-Linux-RHEL_9_4-X86_64.7z",
    ]
    
    # Qt5Compat addon module
    qt5compat_url = "https://mirror.netcologne.de/qtproject/online/qtsdkrepository/linux_x64/desktop/qt6_6100/qt6_6100/qt.qt6.6100.addons.qt5compat.linux_gcc_64/"
    qt5compat_component = "6.10.0-0-202510021201qt5compat-Linux-RHEL_9_4-GCC-Linux-RHEL_9_4-X86_64.7z"
    
    # Create Python script for hermetic 7z extraction using py7zr
    python_script = """
import sys
import os
import urllib.request
import urllib.error
import subprocess
import tempfile

def download_file(url, filename, max_retries=3):
    '''Download file with retry logic'''
    for attempt in range(max_retries):
        try:
            print(f"Downloading: {{filename}} (attempt {{attempt + 1}}/{{max_retries}})")
            urllib.request.urlretrieve(url, filename)
            print(f"Downloaded: {{filename}}")
            return True
        except urllib.error.URLError as e:
            if attempt < max_retries - 1:
                print(f"Download failed: {{e}}, retrying...")
                continue
            else:
                print(f"Failed to download {{filename}} after {{max_retries}} attempts")
                return False
    return False

def install_and_import_py7zr():
    '''Install py7zr to a temporary location and import it'''
    import site
    
    # Create a temporary directory for installing py7zr
    temp_dir = tempfile.mkdtemp(prefix='py7zr_')
    print(f"Installing py7zr to temporary location: {{temp_dir}}")
    
    try:
        # Install py7zr using pip
        result = subprocess.run([
            sys.executable, '-m', 'pip', 'install', '--target', temp_dir, '--quiet', 'py7zr'
        ], capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"Failed to install py7zr: {{result.stderr}}")
            return None
        
        # Add to sys.path and import
        sys.path.insert(0, temp_dir)
        import py7zr
        print("py7zr installed and imported successfully")
        return py7zr
    except Exception as e:
        print(f"Error installing py7zr: {{e}}")
        return None

def extract_7z(archive_path, output_dir='.'):
    '''Extract 7z archive using py7zr'''
    print(f"Extracting: {{archive_path}}")
    
    # Try to import py7zr
    try:
        import py7zr
    except ImportError:
        # Install py7zr if not available
        py7zr = install_and_import_py7zr()
        if py7zr is None:
            print("ERROR: Failed to install py7zr")
            return False
    
    try:
        with py7zr.SevenZipFile(archive_path, mode='r') as archive:
            archive.extractall(path=output_dir)
        print(f"Extracted: {{archive_path}}")
        return True
    except Exception as e:
        print(f"ERROR: Failed to extract {{archive_path}}: {{e}}")
        return False

# Main execution
base_url = "{base_url}"
qt5compat_url = "{qt5compat_url}"

components = [
    "{icu}",
    "{qtbase}",
    "{qtdeclarative}",
    "{qttools}",
    "{qtsvg}",
    "{qttranslations}",
    "{qtwayland}",
]

qt5compat = "{qt5compat}"

print("Downloading Qt 6.10.0 components from official mirror...")

# Download and extract each component
for component in components:
    url = base_url + component
    if not download_file(url, component):
        sys.exit(1)
    
    if not extract_7z(component):
        sys.exit(1)
    
    os.remove(component)

# Download and extract Qt5Compat
print(f"Downloading Qt5Compat addon: {{qt5compat}}")
qt5compat_url_full = qt5compat_url + qt5compat
if not download_file(qt5compat_url_full, qt5compat):
    sys.exit(1)

if not extract_7z(qt5compat):
    sys.exit(1)

os.remove(qt5compat)

# Move ICU libraries from root to lib directory
print("Moving ICU libraries to lib directory...")
import glob
import shutil

lib_dir = 'lib'
if not os.path.exists(lib_dir):
    os.makedirs(lib_dir)

for icu_file in glob.glob('libicu*.so*'):
    dest = os.path.join(lib_dir, os.path.basename(icu_file))
    print(f"Moving {{icu_file}} to {{dest}}")
    shutil.move(icu_file, dest)

print("Qt 6.10.0 installation complete with Qt5Compat addon!")
""".format(
        base_url=base_url,
        qt5compat_url=qt5compat_url,
        icu=components[0],
        qtbase=components[1],
        qtdeclarative=components[2],
        qttools=components[3],
        qtsvg=components[4],
        qttranslations=components[5],
        qtwayland=components[6],
        qt5compat=qt5compat_component,
    )
    
    # Write Python script
    ctx.file("download_qt.py", python_script)
    
    # Execute Python script
    result = ctx.execute(["python3", "download_qt.py"])
    
    if result.return_code != 0:
        fail("Failed to download Qt 6.10.0: %s\nStderr: %s" % (result.stdout, result.stderr))
    
    # Use existing BUILD file for Qt Linux x86_64
    ctx.template(
        "BUILD.bazel",
        Label("@rules_qt//:qt_linux_x86_64.BUILD"),
    )

_qt_from_official_components_linux = repository_rule(
    implementation = _qt_from_official_components_linux_impl,
    attrs = {},
)

def fetch_qt6():
    """function which fetch remote prebuild qt libraries or use local qt(in macos)
    """

    # Qt 6.10.0 Windows x64 MSVC 2022 - Using official download.qt.io
    # Since individual Qt components need to be combined, let's use the custom repository rule
    _qt_from_official_components(name = "qt_windows_x86_64")

    # Qt 6.10.0 Linux x64 GCC - Using official mirror.netcologne.de
    # Since individual Qt components need to be combined, let's use the custom repository rule
    _qt_from_official_components_linux(name = "qt_linux_x86_64")

    http_archive(
        name = "qt_mac_aarch64",
        urls = [
            "https://vertexwahn.de/lfs/v1/qt_6.8.0_mac_aarch64_gamepad.tar.xz",
        ],
        sha256 = "07be3436bfb31b3a2e629907ca39a8652febe563046094cdc7373b7ff28228c4",
        strip_prefix = "Qt-6.8.0",
        build_file = "@rules_qt//:qt_mac_aarch64.BUILD",
    )
