+++
title = "Diamond Ticket & Sapphire Ticket"
date = 2022-09-28
path = "2022/09/28/Diamond-Ticket-Sapphire-Ticket"
description = "Diamond Ticket 與 Sapphire Ticket 介紹, 以及跟 Golden / Silver Ticket 的差異和偵測上的難點。"

[taxonomies]
tags = ["active directory", "red team", "pentest"]
categories = ["Technique"]
+++

大家安安, 這篇文章簡單介紹近期比較新的 AD 攻擊手法, Diamond Ticket 和 Sapphire Ticket 

<!-- more -->

- 在開始介紹 Diamond & Sapphire Ticket 之前, 要先介紹 Silver & Golden Ticket, 因為在理解 Diamond & Sapphire Ticket 之前需要先理解這兩個 Ticket 的原理和限制

# Silver & Golden Ticket
## 簡介
- 這邊不詳細描述 Silver 和 Golden Ticket 的原理
- 簡單來說
	- **Silver Ticket** 是偽造的 **TGS**, 如果拿到 **machine account key**, 可以偽造該 machine 上任何使用者到該 machine service 的 ticket, 後續可以做橫向移動或是提權
	- **Golden Ticket** 是偽造的 **TGT**, 需要 **krbtgt key**, 但通常拿到 krbtgt key 就已經**打下整個 domain 了**, 所以通常拿來進行 **persistence**, 或是在 **Parent-child Trust** 的情境下拿來進行橫向移動
  
## 限制 & 可能風險
- Silver Ticket 雖然使用條件較為寬鬆, 但其**限制**為有時只限制於**任何使用者**, 但**單一 service** 或是**任何 service**, 但**單一 machine**
- Golden Ticket 雖然能以任何使用者的身分訪問 domain 上任何的 service 但其**限制**為需要拿到 **krbtgt key**

- 因為 Silver 和 Golden Ticket 都是透過**偽造 ticket** 達到的, 因此在 Kerberos 驗證流程中會**沒有**相對應的 **Service Ticket requests (KRB_TGS_REQ)** 或是 **TGT request (KRB_AS_REQ)**, 因此**常被檢測到** 

# Diamond Ticket
## 簡介 & 好處
- Diamond Ticket 是近**兩個月**才跑出來的攻擊手法, 其**結果和 Golden Ticket 相同**, 如果成功使用 Diamond Ticket, 就能以任何使用者的身分訪問 domain 上任何的 service
- 但比起 Golden Ticket, Diamond Ticket **更為隱密**, 即 **OPSEC 較佳**, **不容易被偵測到**

- OPSEC 較佳的原因是因為
	- **Golden Ticket** 是透過偽造 TGT 達成的, 因此**不會**有與其相對應的 **TGT request (KRB_AS_REQ)**, 那也因為 TGT 是偽造的, 所以其中的 **PAC** 也是偽造的, 有時候會因為**和真實的 PAC 不像**, 讓**被偵測的機率提高**
	- 而 **Diamond Ticket** 是**直接請求一個 TGT**, 並**對 PAC 解密**, **修改 PAC**, 接著重新計算 singnatures, 並再次加密這個 TGT
	- 那也因為是直接請求一個 TGT, 所以在 Kerberos 驗證流程中就會**有**相對應的 **TGT request (KRB_AS_REQ)**, 從而降低被偵測到的機率

## 攻擊指令
- 那因為需要對 TGT 進行解密, 所以也需要 **krbtgt key**, 並且強制需求要是 **AES256 key**

- Command:
```powershell
	Rubeus.exe diamond /domain:DOMAIN /user:USER /password:PASSWORD /dc:DOMAIN_CONTROLLER /enctype:AES256 /krbkey:HASH /ticketuser:USERNAME /ticketuserid:USER_ID /groups:GROUP_IDS  
```

