param(
  [Parameter(Mandatory = $true)]
  [int[]] $Ports,

  [string] $ListenAddress = '0.0.0.0',
  [int] $MaxRetries = 60,
  [int] $SleepSeconds = 2,
  [switch] $EnsureFirewall
)

$ErrorActionPreference = 'Stop'

function Get-WslIp {
  for ($i = 0; $i -lt $MaxRetries; $i++) {
    $out = (& wsl.exe hostname -I) 2>$null
    if ($LASTEXITCODE -eq 0 -and $out) {
      $ip = $out.Trim().Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries) |
            Where-Object { $_ -match '^\d+\.\d+\.\d+\.\d+$' -and $_ -ne '127.0.0.1' } |
            Select-Object -First 1
      if ($ip) { return $ip }
    }
    Start-Sleep -Seconds $SleepSeconds
  }
  throw "WSL IP not available after $MaxRetries retries."
}

try {
  $wslIp = Get-WslIp

  foreach ($p in $Ports) {
    & netsh interface portproxy delete v4tov4 listenaddress=$ListenAddress listenport=$p | Out-Null
    & netsh interface portproxy add    v4tov4 listenaddress=$ListenAddress listenport=$p connectaddress=$wslIp connectport=$p | Out-Null

    if ($EnsureFirewall) {
      $ruleName = "WSL Portproxy TCP $p"
      $null = & netsh advfirewall firewall show rule name="$ruleName" > $env:TEMP\fw.tmp 2>$null
      $exists = (Get-Content $env:TEMP\fw.tmp -ErrorAction SilentlyContinue) -join "`n" | Select-String -SimpleMatch "Rule Name: $ruleName"
      Remove-Item $env:TEMP\fw.tmp -ErrorAction SilentlyContinue
      if (-not $exists) {
        & netsh advfirewall firewall add rule name="$ruleName" dir=in action=allow protocol=TCP localport=$p | Out-Null
      }
    }
  }

  $time = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
  $self = $MyInvocation.MyCommand.Path
  Write-Output "[$time] Portproxy updated for ports: $($Ports -join ', ') -> $wslIp (by $self)"

} catch {
  Write-Error $_
  exit 1
}
