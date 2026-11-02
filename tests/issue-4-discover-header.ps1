param([string]$HtmlPath = "outputs/index.html")
$ErrorActionPreference='Stop'
$html=Get-Content -Encoding UTF8 -Raw $HtmlPath
$script=[regex]::Match($html,'<script>([\s\S]*)</script>').Groups[1].Value
$tmp=Join-Path $env:TEMP 'tongchang-issue4.js';$script | Set-Content -Encoding UTF8 $tmp;node --check $tmp
$homeBlock=[regex]::Match($html,'function home\(\)\{([\s\S]*?)\}\nfunction nav').Groups[1].Value
if($homeBlock -match 'class="search"'){throw 'FAIL: discover search bar still present'}
if($homeBlock -notmatch 'aria-label='){throw 'FAIL: discover search icon missing'}
if($homeBlock -notmatch "go\('search'\)"){throw 'FAIL: search icon route missing'}
if($homeBlock.IndexOf('<div class="sectiontitle" style="margin:10px 0 2px">') -lt 0){throw 'FAIL: title slot missing'}
if($homeBlock.IndexOf('<div class="sectiontitle" style="margin:10px 0 2px">') -gt $homeBlock.IndexOf('<div class="chips">')){throw 'FAIL: title slot is below categories'}
if($homeBlock -notmatch 'class="chips"'){throw 'FAIL: category chips missing'}
Remove-Item $tmp -Force
Write-Output 'PASS: issue 4 discover header tests'
