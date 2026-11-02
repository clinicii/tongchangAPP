param([string]$HtmlPath = "outputs/index.html")
$ErrorActionPreference='Stop'
$html=Get-Content -Encoding UTF8 -Raw $HtmlPath
$script=[regex]::Match($html,'<script>([\s\S]*)</script>').Groups[1].Value
$tmp=Join-Path $env:TEMP 'tongchang-visual-style.js'
$script | Set-Content -Encoding UTF8 $tmp
node --check $tmp

$markers=@(
  'id="visual-refresh"',
  'Helvetica Neue',
  '--lime:#c5ff2b',
  '--purple:#7650f5',
  'function coverFor',
  'background-image:url',
  '.detailhero',
  '.thumb'
)
foreach($marker in $markers){
  if($html.IndexOf($marker) -lt 0){throw "FAIL: visual marker missing: $marker"}
}

$imageCount=([regex]::Matches($html,'https://(images\.unsplash\.com|prcdn\.fretls\.fastly\.net|prcdn\.fastly\.net)')).Count
if($imageCount -lt 3){throw "FAIL: high resolution image sources missing (found $imageCount)"}

foreach($route in @('function home()','function circle()','function profile()','function detail()','function chat()')){
  if($html.IndexOf($route) -lt 0){throw "FAIL: existing route marker missing: $route"}
}
Remove-Item $tmp -Force
Write-Output "PASS: visual style tests (imageSources=$imageCount)"
