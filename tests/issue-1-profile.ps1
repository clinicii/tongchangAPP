param([string]$HtmlPath = "outputs/index.html")
$ErrorActionPreference = 'Stop'
$html=Get-Content -Encoding UTF8 -Raw $HtmlPath
$script=[regex]::Match($html,'<script>([\s\S]*)</script>').Groups[1].Value
$tmp=Join-Path $env:TEMP 'tongchang-issue1.js';$script | Set-Content -Encoding UTF8 $tmp;node --check $tmp
$profile=[regex]::Match($html,'function profile\(\)\{([\s\S]*?)\}\nfunction profileCard').Groups[1].Value
if($profile -match '编辑主页'){throw 'FAIL: profile page still contains edit button'}
if($profile -notmatch "go\('profile-card'\)"){throw 'FAIL: profile card click route missing'}
if($html -notmatch 'function profileCard\(\)'){throw 'FAIL: profile card page missing'}
if($html -notmatch "state.view==='profile-card'"){throw 'FAIL: profile card render route missing'}
Remove-Item $tmp -Force
Write-Output 'PASS: issue 1 profile card tests'
