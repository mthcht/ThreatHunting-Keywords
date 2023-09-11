*Help me populate this page with the expected false positives you've encountered during your hunt. If a keyword is not relevant, we will completely remove it from the hunting list.*

---
## Keyword: `*DisableRealtimeMonitoring $true*`
  - `*Set-MpPreference -DisableRealtimeMonitoring *true*`
  - `*DisableRealtimeMonitoring $true*`

**Antivirus disabling Defender Real time protection**

### MCAFEE

Security EventID 4688
```xml
        <Data Name="NewProcessName">C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Data>
        <Data Name="CommandLine">-Command Set-MpPreference -DisableRealtimeMonitoring $true</Data>
        <Data Name="ParentProcessName">C:\Program Files\McAfee\Endpoint Security\Threat Prevention\mfetp.exe</Data>
```
recommandation: exclude the ParentProcessName + CommandLine

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
recommandation: exclude the ParentImage + ParentUser + ParentCommandLine + CommandLine 

---

## Keyword: `*\Ninja.py*`

### Node module gyp

Sysmon Event ID 11
```xml
        <Data Name="Image">C:\Program Files\nodejs\node.exe</Data>
        <Data Name="TargetFilename">C:\Users\mthcht\AppData\Local\Yarn\Cache\v6\npm-node-gyp-9.4.0-integrity\node_modules\node-gyp\gyp\pylib\gyp\generator\ninja.py</Data>
```

recommandation: exclude Image `*\Program Files\nodejs\node.exe` + TargetFilename `C:\Users\*\AppData\Local\Yarn\Cache\v6\npm-node-gyp-*-integrity\node_modules\node-gyp\gyp\pylib\gyp\generator\ninja.py`

