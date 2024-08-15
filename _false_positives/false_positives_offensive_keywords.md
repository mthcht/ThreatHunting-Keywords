This page lists expected behaviors for certain keywords you might encounter during threat hunting sessions. If you're using my detection lists as part of your detection rules and creating exclusions referencing this page, I strongly recommend making the exclusions as specific as possible to your environnement to avoid overly broad filters. This resource is intended solely as a reference to help document expected behaviors and assist with large-scale triage by providing potential explanations for the results you observe. Keep in mind that attackers could exploit poorly defined exclusions ([example](https://br0k3nlab.com/LoFP/))

*Help me populate this page with the expected behaviors you've encountered during your hunt. If a keyword is not relevant, we will completely remove it from the hunting list.*


---
## Keyword: `*Add-MpPreference -ExclusionPath *`

### [MODORGANIZER](https://github.com/ModOrganizer2/modorganizer)

- process: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe Add-MpPreference -ExclusionPath "\"C:\Modding\MO2\""`
- parent_process: `C:\Users\mthcht\AppData\Local\Temp\is-DFK6J.tmp\Mod Organizer 2-6194-2-4-4-1640622655.tmp`

AND

- process: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe Add-MpPreference -ExclusionPath "\"C:\Users\mthcht\AppData\Local\ModOrganizer\""`
- parent_process: `C:\Users\mthcht\AppData\Local\Temp\is-DFK6J.tmp\Mod Organizer 2-6194-2-4-4-1640622655.tmp`

Recommandation: do not exclude this behavior, remove the exclusion path and uninstall the software (not something we want to see on your enterprise workstation but not malicious)

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

---

## keyword: `*bloodhound.exe*`

ref: https://wtfbins.wtf/bin/13

```
C:\Program Files (x86)\Silver Bullet Technology\Ranger\Logging\Bloodhound.exe
```

recommandation: exclude this process path along with the parent process along with the hashs observed for the legitimate tool

---
