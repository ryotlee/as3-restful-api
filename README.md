### as3 rest http service library
为了方便调用服务端接口，将httpservice进行封装。

#### 应用启动时初始化服务

``` java
//init service
/**
 * 初始化服务
 */
RestServiceManager.instance.init("package.json",function():void{

},function():void{

});
```

#### 使用
> com.test.TestService 测试用例

```java 
var testService:TestService = RestServiceManager.instance.getServiceBean("TestService") as TestService;
//call service
testService.sayHello("ryot",new mx.rpc.Responder(function(event:ResultEvent):void{
         trace(event.result):
    },function(event:FaultEvent):void{
         trace(event.message.toString()):    
}));
```
