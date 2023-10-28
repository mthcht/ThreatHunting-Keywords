Different lists to work with the Elastic Stack without using sigma rules by https://github.com/ekitji

## Guide for detection in Windows logs
1. Download the th_keywords_elk.txt to your client where you have kibana access.

2. Go to Alerts (documentation) https://www.elastic.co/guide/en/security/7.17/detections-ui-exceptions.html
![image](https://github.com/Ekitji/ThreatHunting-Keywords/assets/41170494/8edf4151-5a14-4281-9ea3-58eb82020145)

3. Click on Upload Value lists
![image](https://github.com/Ekitji/ThreatHunting-Keywords/assets/41170494/d34a8cb0-77d9-4dde-b818-3c33d18e368b)

5. Upload your th_keywords_elk.txt (as a keyword list, which should be default selection by kibana)
6. Go to Create Rules (Rules → Detection rules (SIEM) → Create new rule. The Create new rule )

7. Select "Indicator Match"
![image](https://github.com/Ekitji/ThreatHunting-Keywords/assets/41170494/7f13d07c-bf3a-4f07-b415-44ff1bd62ba1)

8. NOTICE! Provided screenshot is only a example (documentation) https://www.elastic.co/guide/en/security/7.17/rules-ui-create.html#indicator-value-lists **change values as shown below (number 9-14)
![image](https://github.com/Ekitji/ThreatHunting-Keywords/assets/41170494/a8daaa41-44ee-434b-803a-8263ad1370cd)

9. **Source:** Choose your index for where you have your windows logs

10. **Custom query:** event.code (1 OR 4688)

11. **Indicator index patterns**: .items-{YOUR SPACE name}

12. **Indicator index query: list_id:** "th_keywords_elk.txt"

13. **Indicator mapping field:** process.command_line.text

14. **Indicator index field:** keyword

15. Go on and finish your rule creating according to your routines.


You can do the same with th_keywords_processnames_elk.txt and the other files **as long as the field type is text**
Upload it and follow the same steps, at number 12 change the list_id to th_keywords_processnames_elk.txt
Then change the indicator mapping field to process.name instead.


**Reference list**
rmm_domain_names_elk.txt is a custom list from https://github.com/jischell-msft/RemoteManagementMonitoringTools/blob/main/Network%20Indicators/RMM_SummaryNetworkURI.csv