- 實際運行攻擊指令後會發現以下訊息
```
	[*] Action: Diamond Ticket
	
	[*] No target SPN specified, attempting to build 'cifs/dc.domain.com'
	[*] Initializing Kerberos GSS-API w/ fake delegation for target 'cifs/dc-2.dev.cyberbotic.io'
	[+] Kerberos GSS-API initialization success!
	[+] Delegation requset success! AP-REQ delegation ticket is now in GSS-API output.
	[*] Found the AP-REQ delegation ticket in the GSS-API output.
	[*] Authenticator etype: aes256_cts_hmac_sha1
	[*] Extracted the service ticket session key from the ticket cache: +mzV4aOvQx3/dpZGBaVEhccq1t+jhKi8oeCYXkjHXw4=
	[+] Successfully decrypted the authenticator
	[*] base64(ticket.kirbi):
	
	      doIFgz [...snip...] MuSU8=
	
	[*] Decrypting TGT          # here
	[*] Retreiving PAC          # here
	[*] Modifying PAC           # here
	[*] Signing PAC             # here
	[*] Encrypting Modified TGT # here
	
	[*] base64(ticket.kirbi):
	
	doIFYj [...snip...] MuSU8=
```
- 在 `doIFgz [...snip...] MuSU8=` 的下一段, 明顯可以看出 Diamond Ticket 的確是透過修該合法的 TGT 當中的 PAC 來達到這個攻擊手法
- 後續只要再將這個 ticke pass 到環境中就可以使用了

# Sapphire Ticket
## 簡介 & 好處
- 而 Sapphire Ticket 是在我這篇文章 PO 出來的**前幾天**才出現的攻擊手法, 是我在滑 Twitter 時看到[這篇文章](https://twitter.com/_nwodtuhs/status/1574163065142218755)才發現有這個攻擊手法的
- **Sapphire Ticket** 和 **Diamond Ticket** 的**差別只在於修改 TGT 中 PAC 的方式**
	- **Diamond Ticket** 是透過對 TGT 中 PAC **新增特權群組 (privileged groups)**, 或是直接**偽造一個特權群組並寫入 TGT 的 PAC 中**
		- 那這個行為會讓檢測軟體能透過**檢查** **TGT** 中 **PAC** 的**群組**去和 Active Directory 中這個群組實際有沒有包含這個 user 做關聯
		- 舉例來說, 如果要讓沒有特殊權限的 **userA** 能夠訪問 doamin 上的各個 service, 就可以使用 Diamond Ticket, 那在過程中會修改 TGT 中的 PAC, 實際觀看這個 PAC 的值會發現, 使用者是 **userA**, 群組是一個**特權群組**, 這時候檢測軟體去 **Active Directory 查看 userA 是不是這個特權群組的成員**, 就會發現異常狀況
	- 那 **Sapphire Ticket** 就是改良 Diamond Ticket 上面提到的可能的風險, 透過 **S4U2self + u2u** 來**取得高權限使用者的 PAC**, 並將 **TGT** 的 **PAC 取代成高權限使用者的 PAC**
		- 這樣檢測軟體在對 PAC 做檢測會因為 PAC 中特權群組裡的確有這個高權限使用者, 所以就認定該 PAC 是合法的

- 因 **S4U2self + u2u** 其背後原理有點複雜, 故不多在這贅述, 以後如果有機會再和大家分享其背後的原理

## 攻擊指令
- 由於太新, 因此在 Windows 上還沒有相關的工具能實作此攻擊手法, 目前只有 UNIX-based 的工具 **Impackt** 的 **ticker** 能實作

- Command
```bash
	ticketer.py -request -impersonate 'domainadmin' -domain 'DOMAIN.FQDN' -user 'domain_user' -password 'password' -aesKey 'krbtgt/service AES key' -domain-sid 'S-1-5-21-...' 'baduser'
```

# Reference
- <https://www.thehacker.recipes/ad/movement/kerberos/forged-tickets/silver>
- <https://www.thehacker.recipes/ad/movement/kerberos/forged-tickets/golden>
- <https://www.thehacker.recipes/ad/movement/kerberos/forged-tickets/diamond>
- <https://www.thehacker.recipes/ad/movement/kerberos/forged-tickets/sapphire>