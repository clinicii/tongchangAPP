param([string]$HtmlPath = "outputs/index.html")
$ErrorActionPreference='Stop';$html=Get-Content -Encoding UTF8 -Raw $HtmlPath
$script=[regex]::Match($html,'<script>([\s\S]*)</script>').Groups[1].Value;$tmp=Join-Path $env:TEMP 'tongchang-issue3.js';$script | Set-Content -Encoding UTF8 $tmp;node --check $tmp
if($html -notmatch "feed:'recommend'"){throw 'FAIL: recommend feed data missing'}
if($html -notmatch "feed:'follow'"){throw 'FAIL: follow feed data missing'}
$rec=([regex]::Matches($html,"feed:'recommend'")).Count;$fol=([regex]::Matches($html,"feed:'follow'")).Count
if($rec -lt 2 -or $fol -lt 2){throw "FAIL: feed counts recommend=$rec follow=$fol"}
$images=([regex]::Matches($html,'images\.unsplash\.com')).Count
if($images -lt 8){throw "FAIL: high quality image urls count=$images"}
if($html -notmatch 'feedPosts=posts.filter'){throw 'FAIL: circle feed filter missing'}
Remove-Item $tmp -Force;Write-Output "PASS: issue 3 feed tests recommend=$rec follow=$fol images=$images"
