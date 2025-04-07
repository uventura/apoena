function CreateObjectDirectories {
    $sourceDirs = Get-ChildItem -Path "src" -Directory -Recurse
    $targetDirs = $sourceDirs | ForEach-Object {
        $_.FullName.Replace("src", "obj")
    }
    
    $targetDirs += "obj", "bin"

    foreach ($dir in $targetDirs) {
        if (-not (Test-Path $dir -PathType Container)) {
            New-Item -ItemType Directory -Path $dir | Out-Null
        }
    }
}

function CompileSourceFiles {
    $sourceFiles = Get-ChildItem -Path "src" -Filter *.c -Recurse | Select-Object -ExpandProperty FullName

    foreach ($file in $sourceFiles) {
        $relativePath = $file.Substring((Get-Item "src").FullName.Length + 1)
        $outputFile = Join-Path "obj" ($relativePath -replace "\\", "\") -replace "\.c$", ".o"
        $outputDir = Split-Path $outputFile
        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir | Out-Null
        }
        $compileCommand = "gcc -W -Wall -ansi -pedantic -std=c99 -g -O3 -Wno-unused-parameter -Wno-implicit-fallthrough -o `"$outputFile`" -c `"$file`" -Isrc"
        Invoke-Expression $compileCommand
    }
}

CreateObjectDirectories
CompileSourceFiles

$objectFiles = Get-ChildItem "obj\*.o" -Recurse | ForEach-Object { "`"$($_.FullName)`"" } | Out-String
$executable = "bin\apoena"
$linkCommand = "gcc -o `"$executable`" $objectFiles -W -Wall -ansi -pedantic -std=c99 -g -O3 -Wno-unused-parameter -Wno-implicit-fallthrough -Isrc"
Invoke-Expression $linkCommand
