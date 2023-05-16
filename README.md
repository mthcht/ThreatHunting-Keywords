# ThreatHunting-Keywords
List of keywords for ThreatHunting sessions [offensive tools/greyware tools/signatures tools keywords]

## Content of the ThreatHunting Keywords File:
- Header: `keyword,metadata_keyword_type,metadata_tool,metadata_description,metadata_tool_techniques,metadata_tool_tactics,metadata_malwares_name,metadata_groups_name,metadata_category,metadata_link,metadata_enable_endpoint_detection,metadata_enable_proxy_detection,metadata_comment`

- `keyword`: The entries in this column represent non-case-sensitive keywords used for Threat Hunting. These keywords are flexible, allowing the use of wildcards to broaden or narrow your search parameters as needed.
- `metadata_keyword_type`: Type of the keywords, Currently, there are three types::
  - `offensive tool keyword`: These keywords relate to offensive tools or exhibit high confidence of malicious intent. It's crucial that these terms hold relevance and reliability in detecting potential threats (low false positive rate)
  - `greyware tool keyword`: Keywords in this category correspond to 'legitimate' tools that are abused by malicious actors. As these tools also have legitimate uses, the potential for false positives is inherently higher. It's important to interpret these results with the understanding that not all detections may signify malicious activity
  - `signature keyword`: These keywords may not directly associate with tools but may include security product signature names, specific strings, or words significant in threat detection.
  - `lolbas keyword`: `work in progress, not included in the public lookup` will include all lolbas commands exploitations techniques that can fit in the lookup without the correlation of multiple fields or events.
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
- `metadata_comment`: This field may contain a useful comment added for the keyword.

## Use the List to hunt with Splunk:
- upload the list `threathunting-keywords.csv` on Splunk
- create a lookup definition named `threathunting-keywords` for the lookup `threathunting-keywords.csv`
  - in the advanced options, add the Match type `WILDCARD(keyword)` and make sure `Case sensitive match` is not checked
- now we can use our lookup definition to hunt 🏹

### Example use cases with `threathunting-keywords`:

#### Hunt all the keywords in raw logs 😱

```
`myendpointslogs` 
| lookup threathunting-keywords keyword as _raw OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" AND metadata_enable_endpoint_detection=1
| stats count ealiest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```
Send the job to background and keep the job ID.

![image](https://github.com/mthcht/ThreatHunting-Keywords/assets/75267080/34daff6f-c290-447a-9184-d6fbbbef66bc)

- `myendpointslogs` is a macro that will search for all your endpoints logs, could be windows logs, EDR telemetry, sysmon, auditd, bastion sessions, powershell execution logs or any other logs that will monitor for process activity or file activity. (if you don't use macro, you can replace the macro with your index, tag or datamodel)
- `| lookup` this is very important, for big lookups like this one, always use `|lookup` instead of `|inputlookup`, `|lookup` will use the lookup pushed on the indexers when the bundle is replicated but `|inputlookup` will send to the indexers the search with all the lookup content each time, using `|lookup` we gain massive performances here (this search will execute for hours on big environments so better optimize our search.
- `... keyword as _raw OUTPUT keyword as keyword_detection` this is the part where we will match the field named `_raw` with the field `keyword` in our lookup , in splunk `_raw` is the raw log without any parsing (our use case). When a keyword match, the field `keyword_detection` will show the keyword in the lookup that matched on the field (`_raw`) here.
- `| search metadata_description!="" AND metadata_enable_endpoint_detection=1` we only focus on endpoints logs here so we add `metadata_enable_endpoint_detection=1` to only match on the relevant keywords for endpoint logs and metadata_description!="" to only have the matched keywords
- `| stats count ealiest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype` here i made a quick filter without all the fields of the lookup for the example (but you can also add them if you want to have more exclusions possibilities), this allows us to easily have an idea of which keyword is matching a lot so we can easily exclude the category or the tool if we have too many false positives for it !
- When my search is finished, how can i analyze the results ? you will have the raw logs ordered by keywords and keyword types, using `|loadjob myjobid` we can now manipulate the output with the relevant logs without searching again on all the logs.

Filter the result
```
| loadjob 1684146257.1495958
| search
  NOT (keyword_detection IN ("fixme","fixme","fixme")) 
  NOT (metadata_keyword_type IN ("fixme","fixme"))
  NOT (raw IN ("fixme","fixme","fixme"))
```
Exclude the requiered keywords, raw text or keyword types.
if if decide to exclude `greyware tool keyword` type (legitimate tools keywords that are abused by attackers) because this environment has too many results for this kind of tools, we have two options:

- Filter at the beggining of our initial search 
```
`myendpointslogs` 
| lookup threathunting-keywords keyword as _raw OUTPUT keyword as keyword_detection metadata_keyword_type metadata_tool metadata_description metadata_tool_techniques metadata_tool_tactics metadata_malwares_name metadata_groups_name metadata_category	metadata_link	metadata_enable_endpoint_detection metadata_enable_proxy_detection metadata_comment
| search metadata_description!="" metadata_keyword_type="offensive tool keyword" metadata_enable_endpoint_detection=1
| stats count ealiest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype 
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
| stats count ealiest(_time) as firsttime latest(_time) as lasttime values(_raw) as raw by metadata_keyword_type keyword_detection index sourcetype 
| convert ctime(*time)
```
Now it is the same as the first search but i changed the datasource for `mynetworklogs` and added `metadata_enable_proxy_detection=1` to match the relevant keywords for networklogs (better have proxy and DNS logs for this)

#### Hunt the keywords in other fields 🙂 (url,process,commandline,query...):

fixme



#### If you want me to add a tool to the list, create a issue with this template: https://github.com/mthcht/ThreatHunting-Keywords/issues/1
