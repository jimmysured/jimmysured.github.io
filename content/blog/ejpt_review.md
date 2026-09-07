+++
title = "eJPT Certificate Review"
date = 2020-08-07
path = "2020/08/07/ejpt_review"
description = "eJPT review: what the course and exam cover, how to prepare, and who this entry-level pentest cert suits."

[extra]
lang = "zh"

[taxonomies]
tags = ["cert", "pentest"]
categories = ["Certificate"]
+++
大家安，大概在四月中的時候拿到eJPT，在考之前就有發現臺灣沒有任何一篇有關eJPT的心得，想說分享一下順便紀錄一下心得。

<!-- more -->
eJPT 全名是 **eLearnSecurity Junior Penetration Tester**，定位是**入門**的證照，在國外這幾年越來越多人拿來和**CEH**、**CompTIA Security+**...等類似的證照拿來做比較，不過eJPT不同的地方就在於他的考試方法是**實務**的方法，等等下面會介紹是何種**實務**，若想看我對這些證照的想法可以去看我的另一篇文 [對於各種資安入門證照的看法](https://jimmysured.github.io/2020/08/07/%E5%B0%8D%E6%96%BC%E5%90%84%E7%A8%AE%E8%B3%87%E5%AE%89%E5%85%A5%E9%96%80%E8%AD%89%E7%85%A7%E7%9A%84%E7%9C%8B%E6%B3%95/)

# Introduction
[eLearnSecurity對eJPT的介紹](https://www.elearnsecurity.com/certification/ejpt/)
當初會看到這張證照是因為想考CEH（因為快要畢業加上不確定考不考得上研究所，所以想先拿證照至少可以拿來~~秀一下~~當工作面試加分的東西），然後去爬reddit之後發現有人問到CEH下面每個人幾乎都在推這張，還有一些youtuber也有對這張證照的review，加上價格合理（課程 + 5.5小時的影片 + 16個labs + 3個Black-box的Pentest + 可以重考一次價格500鎂），加上又是給剛入門的考，所以就打算先以這張證照當作CEH的替代品。

然後簡單講一下考試的方法，就是按下確認鍵後考方會寄一封mail給你，裡面有一份pdf，裡面是講一些規定還有推薦的工具，然後還有一段ip位址，然後就沒了，給你3天去compromise這台機器。

這種**實務**的考法就很像國外常常有人說的**Get Your Hands Dirty**一樣，因為選擇題常常會讓人還沒融會貫通前就先把答案背起來了，常常背完就忘了，然而像eJPT這種考法由於沒有任何的記憶點，只能靠自己真的理解這個工具或方法後，然後實際去操作，才能通過測驗，取得證照，這也是為何許多人越來越推行這張證照的緣故。

# 課程心得 & 考試心得
## PTS (Penetration Testing Student)
PTS是eLearnSecurity在你買考試的voucher時一起給的，讀熟PTS一定一定會拿到證照，因為課程就是設計來讓你可以獲得通過PTS所需的知識。
然後Labs會有解答，所以也不用太害怕會做不出來，但是有看slide跟影片，應該就都可以做的出來，16個labs我大概有3個左右是看了解答才知道怎麼做的，另外還有3個Black-box的Pentest，難度跟Labs有差，做不出來也不用太灰心。
官網上對PTS的介紹：
> * For absolute beginners in IT Security
> * Minimal pre-requisites
> * Learn about: Routing, Forwarding, and TCP/IP; Information Gathering; Scanning; Vulnerability Assessments; Buffer Overflows; XSS; SQL Injection; System and Network Attacks; and Basics of Web App Pentesting
> * Learn how to: Analyze Traffic with Wireshark, Exploit Vulnerable Hosts, Move Laterally, Manipulate Traffic, Crack Passwords, and Exfiltrate Data
> * Develop Pentesting tools in C and Python
> * Learn how to use tools like Nmap, Nessus, Hydra, Metasploit, and Burp Suite
> * Preparation for the Penetration Testing Professional (PTP) course
> * Obtaining the eJPT certification qualifies you for 40 CPE

## 考試心得
用心讀大概花一個多月或20幾天就可以熟讀內容加上Labs大概做兩次，
難度大概介於Labs跟Black-box的Pentest，實際上的考法和Black-box一樣，給你一段IP位址外什麼都不會給，考題有20題選擇題，只能錯5題，我自己是19/20，選擇題的題目大概會是（不能講實際的題目出來，官網有明確說不能spoiler）
* 在某某某文件中有什麼
* 某人的密碼是什麼

當然題目是英文的，我只4懶ㄉ打英文才打中文ㄉ，
另外別肖想透過題目來取得一點在Pentest的想法（跟CEH Practical不一樣），真的要實際把機器compromise後才知道題目在問甚麼以及答案到底是什麼，中間的過程真的得透過自己的想法一步一步來，然後攻下機器。
然後有整整3天的時間可以讓你完成考試，所以真的真的真的完全不用擔心會做不完，但是如果你想知道大概多久做完才算正常，大概10小時以內，我自己是7小時，但考慮我讀了快兩個月，7小時真的算很久了，然後去reddit爬文好像都大概5、6小時就結束了，不過也有看到做12小時的，只能說讀的越熟一定會解的更快。
然後考試不會像OSCP需要架設攝影機或者限制不能使用自動化工具，考試的過程中你可以想做什麼就做甚麼，唯一不能做的事情就是去PTS的論壇上面問有關考試題目的問題。
我在考試時也是非常緊張，因為想到有可能會在過程中遇到解不出來的問題，或者遇到什麼奇怪的事情，因為考前一天想說要考試了，更新一下kali，也沒snapshot，更新完之後一大堆問題，只好回到超級久以前的snapshot，
不過雖然eJPT可以隨時考，考試是按下一個按鈕之後就會開始，不像OSCP要先排時間或是CEH要預約之類的，但我想說我都拖兩個月了，再不考可能就會變成拖三個月，所以還是硬著頭皮上了，但實際上也沒那麼困難，雖然中間還是有卡一下，可是想通之後就會覺得那個是超級簡單的問題。

# 考後心得
官方認證在考取證照後所具備的知識和技能：
> * Good knowledge of TCP/IP
> * Good knowledge of IP routing
> * Good knowledge of LAN protocols and devices
> * Good knowledge of HTTP and web techologies
> * Essential penetration testing processes and methodologies
> * Basic Vulnerability Assessment of Networks
> * Basic Vulnerability Assessment of Web Applications
> * Exploitation with Metasploit
> * Simple Web application Manual exploitation
> * Basic Information Gathering and Reconnaissance
> * Simple Scanning and Profiling the target

整體來說，以剛入門的人來說，這張真的算是偏簡單的證照，真的很推薦可以考看看，但如果有經驗的，除非是像我一樣快畢業而且身上沒有任何作品，CTF也打的不好，也沒打過HTB的任何一台機器，要考OSCP也考不過的人，我才會推薦考這張，不然時間金錢都足夠的狀況下，真的比較推薦OSCP，畢竟臺灣我覺得應該很少人知道這張，實際上要找工作我也不太確定助益大不大，因為我也還沒開始找工作，但如果是不太知道該怎麼入門的，有錢的話考這張就對了。

謝謝大家看完這篇心得文。這篇應該是臺灣第一篇eJPT的心得文，ㄏ。
如果有任何問題歡迎私訊facebook問我哦。
