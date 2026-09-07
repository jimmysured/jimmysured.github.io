+++
title = "Daniel Duggan - Designing a C2 Framework 簡介"
date = 2022-09-29
path = "2022/09/29/Daniel-Duggan-Designing-a-C2-Framework-簡單介紹"
description = "A summary of Rasta Mouse's DEF CON talk on designing a C2 framework: the C2 model, language choice, and implant design patterns."

[extra]
lang = "zh"

[taxonomies]
tags = ["c2", "red team", "talk"]
categories = ["Technique"]
+++
這篇文章是簡單統整 [Rasta Mouse](https://twitter.com/_RastaMouse), CRTO 的作者, 在去年的 DEFCON 分享如何構建一個 C2 框架的議程, 並且有基於此議程, 實際教導如何使用 C# 來構建一個 C2 框架的[課程](https://training.zeropointsecurity.co.uk/courses/c2-development-in-csharp)

<!-- more -->
# Intro
- 可以透過 [C2 Matrix](https://www.thec2matrix.com/) 來尋找符合自己要求的 C2

## C2 Model
- **Operators <-> Control Server (aka "Team Sever") <-> Target (with implant)**
	- **Operators**:
		- 會對 Target 發送 implant (可以想像成 payload, RAT), 並需要持續的對 implant 進行控制
		- 會有一個獨立的 client, 讓 Operator 可以透過類似 admin interface 和 Control Server 互動
		- 會透過給 Control Server 任務, 藉此來給 implant 指令 
	- **Target (with implant)**:
		- Target 上的 implant 會透過 HTTP 或 DNS 之類的協定和 Control Server 通訊, 藉此來和 Operators 進行互動 
		- Implant 接收到 Operators, 也就是 Control Server 的指令後, 需要返回執行指令的結果給 Control Server 讓 Operators 能夠觀看結果 

- 這邊如果想要更簡化, 可以**直接地把 Control Server 當作 Operator**
- 那中間會有 Control Server 的原因是因為, 通常使用到 C2 Framework 時, 除非你是 one man army, 不然通常都是**大於兩個人**在使用 C2 Framework, 如果沒有一個 Control Server 在中間提供一個**統一且同步**的媒介, 可能會**讓行動變得很複雜**
	- 舉例來說, 有 A, B 兩個人要對一個 AD 進行滲透測試 or 紅隊演練, 如果沒有 Control Server, 會有以下的問題
		1. **行動很難統一和同步**
			- B 可能沒辦法和 A 丟到 Target C 的 implant 進行互動, 那可能 B 還要再丟另一個 implant 到 Target C 或是另外想一個方法和 A 丟進去的 implant 進行互動
			- 如果有 Control Server, 可以提供一個統一的媒介, 讓 A, B 可以透過 Control Server 生成一個 implant 並丟到 Target C 上, 接下來 A, B 只要和 Control Server 進行通訊, 就可以和 Target C 進行互動
		2. **行動很難追蹤和還原**
			- 如果 A, B 都是透過自己的電腦來進行行動的話, 若後續客戶需要對做過的攻擊進行查證, 可能會讓查證的過程過的很複雜甚至無法進行查證
			- 如果有 Control Server 的話, A, B 對 implant 做的任何互動以及行為都會被 Control Server 記錄下來, 可以直接透過 log 來進行查證

- 如果以上很難想像, 可以考一樣也是這位作者出的證照, [CRTO](https://training.zeropointsecurity.co.uk/courses/red-team-ops), 因為 CRTO 所帶到的內容會讓你對 Red Team, C2 有基礎的瞭解, 我也有寫一篇[心得文](https://jimmysured.github.io/2022/09/25/CRTO_Certificate_Review/)可以參考

## C2 != Framework
- C2 不等於 C2 Framework

- C2 Framework 提供以下功能
	- **Inversion of control**
		- 降低 Operators 和 Implant 之間的**耦合度**
	- **Default behaviours**
		- 提供預設的行為給 Operators, 像是上面舉例的透過 HTTP 或 DNS 進行通訊, 並提供使用者修改這些 Default behaviours 的能力 (e.g., Cobalt Strike 中的 Malleable C2 profile) 
	- **Extensibility (without modifying the core)**
		- 讓使用者可以在不修改核心程式碼的情況下, 新增原先沒有的功能, 行為
	- **Reusable components**
		- 應該不用多做解釋 XD

	### Example (Metasploit)
	- Metasploit 為一個較為成熟的框架, 任何人都可以自己寫一個 module 到 Metasploit, 因此作者在這邊拿 Metasploit 中的 [psexec.rb](https://github.com/rapid7/metasploit-framework/blob/master/modules/exploits/windows/smb/psexec.rb) 做介紹
		1. **Define module info**
			- 在 module 中提供漏洞名稱, 作者名稱, 對該 module 的描述, 參考資料等資訊, 方便使用者, 也就是 Operators 進行查找
			- ![](/img/c2_1.png)
		2. **Register options**
			- 一些對 module 來說很重要的選項, 像是 service 名稱, PowerShell 的路徑等
			- ![](/img/c2_2.png)

		3. **Includes & Helpers**
			- 因為這個檔案有 include smb, 所以可以不用在你的 module 中自己寫一個 smb library, 以此類推
			- ![](/img/c2_3.png)
			- 如果沒有提供檔案名稱, module 會幫助你將傳過去的檔案以英文亂碼命名, 那 `rand_text_alpha()` 也是 framework 定義好的 module, 所以就不用特意去思考說還要在寫一個產生英文亂碼的 module, 因為 framework 都幫你寫好了
			- ![](/img/c2_4.png)

# Which Language
## Server
- **Python**
	- Flask, Django
	  
- **ASP.NET Core (C#)**
	- Blazor, Web API, gRPC
	  
- Others
	- Vue.js, React, Angular

## Implant
- **OS specific**
	- C# (.NET Framework), Swift

- **Cross-compilation**
	- Nim, Rust, Go

- **Cross-platform**
	- .NET, .NET Core, Python

# Design Patterns
## Command Design Pattern
- ![](/img/c2_5.png)
	1. 可以將 Operator 算是 client, 透過 **Task (Guid implant)** 函式, 將 Task, Command, Argument 傳送到 Server, 也就是 director
	2. 接著 Server 透過 **SendTask()** 函式, 將 Task, TaskGuid, Command, Argument 傳送到 Task, 也就是 command
	3. 接著 Task 透過 **ExecuteTask()** 函式, 在 implant, 也就是 receiver 上執行 task

- 在上圖會注意到 **TaskGuid** 被特別框起來, 被框起來的原因是因為, server 會做這件事, 但不是在這個 model 中, 有 TaskGuid 的原因是因為要追蹤 Task **執行的進度**或是**結果**, 當 implant, 也就是 receiver 執行指令後, 會回傳訊息, 這時候 Server 可以直接透過 Guid 去做查詢

	### Contracts
	- **不要在不同的 element 中使用同一個 model**
	- Operator <-> Server
	- Server <-> Implant
	- Server <-> Storage

## Template Method Pattern
- ![](/img/c2_6.png)
	- 當設計完 Abstract Class, Listenr, 之後, 後續如果自己或是其他人想寫客製化 module, 可以不用思考其背後運作原理, 只要呼叫 Abstract Class 裡面的 method 即可
	- 詳細例子可以參考議程影片的這個部分, 作者舉的例子很清楚

# Base Primitives > Command Proliferation
- **Base Primitives**
	- Shell/PowerShell Execution
	- (.NET) Reflection
	- Reflective DLLs
	- Manuel Mapping
	- Sockets

- **Commands**
	- ls, cd, pwd, whoami, ...
	- Seatbelt
	- Rubeus
	- Mimikatz

- 作者認為, **base primitves 比起 command 較佳**. 雖然在 C2 Framework 中能直接使用 command 很方便, 但當 Operator 想使用客製化的工具或是攻擊手法時, base primitves 是較佳的選擇.

- 作者在這邊提出 command 的幾個缺點:
	- 非常沒有彈性
	- 很難進行維護和擴充
	- 很難 handle exception
	- 程式碼會重複
	- 效能不太高
	- 所有東西都是字串
	- 很醜

- 比較好的方式, 是將這些 command **抽象化** (Abstract)

# 結語
- 這邊很推薦想自己寫一個 C2 Framework 或是想了解 C2 背後運作原理的人去看這個議程, 因為我這篇文章只是簡單概述, 影片中有講到其他比較深入的內容, 像是設計 C2 時該注意的事, 設計 C2 時的心態, 對 Design Pattern 更深入地解說等內容
- 那如果對設計一個 C2 Framework 很感興趣, 也可以去參考作者的 **[C2 Development in C#](https://training.zeropointsecurity.co.uk/courses/c2-development-in-csharp)** 這門課, 那作者有說近期收到蠻多 feedback, 要對課程做一個大更新, 有興趣的可以先買起來放著, 等更新再看

# Reference
- <https://www.youtube.com/watch?v=oasBguDw_Ho>