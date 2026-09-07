+++
title = "CRTO Certificate Review"
date = 2022-09-25
path = "2022/09/25/CRTO_Certificate_Review"
description = "CRTO (Certified Red Team Operator) 心得: 課程內容、Lab 環境、考試流程與準備方向。"

[taxonomies]
tags = ["cert", "red team", "pentest"]
categories = ["Certificate"]
+++

大家安, 在上個月初的時候考到了 [Zero-Point Security](https://www.zeropointsecurity.co.uk/) 的 [CRTO](https://training.zeropointsecurity.co.uk/courses/red-team-ops), 臺灣目前還沒有相關的心得文, 所以分享一下, 讓大家多一個可以增進自己紅隊能力的方法

<!-- more -->
# Introduction
這篇文章大致會介紹 CRTO 是什麼, 所需的先備知識, 課程內容, 考試, 這幾個大部分

作者是 [Daniel Duggan (Rasta Mouse)](https://twitter.com/_RastaMouse/), HackTheBox 中的 RastaLab 就是這位作者創的

那 CRTO 和 CRTP 是不一樣的課程, 雖然兩張的受眾蠻像的, 但在內容還是有蠻多差別的, 如果想看 CRTP 的心得文做比較, 蠻推薦[這篇的](https://lonelysec.com/%E6%88%91%E7%9A%84-certified-red-team-professional-crtp-%E4%B9%8B%E6%97%85/)

這張證照以及作者大家可能比較陌生, 這邊先提幾個最大的賣點

1. 能以極低的價格 (£399.00 ≈ NTD 15,000) 使用到 **Cobalt Strike**
2. 為 Cobalt Strike **官方認證**的 Partenr
3. 課程內容包括**內網滲透**中各個**攻擊手法** (Kerberos Delegation, Abuse Domain Outbound Trust, LAPS, etc.), 以及如何以較**隱蔽**的方式, 執行這些攻擊手法, 也就是 **OPSEC**
4. 有一台建好的 **Kibana** 可以讓你觀察做完攻擊手法後會產生什麼 Event Log, 並思考如何不被偵測到 
5. 除技術性內容外, 課程內容還包括如何執行一個正確的紅隊演練
6. 如果有購買課程, **免費**享有後續更新課程, 並且最近要將課程和 Lab 中 Cobalt Strike 升級到最新的 4.7 版本
7. 人性化的考試方式 (4 天 48 小時, 就是在 4 天內把這 48 小時用完, 怎麼用沒關係, 想 12 小時 * 4 或 24 小時 * 2 都 OK)

這堂課會有一個專屬的 CRTO Discord channel, 有買這堂課的人才能加進去, 裡面的人都十分友善, 看到有人問問題會馬上回, 作者本人看到問題或是訊息也會馬上回, 裡面除了會討論 CRTO 之外, 也會討論其他技術性相關的事情, 算是一個還蠻活躍的小社群

## 為何我選擇這門課
因為我目前在奧義智慧科技 (CyCraft) 實習, 主要是研究 AD 相關的攻擊手法, 但大多數都是較為單點的攻擊手法研究, 對整個 AD 的攻擊鏈或是一個攻擊後續能做什麼使用沒有概念, 因此找了 CRTO 來考,

那在考之前也知道有這張證照, 本來是打算考完 OSCP 後再考這張的, 但由於近期 OSCP 考試有新增 AD, 加上工作上有需求, 再加上在履歷中能寫自己會使用 Cobalt Strike, 以一個學生來說算是還不錯的加分項目, 所以就先考 CRTO 了

那根據考過 OSCP 和 CRTO 的人說, CRTO 所涵蓋的 AD 遠超過 OSCP 所涵蓋的, 如果不像我是因為有工作上的需求, 加上手頭上的錢錢很夠的話, 推薦可以先考 OSCP

## 價格
價格表如下

| Types         | Price                |
| ------------- | -------------------- |
| Course Only   | £365.00 ≈ NTD 12,500 |
| Course + 40 hours Lab | £399.00 ≈ NTD 15,000 | 

如果想要分成 4 期付, 在購買課程的地方也有這個選項, 整體價格算是蠻親民的, 雖然這張證照是公司補助我的, 但也能明顯的看出金額比起市面上大家數的證照 (Offensive-Security, SANS, INE, etc.) 還便宜

## 所需的先備知識
> Before undertaking the course, students should have a basic knowledge and a working understanding of Windows & Active Directory; basic scripting and/or programming (PowerShell, C/C++ or C# would be a bonus); and networking.

這是直接從課程網頁節錄下來的, 簡單來說就是要對 AD 有一點點概念就 OK 了, 但有鑑於我平常實習就是在研究 AD, 所以可能不太有信服力, 加上如果目前還是學生應該沒有什麼機會可以碰到 AD, 所以這邊我有兩個推薦的資源

1. **TCM Academy 的 [Practical Ethical Hacking](https://academy.tcm-sec.com/p/practical-ethical-hacking-the-complete-course)**
	- 我有上過, 品質很好, 而且不單單只有帶到 AD, 連基礎的工具和手法也都有帶到, 算是不錯的入門課程
2. **TryHackMe 的 [Red Teaming Learning Path](https://tryhackme.com/path/outline/redteaming)**
	- 最近一個多月才出的, 就我看到別人的 review 是給予很好的評價, 並且那篇 review 也有提到這個 path 算是準備 CRTP 或 CRTO 很不錯的課程, 如果有一點滲透測試的基礎, 我推薦可以花個小錢 (大概 NTD 300) 來完成這條 path, 完成後無縫接軌 CRTP 或 CRTO 基本上應該是沒問題

# 課程內容
課程內容大概是這樣

> 1. Course Introduction
>     1. What is Red Teaming?
>     2. Phases of an Engagement
>     3. Command & Control
>     4. Cobalt Strike Primer
> 2. Planning & Client Engagement Phase
> 3. Assessment Phase
>     1. External Reconnaissance
>     2. Initial Compromise
>     3. Host Reconnaissance
>     4. Host Persistence
>     5. Host Privilege Escalation
>     6. Domain Reconnaissance
>     7. Lateral Movement
>     8. Credentials & User Impersonation
>     9. Password Cracking Hints & Tips
>     10. Session Passing
>     11. Pivoting
>     12. Reverse Port Forwards
>     13. Data Protection API
>     14. Kerberos
>     15. Group Policy
>     16. Discretionary Access Control Lists
>     17. MS SQL Servers
>     18. Domain Dominance
>     19. Forest & Domain Trusts
>     20. Local Administrator Password Solution
>     21. Bypassing Antivirus
>     22. Bypassing AppLocker
>     23. Data Hunting & Exfiltration
> 4. Post-Engagement & Reporting
> 5. Extending Cobalt Strike


可以看到很多內網滲透常見或用到的攻擊手法都有包括在裡面, 那除了教攻擊手法外, Rasta Mouse 還會講他自己在做紅隊時的**方法論** (methodology), 以及相關的 **OPSEC**, 網路上的教學文章相對來說比較少見, 如果想要了解更詳細的內容可以直接私訊我

## Lab
Lab 算是這個課程的重頭戲, Lab 裡共有 **4 個 domain**, 每個 domain 大概有 **4 台電腦**, 所以就是有大概 **16 台電腦**可以玩, 

要透過瀏覽器進到 SnapLabs 才能存取到 Lab, 使用起來我沒有什麼太大的問題, 

總共有 **40 個小時**可以做練習, 一開始會覺得有時限壓力很大, 但只要記得關掉, 基本上是不太會用完, 像我課程上完還有 25 小時還沒用, 所以可以放輕鬆地做練習

這 4 個 domain 都是兩兩相通的, 也就是 A 可以存取 B, B 可以存取 C, 但 A 不能存取 C, 以此類推, 那這個 Lab 的用意就是讓你練習課程中學到的各種技巧, 以及體驗實際使用 Cobalt Strike 在做紅隊演練時會是什麼感覺

Lab 中有一個 Kibana, 可以讓你觀察做完攻擊手法後會產生什麼 Log, 如果太顯眼的話, 可以想辦法隱藏自己的流量或是換成另一個能達到相同目的的攻擊手法

# 考試心得
那在考試之前我整個課程的內容大概**重做了三次**, 第一二次就是照著做, 第三次就針對比較不熟的地方來做練習

在你付完錢之後就可以預約考試了, 也可以今天預約隔天就考, 沒什麼太大的限制, 預約之後也可以改時間, 時限是 4 天 48 小時, 想怎麼分配都沒關係

然後考試的方式基本上跟 Lab 差不多, 可以想像成是有另外一個時限 48 小時然後不會給你任何資訊的 Lab, 可以隨時暫停跟開始, 暫停的時候雖然不會算時間, 但 Cobalt Strike 的 beacon 會全消失 (因為暫停就像關機一樣), 所以如果想要維持打下機器的 beacon 的話, 就需要想一些 persistence 的方法

考試**沒 rabbit hole**, 只要你好好上課, 作筆記, 並有理解課程內容的話, 會發現攻擊的路徑很清晰, 需要做的只有 **Think out of box** 而已

## 考試注意事項
那在原本的 Lab 中, defender 在幾個 domain 中是沒啟用的, 那 Rasta Mouse 為了要讓考試比較有挑戰性一點, 考試中所有的 domain 都有 enable defender, 雖然 defender 很好繞, 但還是要注意蠻多東西的

在你預約考試之後會有一份 Threat Profile 給你, 如果沒照著 Threat Profile 做的話, 會連一台機器都打不下來, 這邊推薦 malleable C2 profiles 要好好練習 

# 結語
那真的很推薦不論是學生, 做攻擊, 做防守的都可以去上跟考看看的, 因為會從裡面學到很多, 

學生可以碰到平常打 TryHackMe 或 HackTheBox 很少碰到的 AD 環境, 

做攻擊的可以學到 C2, 各種攻擊手法以及和手法相關的 OPSEC,

做防守的可以學到攻擊者是如何觀察到 AD 上可以被濫用的 "feature", 並透過這個 "feature" 達到什麼目的, 以及透過 Lab 中的 Kibana 觀察, 在做 recon 或是攻擊手法會有什麼 Log 

整體來說是真的很推薦, 除非已經是紅隊大佬, 啪一下就可以打下整個企業 AD, 不然或多或少都能學到東西

那 Rasta Mouse 在近期也有出 [CRTO II](https://training.zeropointsecurity.co.uk/courses/red-team-ops-ii), 比起 CRTO, 比較著重在 Bypass EDR 這個面向, 雖然我還沒實際出去工作, 但實不實會看到有文章或是 talk 在說 Red Team 是 EDR Bypass Team, 從這邊就可以看的出來在實戰上, EDR 對攻擊者來說算是一個很大的挑戰

那有些人可能會好奇 OSCP, CRTP, CRTO, OSEP 這幾張偏紅隊證照的比較, 但我目前能力還不夠, 只考過 CRTO 一張, 等未來都把這些證照補齊, 沒意外應該是會寫一篇比較的文章

# Good Review
- <https://www.youtube.com/watch?v=2IPxJSIe-lk>
- <https://www.youtube.com/watch?v=P2ioSJdcAJw>
- <https://m3rcer.github.io/redteaming/CRTO_Exam_Review/>
- <https://jonyschats.nl/posts/CRTO-review/>
- <https://0xash.io/Certified-Red-Team-Operator-Review/#>
- <https://http418infosec.com/certified-red-team-operator-crto-review>
- <https://amirr0r.github.io/posts/crto-review/>
- <https://gustavshen.medium.com/my-crto-course-and-exam-review-433f967f712e>
- <https://jakemai0.github.io/posts/crto/>