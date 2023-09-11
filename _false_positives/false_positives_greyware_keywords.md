Help me populate this page with the expected false positives you've encountered during your hunt. If a keyword is not relevant, we will completely remove it from the hunting list.

---

## Keyword: `*scp *@*:* *`
  - `*scp *@*:* *`
  - `*scp * *@*:*`

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
