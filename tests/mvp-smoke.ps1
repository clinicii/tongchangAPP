param([string]$HtmlPath = "outputs/index.html")
$ErrorActionPreference = 'Stop'
$html = Get-Content -Encoding UTF8 -Raw $HtmlPath
$script = [regex]::Match($html, '<script>([\s\S]*)</script>').Groups[1].Value
$tmp = Join-Path $env:TEMP 'tongchang-mvp-check.js'
$script | Set-Content -Encoding UTF8 $tmp
node --check $tmp
$checks = @(
  @('single html entry', (Test-Path $HtmlPath)),
  @('main navigation', ($html -match "nav\('discover'\)" -and $html -match "nav\('circle'\)" -and $html -match "nav\('profile'\)")),
  @('search route', ($html -match "state.view==='search'")),
  @('match flow routes', ($html -match "state.view==='match'" -and $html -match "state.view==='matching'" -and $html -match "state.view==='results'")),
  @('circle post flow', ($html -match "state.view==='circle'" -and $html -match "state.view==='post'" -and $html -match "state.view==='create'")),
  @('local persistence', ($html -match 'localStorage' -and $html -match 'function save')),
  @('backup entry', ($html -match 'function backup' -and $html -match 'tongchang-backup.json')),
  @('source urls', ($html -match 'sourceUrl'))
)
foreach($c in $checks){ if(-not $c[1]){ throw "FAIL: $($c[0])" }; Write-Output "PASS: $($c[0])" }
foreach($pair in @(@('concert',"type:'concert'"),@('exhibition',"type:'exhibition'"),@('livehouse',"type:'livehouse'"))){$n=([regex]::Matches($html,$pair[1])).Count;if($n -lt 5){throw "FAIL: $($pair[0]) count=$n"};Write-Output "PASS: $($pair[0]) count=$n"}
Remove-Item $tmp -Force
Write-Output 'PASS: all MVP smoke checks'
