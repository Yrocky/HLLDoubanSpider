# 使用Object-C爬取豆瓣电影数据


这个工程是对豆瓣电影的PC端网页界面进行电影数据爬取，然后通过App进行展示。

* 首先模拟浏览器进行进行网络加载，获得到相应网页的数据信息

* 然后通过第三方XML解析框架结合XPath进行相应数据的获取

* 最后将爬取到的信息通过表视图进行展示


第三方库
---

* XML解析：[Ono](https://github.com/mattt/Ono)

* 刷新控件：[MJRefresh](https://github.com/CoderMJLee/MJRefresh)

* 图片加载：[SDWebImage](https://github.com/rs/SDWebImage)