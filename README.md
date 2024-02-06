# ThreatHunting-Keywords
🎯 List of keywords for ThreatHunting sessions

![image](images/thk2.png)

## Table of Contents
- [For the blueteam](#for-the-blueteam)
- [For the redteam](#for-the-redteam)
- [Content of the lookup](#content-of-the-threat-hunting-keywords-file)
- [Hunt wih a SIEM](#use-the-list-to-hunt-with-splunk)
  - [raw logs](#hunt-all-the-keywords-in-raw-logs-)
  - [specific fields](#hunt-the-keywords-in-other-fields--urlprocesscommandlinequery)
  - [speed](#speed)
  - [dashboard example](#dashboard-example)
  - [With ELK it's different](#With-ELK) 
- [Hunt without a SIEM](#dfir-hunt-for-keywords-in-files-no-siem)
  - [DFIR Optimized Hunt](#better-option-for-very-large-files-on-windows)
  - [YARA Rules](#YARA-Rules)
- [Website](#quick-datatable-to-search-for-keyword-can-be-improved-open-to-suggestions)
- [Expected False positives](#false-positives)
- [SIGMA rules](#sigma-rules)
- [contribute](#-contributing)

## Files
- [ThreatHunting-Keywords](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/threathunting-keywords.csv)
- [Greyware tools keywords](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/greyware_tool_keyword.csv)
- [Offensive tools keywords](https://raw.githubusercontent.com/mthcht/ThreatHunting-Keywords/main/offensive_tool_keyword.csv)
- [Signature keywords](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/signature_keyword.csv)
- [individual tools (one csv file by tool)](https://github.com/mthcht/ThreatHunting-Keywords/tree/main/tools)
- [All keywords only](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/only_keywords.txt)
- [All keywords regex only](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/only_keywords_regex.txt)
- [All keywords regex only (better perf)](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/only_keywords_regex_better_perf.txt)
- [Powershell script to hunt in files](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/DFIR_hunt_in_file.ps1)
- [Yara Rules](https://github.com/mthcht/ThreatHunting-Keywords-yara-rules/tree/main/yara_rules)
- [Sigma Rules](https://github.com/mthcht/ThreatHunting-Keywords-sigma-rules)

### For the blueteam:
This List can be valuable for ThreatHunters, SOC and CERT teams for static analysis on SIEM as it assists in identifying threat actors (or redteamers 😆) using default configurations from renowned exploitation tools in logs.
It differs from IOC feeds in its enduring relevance: the keywords here have no 'expiration dates' and can detect threats years after their inclusion, they are flexible accepting wildcard and non sensitive case matches and only focused on default keywords.

Primarily designed for Threat Hunting, this list can be useful in complex scenarios.
Whether you have access to a SIEM you don't manage, with unparsed data, or if you're part of a SOC team with a well-managed SIEM, the examples provided here can expedite the process of detecting malicious activity without the necessity to parse anything. If your logs are already parsed, this list can be used to match fields within your data, potentially transforming into a detection rule based on the keyword type category you select, provided the false positive rate is sufficiently low.

⚠️ **Not everything can be added in this list, we do not make complex behavior detections here, only simple keywords detections in fields or raw logs, aimed to detect default configurations**

⚠️ **A lot of tools in the list have dedicated detection rules, correlating events with thresholds and unique process relations... we will not cover all the possible detections for a tool here, only keywords detections**

If you're part of a Security Operations Center (SOC) and are managing hundreds of detection rules that rely solely on simple keyword detections without any field or event correlation, consider rethinking your approach. In my opinion, these should not constitute individual detection rules. Instead, they might be better suited to a consolidated list like this one, although implementation might be more challenging if you're not using a platform like Splunk.

This approach encourages the creation of high-quality, purposeful rules while keeping your simple field keyword detections organized and manageable in one place. The end result? One comprehensive detection rule that covers all of them. This streamlines your process and optimizes your detection capabilities.

### For the redteam:

To evade detection by simple keyword detection, it is critical to recompile and rename all custom strings, class or function names, variable names, argument names, executable names, default user-agents, certificates, or any other strings that could potentially be associated with the tools you are using during your operation. Employ the most common names for everything to blend in with normal traffic. Scripts located [here](https://github.com/mthcht/Purpleteam/blob/main/Logging/ThreatHunting.md#extract-informations-from-powershell-scripts) can assist you in identifying some of these.

However, if you're developing public "red team tools", consider aiding the blue team by using distinct names. Employ a default configuration with an exotic port, custom certificates, unique user-agents, specific function names and arguments that aren't common. This assists in creating a clear signature that can be used for simple keyword detections, so the blueteam can at least easily detect the script kiddies. 

## Content of the Threat Hunting Keywords File:
- Header: `keyword,metadata_keyword_type,metadata_tool,metadata_description,metadata_tool_techniques,metadata_tool_tactics,metadata_malwares_name,metadata_groups_name,metadata_category,metadata_link,metadata_enable_endpoint_detection,metadata_enable_proxy_detection,metadata_comment,metadata_severity_score,metadata_popularity_score`,`metadata_github_stars`,`metadata_github_forks`,`metadata_github_created_at`,`metadata_github_updated_at`

- `keyword`: The entries in this column represent non-case-sensitive keywords used for Threat Hunting. These keywords are flexible, allowing the use of wildcards to broaden or narrow your search parameters as needed.
- `metadata_keyword_type`: Type of the keywords, Currently, there are three types::
  - 🛠️ `offensive tool keyword`: These keywords relate to offensive tools or exhibit high confidence of malicious intent. It's crucial that these terms hold relevance and reliability in detecting potential threats (low false positive rate)
  - 🛠️ `greyware tool keyword`: Keywords in this category correspond to 'legitimate' tools that are abused by malicious actors. As these tools also have legitimate uses, the potential for false positives is inherently higher. It's important to interpret these results with the understanding that not all detections may signify malicious activity
  - 🛠️ `signature keyword`: These keywords may not directly associate with tools but may include security product signature names, specific strings, or words significant in threat detection.
- `metadata_tool`: Name of the tool we want to detect
- `metadata_description`: description of the tool we want to detect
- `metadata_tool_techniques`: MITRE techniques related to the tool we want to detect
- `metadata_tool_tactics`: MITRE tactics related to the tool we want to detect
- `metadata_malwares_name`: Names of malware variants that utilize the tool in question
- `metadata_groups_name`: Names of Threat actors groups associated with the tool
- `metadata_category`: Global category name of the tool. This may change later and suggestions are welcome.
- `metadata_link`: link to the tool (source code, articles, samples, blog ...)
- `metadata_enable_endpoint_detection`: Field indicating whether the keyword can be effectively employed in searches across endpoint logs. This includes but is not limited to Windows event logs, EDR, PowerShell logs, auditd, bastion sessions, Sysmon or any data source containing process and file activity fields.
  - If you can search the keyword in endpoint logs, the value is 1 (enabled).
  - If the keyword is not relevant for endpoint logs, the value is 0 (disabled).
- `metadata_enable_proxy_detection`: Field indicating the applicability of the keyword for searches within network logs (Proxy, DNS logs or any data with queries and URLs originating from the internal network)
  - If you can search the keyword in network activity logs, the value is 1 (enabled).
  - If the keyword is not relevant for network activity logs, the value is 0 (disabled).
- `metadata_popularity_score`: score from 1 to 10 (low to high popularity)
- `metadata_severity_score`: score from 1 to 10 (low to high severity)
- `metadata_comment`: This field may contain a useful comment added for the keyword.
- `metadata_github_stars`: Number of stars on the github project (if the tool is on github, if elsewhere the value is N/A) this is used to calculate the popularity score 
- `metadata_github_forks`: Number of forks on the github project (if the tool is on github, if elsewhere the value is N/A) can be used for dashboard stats of the most used tools
- `metadata_github_created_at`: Creation date of the github project (if the tool is on github, if elsewhere the value is N/A) can be used for dashboard stats
- `metadata_github_updated_at`: Last updated date of the github project (if the tool is on github, if elsewhere the value is N/A) can be used to track important offensive tools updates and adjust keywords detections

## Use the List to hunt with Splunk:
- upload the list `threathunting-keywords.csv` on Splunk
- create a lookup definition named `threathunting-keywords` for the lookup `threathunting-keywords.csv`
  - in the advanced options, add the Match type `WILDCARD(keyword)` and make sure `Case sensitive match` is not checked

  ![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/a49969f0-22ed-4f10-90f3-7fb7e3951a98)

- now we can use our lookup definition to hunt 🏹

## Example use cases with `threathunting-keywords`:
![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/07813e37-62de-4582-a784-2875ed0a2525)



### Hunt all the keywords in raw logs 😱

```
`myendpointslogs` 
| lookup threathunting-keywords keyword as _raw OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" AND metadata_enable_endpoint_detection=1
| stats count earliest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```
Send the job to background and keep the job ID.

![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/34daff6f-c290-447a-9184-d6fbbbef66bc)

- `myendpointslogs` is a macro that will search for all your endpoints logs, could be windows logs, EDR telemetry, sysmon, auditd, bastion sessions, powershell execution logs or any other logs that will monitor for process activity or file activity. (if you don't use macro, you can replace the macro with your index, tag or datamodel)
  - I intentionally incorporated a macro in the examples to demonstrate that the initial exploration can be done with any method that suits one's needs, be it a data model, tstats, tags, index/sourcetype. While tstats coupled with a datamodel is often the fastest route, filter with the command `TERM()` for specific searches before the `|lookup` if needed
- `| lookup` this is very important, for big lookups like this one, always use `|lookup` instead of `|inputlookup`, `|lookup` will use the lookup pushed on the indexers when the bundle is replicated but `|inputlookup` will send to the indexers the search with all the lookup content each time, using `|lookup` we gain massive performances here (this search will execute for hours on big environments so better optimize our search.
- `... keyword as _raw OUTPUT keyword as keyword_detection` this is the part where we will match the field named `_raw` with the field `keyword` in our lookup , in splunk `_raw` is the raw log without any parsing (our use case). When a keyword match, the field `keyword_detection` will show the keyword in the lookup that matched on the field (`_raw`) here.
- `| search metadata_description!="" AND metadata_enable_endpoint_detection=1` we only focus on endpoints logs here so we add `metadata_enable_endpoint_detection=1` to only match on the relevant keywords for endpoint logs and metadata_description!="" to only have the matched keywords
- `| stats count earliest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype` here i made a quick filter without all the fields of the lookup for the example (but you can also add them if you want to have more exclusions possibilities), this allows us to easily have an idea of which keyword is matching a lot so we can easily exclude the category or the tool if we have too many false positives for it !
- When my search is finished, how can i analyze the results ? you will have the raw logs ordered by keywords and keyword types, using `|loadjob myjobid` we can now manipulate the output with the relevant logs without searching again on all the logs.

Filter the result
```
| loadjob 1684146257.1495958
| search
  NOT (keyword_detection IN ("fixme","fixme","fixme")) 
  NOT (metadata_keyword_type IN ("fixme","fixme"))
  NOT (raw IN ("fixme","fixme","fixme"))
```
Exclude the required keywords, raw text or keyword types.
if if decide to exclude `greyware tool keyword` type (legitimate tools keywords that are abused by attackers) because this environment has too many results for this kind of tools, we have two options:

- Filter at the beggining of our initial search 
```
`myendpointslogs` 
| lookup threathunting-keywords keyword as _raw OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" metadata_keyword_type="offensive tool keyword" metadata_enable_endpoint_detection=1
| stats count earliest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```
I added a `metadata_keyword_type="offensive tool keyword"` to only focus on offensive tools that i am sure are used by malicious actors

- Or filter after our initial search (to gain a lot of time):
```
| loadjob 1684146257.1495958
| search metadata_keyword_type="offensive tool keyword"
```

So that was our Use case to search on raw logs in endpoint logs, if we want to search the keywords for network logs (anything that can log a query or an url), we simply change it to:
```
`mynetworklogs` 
| lookup threathunting-keywords keyword as _raw OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" AND metadata_enable_proxy_detection=1
| stats count earliest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```
Now it is the same as the first search but i changed the datasource for `mynetworklogs` and added `metadata_enable_proxy_detection=1` to match the relevant keywords for networklogs (better have proxy and DNS logs for this)

---

### Hunt the keywords in other fields 🙂 (url,process,commandline,query...):

#### Match only on url field:
```
`mynetworklogs` url=*
| lookup threathunting-keywords keyword as url OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" AND metadata_enable_proxy_detection=1
| stats count earliest(_time) as firsttime latest(_time) as lasttime values(url) as url by src_ip metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```

#### Match only on query field:
```
`mynetworklogs` query=*
| lookup threathunting-keywords keyword as query OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" AND metadata_enable_proxy_detection=1
| stats count earliest(_time) as firsttime latest(_time) as lasttime values(query) as query by src_ip metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```

#### Match on multiple fields at the same time, example for endpoint logs:
```
`myendpointslogs` 
| eval myfields=mvappend(service, process, process_command, parent_process, parent_process_command, grand_parent_process, grand_parent_process_command, file_path, file_name)
| lookup threathunting-keywords keyword as myfields OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" AND metadata_enable_endpoint_detection=1
| stats count earliest(_time) as firsttime latest(_time) as lasttime values(process) values(service) values(process_command) values(file_name) values(file_path) values(parent_process) values(parent_process_command) values(grand_parent_process) values(grand_parent_process_command) by metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```

#### Speed:

If the speed is a concern or you're planning to implement this as a scheduled detection rule, you might want to consider splitting the lookup into diffent lookups by choosing the metadata_keyword_type or metadata_tool column you want to use.

Note that filtering using the search command after the `|lookup` doesn't expedite the search process. If you want to concentrate on a specific portion of the lookup without dividing it, you should use the `|inputlookup` command along with the where clause. While this method may consume more CPU resources, it generally results in faster execution. For more details, check out the Splunk documentation on inputlookup: https://docs.splunk.com/Documentation/Splunk/latest/SearchReference/Inputlookup

#### With ELK:

![pngwing com](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/ba6c2a3d-15c4-4a32-9d25-e8a8eaaae927)

If you are working with the Elastic Stack, there is a lot of restrictions for lists (you cannot use special caracters, spaces ...), you have two options:
- Use another list available here in the same repo https://github.com/mthcht/ThreatHunting-Keywords/tree/main/elk (it's not a direct extract of threathunting-keywords.csv, it's modified for ELK)
- Use Sigma "hunting" rules, directly extracted from this project https://github.com/mthcht/ThreatHunting-Keywords-sigma-rules with pysigma for the convertion

### Dashboard Example
![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/804c74c1-c50e-4e50-93d4-507e202d8773)


## DFIR Hunt for keywords in files (No SIEM)
After conducting a thorough review of various tools, I discovered that [ripgrep](https://github.com/BurntSushi/ripgrep) significantly outperforms its competitors when it comes to rapidly matching an extensive list of regex patterns against each line of a large log file or even multiple files simultaneously. It proved to be the most efficient solution for handling massive amounts of data, providing unparalleled speed and flexibility.

### Hunt for evil in log file(s) with **Ripgrep** and the 'only_keywords_regex.txt' list
#### `rg.exe -f .\only_keywords_regex.txt .\EvtxECmd_Output.csv --multiline --ignore-case`
- .\only_keywords_regex.txt serves as the source file for the threat hunting keywords, transformed into regex patterns for precise matching. These patterns originate from the threathunting-keywords.csv file, which has undergone a conversion process for optimal compatibility with regex operations.
- .\EvtxECmd_Output.csv represents the target file in which the search will be conducted. In this context, it is a .csv format of a Windows event log, produced by exporting evtx logs. However, the flexibility of ripgrep allows you to replace this with any file of your choosing for detailed pattern search operations.
- --multiline option enables ripgrep to effectively handle and match patterns spanning across multiple lines, significantly broadening the scope of the search.
You will get the matched lines like this with the line number (but without the matching keyword)

![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/c5ef924d-7cee-4780-92d7-81b039ffa46c)

![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/9ecaefe3-82a0-4434-85ad-488067e43290)

#### Better option for very large files (on windows):
`powershell -ep Bypass -File .\DFIR_hunt_in_file.ps1 -patternFile "only_keywords_regex.txt" -targetFile "C:\Users\mthcht\collection\20230406154410_EvtxECmd_Output.csv" -rgPath "C:\Users\mthcht\Downloads\ripgrep-13.0.0-x86_64-pc-windows-msvc\ripgrep-13.0.0-x86_64-pc-windows-msvc\rg.exe"`
- `-targetFile`: specify the file to search in (in the example, a DFIR-ORC extract logs)
- `-patternFile`: the file containing the regex patterns `only_keywords_regex.txt`
- `-rgPath`: the path of the ripgrep executable

content of the powershell script (included in the repo):
```powershell
param (
    [Parameter(Mandatory=$true)]
    [string]$patternFile,
    [Parameter(Mandatory=$true)]
    [string]$targetFile,
    [Parameter(Mandatory=$true)]
    [string]$rgPath
)

Start-Transcript -Path "$PSScriptRoot\result_search.log" -Append -Force -Verbose

$totalLines = (Get-Content $patternFile | Measure-Object -Line).Lines
$currentLine = 0
Get-Content $patternFile | ForEach-Object {
    $currentLine++
    Write-Host "Searching for pattern $currentLine of $totalLines : $_"  
    & $rgPath --multiline --ignore-case $_ $targetFile | Write-Output 
}

Stop-Transcript -Verbose
```
The result of the search will be in `result_search.log` in the same directory as the script.

![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/0096d48e-6531-4264-8995-f6073107c461)



#### Better option for verylarge files (on linux):
`todo`


#### Hunt for evil in file only with powershell and the 'only_keywords.txt ' list (**slower** not recommmanded)

In powershell it's much slower but if you still want to do it this way, you can use the script below, it will tell you the line number matched and the corresponding keyword: 

`powershell.exe -ep Bypass -File .\hunt_keywords_windows.ps1 -k .\only_keywords.txt -f .\EvtxECmd_Output.csv`

<details>
  
```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$file,
    
    [Parameter(Mandatory=$true)]
    [string]$kw
)

$Keywords = Get-Content $kw
$result = @()

foreach ($Keyword in $Keywords) {
    $SearchTerm = $Keyword.Replace("*", ".*")
    $SearchTerm = [Regex]::Escape($SearchTerm).Replace("\.\*", ".*")
    
    $reader = New-Object System.IO.StreamReader($file)
    $lineNumber = 0
    while (($line = $reader.ReadLine()) -ne $null) {
        $lineNumber++
        if ($line -match $SearchTerm) {
            $result += New-Object PSObject -Property @{
                'Keyword' = $Keyword
                'LineNumber' = $lineNumber
                'Line' = $line
            }
        }
    }
    $reader.Close()
}

$result | Out-GridView
Read-Host -Prompt "Press Enter to exit"
```
</details>

### YARA Rules
![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/34001df3-a489-40c0-a1cf-a0a9b63d9944)

All the detection patterns of this project are automatically exported to yara rules in [ThreatHunting-Keywords-yara-rules](https://github.com/mthcht/ThreatHunting-Keywords-yara-rules)

Some hunting example with the yara rules:
![2023-10-20 20_23_59-(1) mthcht on X_ _The #ThreatHunting Keywords project is slowly progressing, alm](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/d90efb5b-8611-4e08-9d8e-fdab7b5d7483)
 
![2023-10-20 20_14_17-C__Users_Public_Pictures](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/29ad8916-d7d4-482d-a8bf-90df25e400f3)

![2023-10-21 11_14_15-Editing ThreatHunting-Keywords-yara-rules_README md at main · mthcht_ThreatHunti](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/7d992c46-28f0-4eb3-a0d7-f65fd37d6db6)
![2023-10-21 11_12_44-](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/8f41f0de-48e8-435d-afda-1268dedad34f)

## Quick datatable to search for keyword 
https://mthcht.github.io/ThreatHunting-Keywords/
![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/9a300d0a-5efa-4449-b044-a00f3f1d8a26)

## False positives

Contribute and add your false positives to the expected false positives [list](https://github.com/mthcht/ThreatHunting-Keywords/blob/main/_false_positives/false_positives_offensive_keywords.md)

## SIGMA Rules

Check out the lookup translated in [SIGMA rules](https://github.com/mthcht/ThreatHunting-Keywords-sigma-rules) i usually update it at the same time :) 

![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/11223acf-ccd6-4a6c-8038-6afd336d3629)


## 🤝 Contributing
Contributions, issues and feature requests are welcome!
#### If you want me to add a tool to the list, create a issue with this template: https://github.com/mthcht/ThreatHunting-Keywords/issues/1
#### Propose changes to the list with a PR (provide false positives feedbacks, logs sample if you can), if a keyword is generating too many false positives in too many environments we can delete it)
