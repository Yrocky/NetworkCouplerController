
## 将控制器和网络请求进行耦合的Adapter

做这样的一个项目的目的是方便开发中的网络请求发起。使用一个`中间件`将`控制器`与`网络请求`进行结合起来，使网络请求的发起以及数据回调、错误抛出等操作在这个`中间件`的转换下在控制器中进行对应的动作。

项目结构：

```
NetworkingViewController
|
|---ViewController
|	|
|	|---HLLBaseViewController(能够完成基础请求的控制器基类)
|	|
|	|---HLLListViewController(能够完成具有分页功能的控制器基类)
|
|---View
|	|
|	|---HLLNoDataView(当没有数据的时候的提示视图)
|	|
|	|---PullToRefreshView(自定义的下拉刷新以及上提加载视图)
|	
|---Model
|	|
|	|---HLLBaseRequestAdapter(能够发送基础网络请求的基类)
|	|
|	|---HLLBasePagingAdapter(能够发送分页请求的基类)
|	|
|	|---HLLBaseFileHandleAdapter(能够完成上传下载文件请求的基类)
|
|---HLLNetworking
|	|
|	|---网络请求部分，在AFNetworking的基础上进行基础网络请求以及下载和上传功能的封装
|
|---Other
|	|
|	|---一些辅助的类
|
|
```

### 控制器部分

一般而言，一个的网络请求无非常规的`GET`、`POST`，特殊需求的如`Upload`、`Download`等操作，针对于常规操作里面还有分页的请求，如有其它再做补充。

对于控制器这一部分的目的就是这些网络请求的发起应该应该很简单，不要写过多的block回调或者代理回调，也不要和网络请求有过多的关联，具体网络请求的发起应该交给`Adapter`部分，数据的解析交给`Adapter`，`控制器这边仅需要通过Adapter发起相应的网络请求，然后再通过它拿到对应的数据即可`。对于具有分页的网络请求中的页数以及每页大小这些操作，也都交给`Adapter`，针对于下载上传这些需要实时获取进度的操作都使用`Adapter`的回调进行捕获。

除了必须的网络请求这一块，对于`HUD`以及`下拉刷新上提加载`等控件的集成也是一个需要考虑进去的问题，而且对于请求成功但是`没有数据`的情况，需要友好的进行一下提示。除了这些，针对于控件部分还要有易于替换的功能。


### 网络请求部分

在AFNetworking 3.0的基础上进行封装的网络请求，能够完成get、post、上传文件、下载文件这些网络请求，并且提供有缓存机制、失败重连机制。

具体的缓存机制如下：

* 具体缓存机制见方法`-cacheResponseObject: request: parameters:`

```
             __需要缓存__-->`缓存响应结果`
    请求成功--|                           -->`返回成功的请求结果`
             __不需要缓存__
```

* 获取缓存数据的方法`-getCacheResponseWithRequest:parameters:`

```
             __缓存中有对应的数据__-->`返回相应结果并且抛出异常`
    请求失败--|
             __没有缓存数据__-->`抛出异常`
```

由于自动重试方法现在有一些问题，没有添加进去，待后续解决。

### Adapter部分

对于请求这一部分，使用对象进行一一映射会使由于字符串的容错性很差引起的bug减少，稍微写错一个字就会导致请求失败。另一方面，对象化难免会增加代码量，并且不是很直观。这里目前是随便找的接口进行测试，因此没有进行对象化。

而如果将响应的数据进行一一映射对象化，虽说现在有很好的这样的项目可以做到无差别的映射，但是，从网络请求获取到的数据经过映射之后再在日志台打印出来的时候那个情况你不会想看到的,

```
(lldb) po comment
<MyCommentProtocal: 0x170aa2a00>

(lldb) what ????
```

一来说不是很友好，另外如果后台那边有数据字段的修改，那就需要进行大片大片的改动了。因此不应该将响应数据进行对象化的操作，而应该使响应数据原始输出，对于有需求的字段可以进行单独的操作。

```
(lldb) po commentData
{
    ReplyComment = "";
    ReplyNickname = "";
    ...
    "to_commentid" = 0;
    "to_userid" = 0;
}

(lldb) nice ！！！！
```

Adapter与网络部分的连接使用的是代理回调，在成功之后交给子类进行数据的解析处理，并再次以代理回调的方式传给控制器，因此子类中有一些必需要实现的方法

`-start`：用于发起一个请求，重写该方法的时候确定网络请求方法是`get`还是`post`，并且处理参数和url。

对于`-parseResponse:withUserInfo:`方法，子类可以不进行重写实现，该方法是对请求成功之后的响应数据进行解析处理的，子类即使不重写也可以通过`response`属性获取到原始的响应数据。

### 如何使用

`第一步`，创建控制器使其有如此继承`@interface TestOneRequestViewController : HLLBaseViewController`，并且重写父类的这两个方法

```
- (HLLBaseRequestAdapter *)generateRequest{

    return [[TestAPI alloc] initWithNetworkManager:self.networkManager];
}

- (void)refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{

    self.logView.text = [NSString stringWithFormat:@"<%@>请求成功\n\n%@",userInfo,request.response];
}
```

`第二步`，创建一个发送请求的对象`@interface TestAPI : HLLBaseRequestAdapter`
，然后重写父类的以下方法，第三个可选重写

```
- (NSString *)userInfo{

    return @"test-api";
}

- (void)start{

    [self get:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil userInfo:self.userInfo];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{

    ...
}
```

`第三步`，在控制器中发起网络请求

```
- (void)startTestRequest:(UIButton *)sender{

    [self.baseRequest refresh];
}
```

具体其他情况请看各个测试类中的方法

### 测试情况

* 单个请求测试，ok
* 多个请求测试，ok
* `多个请求同时发送，no`
* UITableView下的分页请求测试，ok
* UICollectionView下的分页请求测试，ok
* UITableView下的自定义控件分页请求测试，ok
* 下载数据测试，ok
* 上传文件测试，ok


### BUG

* 在没有网络但是有缓存的时候进行列表请求，使用自定义的下拉刷新以及上提加载更多控件，前两页有缓存，第三页没有缓存，当加载第三页失败之后会闪现到顶部
* 网络请求的打印不是很完整，打印内容仅仅是一部分(在Xcode7.0版本可以完全打印，但是在Xcode8.0版本就不能完全打印)
* 。。。

### Todo

 * backgroundState 下的下载以及上传功能
 * 网络状态的添加
 * 增加UISearchController部分
 * 。。。



### Thx

   * [AFNetworking](https://github.com/AFNetworking/AFNetworking)
   * [YTKNetwork](https://github.com/yuantiku/YTKNetwork)
   * [AFNetworking-AutoRetry](https://github.com/shaioz/AFNetworking-AutoRetry)
   * [AppDevKit](https://github.com/yahoo/AppDevKit)



