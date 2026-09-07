+++
title = "VHL Certificate Review"
date = 2021-01-02
path = "2021/01/02/vhl_review"
description = "Virtual Hacking Labs (VHL) 心得: Lab 難度分級、跟 HTB 的差異, 以及在 OSCP 考前練習的定位。"

[taxonomies]
tags = ["cert", "pentest"]
categories = ["Certificate"]
+++

大家安，今天來介紹一個OSCP考前不錯的練習網站。

<!-- more -->

VHL 全名 **Virtual Hacking Labs**，是reddit在討論考OSCP前不錯的練習網站時很多人推的練習網站，不像HTB有點CTF-ish，VHL是偏向real-world的。
而Labs分成三個等級：Basic、Advanced、Advanced+，
基本上只要找到正確的弱點就可以打下 **Basic** 的機器，**Advanced** 的機器需要的技巧就比較多了，像是：
* 從某台機器中找到另一台機器上 **CMS** 的密碼，接著植入 **webshell** 來取得機器的完整控制權
* 藉由弱掃工具找到弱點打進機器後透過 **Privilege Escalation** 取得機器的完整控制權

等等各式各樣的**弱點串連**，才能將大多數的Advanced機器打下。
而Advanced+的機器由於因為時間因素，所以沒辦法碰到任何一台。

那當初在考這張證照的時候正在準備研究所的考試，因此只買一個月的方案，
所以，我要拿到這張證照，就必須在這30天內打下**20**台機器，並繳交詳細的報告，並通過他們工作人員的線上審核才可以拿到，
而VHL有兩張證照可以考，其中一張就是我上面所介紹的，另一張則是需要打下**10**台Advanced+的機器，並且其中兩台需要透過 **manual exploitation** ，也就是不能使用任何自動化工具或者是公開的腳本。
更詳細的內容可以去參考他們的網站[https://www.virtualhackinglabs.com/](https://www.virtualhackinglabs.com/)

整體來說，非常滿意，因為真的能增進自己滲透測試的能力，像是要如何讀懂、瞭解原理並使用漏洞腳本，要拿到證照要打下20台漏洞都不同的機器，這個量加一加就大概40~50多個漏洞，也算挺多的，那未來準備考OSCP的時候，會再來挑戰Advanced+的機器。

謝謝大家看完這篇心得文。
