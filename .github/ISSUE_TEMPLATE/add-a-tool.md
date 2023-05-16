---
name: Add a tool
about: adding a new tool to the list
title: ''
labels: ''
assignees: ''

---

If you want me to add keywords for a tool to the list use this template:

---
### Tool Name
>  ``

Provide the name of the tool

### Link to Official Website/Source Code (if available):
>  ``

Please provide a link to the tool's website or source code repository (GitHub, GitLab, etc.) or a link to a documentation (if available)

### Tool Description (if known)
>  ``

Please provide a description of the tool, its purpose, how it works, and its main features if you know the tool, if not, i can check it out.

### Known Use by malicious actors (if applicable):

>  ``

Please provide information on any known instances where the tool was used by malicious actors or how the tool could potentially be misused by malicious actors

### Tool Category (if known)
Please select one of the following categories for the tool: 
  - [ ] Offensive (the tool/command is used by attackers and is not legitimate)
  - [ ] Greyware (the tool can be use legitimately but is abused by malicious actors)
  - [ ] Generic Signatures/Keywords (Generic names or signatures observed for malwares in some security products)
---

Note: Submissions will be reviewed for relevance and potential misuse, i will make a list of relevant keywords for detection based on the tool code and documentation and test each of them for false positives on large datasets of multiple environments (300GB-1TB/day) before being added to the list.

I will decide if a tool is worth being added to the list, a tool that is widely recognized and extensively utilized within the community stands a better chance of inclusion compared to an unfamiliar or obscure new tool.
