### TKeyboard for Mac and iOS

在咖啡馆耗费了数个周末之后，终于将这个灵光一闪的点子变成了一个实实在在可以运行的 app。同时意味着年初制定的第一个小目标达成，完成了 2017年的第一个独立 app。

在app上架的同时，我决定将代码全部开源，除了兑现去年年底的承诺之外，我相信代码本身的价值，要高于 App 的功能，开源能带来更多知识的碰撞和增长。去年开源给我带来了不少乐趣，希望今年能有更好的成绩。整个项目涉及到一些比较实用的技术点，或能惠之于人。

#### 应用场景

这款应用名为：TKeyboard。有一个 Mac 端和一个 iOS 端 App。简单来说，可以通过蓝牙，使用 Mac 的键盘输入内容到 iPhone 设备中。

主要是为了解决 iPhone 设备输入不方便的问题，有 Mac 在身边的时候会比较方便，一时脑洞的小应用。

#### 涉及知识点

这两个 App 解决的用户场景比较完整，代码方面涉及到一些较为实用的技术点：

**Mac 端开发**，从 iOS 端切入 Mac 端开发其实难度比大部分人预想的都要小，主要是 UI Framework 需要做些学习，用 xib 配合 autolayout 其实很方便，就是做动画会稍微麻烦一些。

**iOS 端的话**，主要是各种 Extension 的开发学习，现阶段实现的是 Keyboard Extension，后期这个项目计划实现更多的 Extension 功能，最终的目标是成为一个 Mac 端和 iOS 端的多功能同步应用。Extension 开发的重要性，我曾经专门写文介绍过，不再赘述。

**另外是蓝牙通讯这一块**，iOS 端和 Mac 端共享一套代码。蓝牙这块网络上技术文章比较少，完整的开源项目几乎找不到。我在结合官方 demo 和自己踩坑的基础之上，基本实现了一套完整的蓝牙通讯功能。

**最后还有一个简单的网络协议设计**，用于 iOS 和 Mac 端做通讯之用，理论上使用 protobuf 更合理，但这是个人项目，处于写代码的乐趣，就自己动手 DIY 了一个，感兴趣的同学也可以自己设计。

全部的代码大约耗时数个周末。其实项目去年底就已经启动了，中间因为各种琐碎事情耽搁了，2017 开年战胜拖延症，终于完成了第一版本代码，算是给去年底做热血规划的自己一个交代。

#### 开源计划

TKeyboard 包含 Mac 端 和 iOS 端两个项目，涵盖一些实用知识，决定开源也算是对 iOS 技术社区做一些微薄的贡献。其中代码可以随意免费使用，但绝不容忍换个皮肤重新上架 App Store 的低素质行为。

#### 后续打算

TKeyboard 的最终目标是一个 Mac 与 iOS 的同步应用，这是一个庞大的工程量，不知道最后会完成为什么样的形态，且做且珍惜。欢迎大家提意见修改。

iPhone 版目前售价 $3，Mac 版免费。因为代码开源，实际和完全免费没差别。如果觉得代码或者 App 本身对你有帮助，可以考虑去 App Store 下载，赞助 Peak 君一杯咖啡。

iOS 版 TKeyboard 下载地址：[https://itunes.apple.com/cn/app/tkeyboard/id1168383839?l=zh&ls=1&mt=8](https://itunes.apple.com/cn/app/tkeyboard/id1168383839?l=zh&ls=1&mt=8)

Mac 版 TKeyboard 下载地址：[https://itunes.apple.com/cn/app/tkeyboard/id1168383849?l=zh&ls=1&mt=12](https://itunes.apple.com/cn/app/tkeyboard/id1168383849?l=zh&ls=1&mt=12)

我的个人公众号：MrPeak杂货铺

<img src="http://mrpeak.cn/images/qrwide.png" width="375">



