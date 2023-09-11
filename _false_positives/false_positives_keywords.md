## Keyword: `*DisableRealtimeMonitoring $true*`

Antivirus disabling Defender Real time protection

### MCAFEE

Security EventID 4688
```xml
        <Data Name="NewProcessName">C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Data>
        <Data Name="CommandLine">-Command Set-MpPreference -DisableRealtimeMonitoring $true</Data>
        <Data Name="ParentProcessName">C:\Program Files\McAfee\Endpoint Security\Threat Prevention\mfetp.exe</Data>
```

Sysmon EventID 1
```xml
        <Data Name="Image">C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Data>
        <Data Name="OriginalFileName">PowerShell.EXE</Data>
        <Data Name="CommandLine">-Command Set-MpPreference -DisableRealtimeMonitoring $true</Data>
        <Data Name="CurrentDirectory">C:\WINDOWS\system32\</Data>
        <Data Name="User">AUTORITY NT\System</Data>
        <Data Name="ParentImage">C:\Program Files\McAfee\Endpoint Security\Threat Prevention\mfetp.exe</Data>
        <Data Name="ParentCommandLine">"C:\Program Files\McAfee\Endpoint Security\Threat Prevention\mfetp.exe" -mms</Data>
        <Data Name="ParentUser">AUTORITY NT\System</Data>
```

---
