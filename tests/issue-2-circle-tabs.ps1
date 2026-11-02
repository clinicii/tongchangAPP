param([string]$HtmlPath = "outputs/index.html")
$ErrorActionPreference='Stop';$html=Get-Content -Encoding UTF8 -Raw $HtmlPath
$script=[regex]::Match($html,'<script>([\s\S]*)</script>').Groups[1].Value
$tmp=Join-Path $env:TEMP 'tongchang-issue2.js';$script | Set-Content -Encoding UTF8 $tmp;node --check $tmp
$circle=[regex]::Match($html,'function circle\(\)\{([\s\S]*?)\}\nfunction post').Groups[1].Value
if($circle -match '关注的人'){throw 'FAIL: people tab still present'}
if($circle -match '话题'){throw 'FAIL: topic tab still present'}
if($circle -notmatch 'recommend.*follow'){throw 'FAIL: recommend/follow tabs missing'}
Remove-Item $tmp -Force;Write-Output 'PASS: issue 2 circle tabs tests'
