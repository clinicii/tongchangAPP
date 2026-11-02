param([string]$HtmlPath = "outputs/index.html")
$ErrorActionPreference='Stop';$html=Get-Content -Encoding UTF8 -Raw $HtmlPath
$script=[regex]::Match($html,'<script>([\s\S]*)</script>').Groups[1].Value;$tmp=Join-Path $env:TEMP 'tongchang-issue4.js';$script | Set-Content -Encoding UTF8 $tmp;node --check $tmp
$homeBlock=[regex]::Match($html,'function home\(\)\{([\s\S]*?)\}\nfunction nav').Groups[1].Value
if($homeBlock -match 'class="search"'){throw 'FAIL: discover search bar still present'}
if($homeBlock -notmatch 'aria-label="搜索"'){throw 'FAIL: discover search icon missing'}
if($homeBlock -notmatch "go\('search'\)"){throw 'FAIL: search icon route missing'}
if($homeBlock.IndexOf('今天，去哪里') -gt $homeBlock.IndexOf('演唱会')){throw 'FAIL: today title is not before category content'}
if($homeBlock -notmatch '热门活动'){throw 'FAIL: activity list heading missing'}
Remove-Item $tmp -Force;Write-Output 'PASS: issue 4 discover header tests'
