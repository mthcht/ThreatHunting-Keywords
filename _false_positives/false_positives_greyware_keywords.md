This page lists expected behaviors for certain keywords you might encounter during threat hunting sessions. If you're using my detection lists as part of your detection rules and creating exclusions referencing this page, I strongly recommend making the exclusions as specific as possible to your environnement to avoid overly broad filters. This resource is intended solely as a reference to help document expected behaviors and assist with large-scale triage by providing potential explanations for the results you observe. Keep in mind that attackers could exploit poorly defined exclusions ([example](https://br0k3nlab.com/LoFP/))

*Help me populate this page with the expected false positives you've encountered during your hunt. If a keyword is not relevant, we will completely remove it from the hunting list.*

---

## Keyword: `*MpCmdRun.exe* -disable*`

LogMeIn (RMM tool - not really a false positive if you want to detect the RMM tools)

  - `C:\ProgramData\Microsoft\Windows Defender\Platform\*\MpCmdRun.exe" -DisableService`
  - executed after the uninstall process of LogMeIn `C:\Program Files (x86)\LogMeIn\x64\rainst.exe" uninstall` (same process_id)


---

## Keyword: `*scp *@*:* *`
  - `*scp *@*:* *`
  - `*scp * *@*:*`
  - `*sftp *@*:* *`

MobaXterm default terminal

```python
Image: "C:\Users\cotero\DOCUME~1\MobaXterm\slash\bin\MobaSCP.exe"
Description: Command-line SCP/SFTP client
Product: MobaXterm terminal
Company: Mobatek
OriginalFileName: PSCP
CommandLine: "C:\Users\mthcht\DOCUME~1\MobaXterm\slash\bin\MobaSCP.exe" -v -batch -scp -load "TERM40648083" -ls mobauser@mobaserver:"" "." "."
CurrentDirectory: "C:\Users\mthcht\DOCUME~1\MobaXterm\slash\bin\"
User: "thunting\mthcht"
ParentImage: "C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe"
ParentCommandLine: "C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe" 
ParentUser: thunting\mthcht
```

exclude CommandLine = `"*\Users\*\MobaXterm\slash\bin\MobaSCP.exe" -v -batch -scp -load "TERM40648083" -ls mobauser@mobaserver*` with ParentImage = `C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe`

---

### Keyword: `*C:\Windows\MEMORY.DMP*`

Windows default dump location after a crash, exclude Image `C:\windows\System32\smss.exe` OR `C:\windows\system32\WerFault.exe` with file_path `C:\Windows\MEMORY.DMP`

---

### Keyword: `*whoami*`

Kaspersky kavfswp.exe changed whoami.exe file creation time
- Sysmon EventID 2
- process: `C:\Program Files (x86)\Kaspersky Lab\Kaspersky Security for Windows Server\kavfswp.exe`
- target file_path: `C:\Windows\SysWOW64\whoami.exe` OR `C:\Windows\System32\whoami.exe`
- user: `NT AUTHORITY\SYSTEM`

### Keyword: `reg*save*HKLM\*SYSTEM *`

`ir_agent.exe` is the core executable of the **Rapid7 Insight Agent** and it might be collecting registry information for vulnerability assessments, configuration analysis, or forensic investigations.

- parent_process_path: `C:\Program Files\Rapid7\Insight Agent\components\insight_agent\*\ir_agent.exe`
- process: `C:\Windows\System32\reg.exe save HKLM\SYSTEM "C:\Program Files\Rapid7\Insight Agent\components\insight_agent\common\ir_agent_tmp\agent.jobs.tem_realtime_*\tmp*\HKEY_LOCAL_MACHINE_SYSTEM.hiv`
- src_user: `*$`
