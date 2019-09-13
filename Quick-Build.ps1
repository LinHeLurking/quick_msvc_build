param(
    [parameter(Mandatory=$true)]
    [String[]] $input_files,
    [String] $o="a",
    [String] $configuration="Debug"
)

$output = $o

$original_dir = Get-Location

$temp_dir = "TEMP_QUICK_BUILD"

$build_dir = "build"

if(!(Test-Path $temp_dir)){
    New-Item -ItemType Directory $temp_dir
}

Set-Location $temp_dir

if(!(Test-Path $build_dir)){
    New-Item -ItemType Directory $build_dir
}

$no_cmake_file = !(Test-Path .\CmakeLists.txt)
$no_diff = $true 
$no_file_log = !(Test-Path ".\file_trace.log")

if(!$no_file_log){
    Write-Host "There is an existing file log, checking differences"
    foreach($file in $input_files){
        $__file = $file.Trim(".","`\")
        Add-Content file_trace_new.log "`"../$__file `""
    }
    Add-Content file_trace_new.log $output
    if($null -ne (Compare-Object (Get-Content .\file_trace.log) (Get-Content .\file_trace_new.log))){
        Write-Host "Replace old log with a new one"
        $no_diff = $false
        Remove-Item .\file_trace.log 
        Copy-Item .\file_trace_new.log .\file_trace.log 
    }   
    Remove-Item .\file_trace_new.log
}



if($no_cmake_file -or !$no_diff){
    Write-Host "Generate a suitable CmakeLists.txt"
    if(!$no_cmake_file){
        Remove-Item .\CmakeLists.txt
    } 
    Add-Content CmakeLists.txt "cmake_minimum_required (VERSION 3.8)`n" -NoNewline
    Add-Content CmakeLists.txt "add_executable ($output " -NoNewline
    foreach($file in $input_files){
        $__file = $file.Trim(".","`\")
        Add-Content CmakeLists.txt "`"../$__file `"" -NoNewline
        if($no_file_log){
            Add-Content .\file_trace.log "`"../$__file `""
        }
    }
    if($no_file_log){
        Add-Content file_trace.log $output
    }
    Add-Content CmakeLists.txt ")`n" -NoNewline
}

Set-Location $build_dir

cmake ..
cmake --build . --config $configuration
Set-Location $original_dir
