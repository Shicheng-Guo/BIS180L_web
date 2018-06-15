---
title: "Terminating Your Instance"
layout: post
tags:
hidden: true
---

1. Go to your AWS E2C machines
2. Select machines to terminate (Note you have machines running in **two or three** locations: **Virgina** and **Oregon** OR **Califonia**)
3. Select *Actions > Change Termination Protection*
![]({{site.baseurl}}/images/AWS_Termination_Protection.png)
4. Select *Yes Disable*
5. Select *Actions > Instance State > Terminate*
![]({{site.baseurl}}/images/AWS_Termination.png)
6. After both instances are terminated select *Elastic IPs*
7. Select *Actions > Release addresses*
![]({{site.baseurl}}/images/AWS_Elastic_IP.png)
8. Then go back to N. California or Oregon
9. Select Volumes on the left hand side
10. Right click your Volume and select *Delete Volume*
![]({{site.baseurl}}/images/AWS_Volume.png)
