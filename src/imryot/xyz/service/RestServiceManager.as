package imryot.xyz.service
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	import imryot.xyz.service.beans.RestServiceBean;
	
	public class RestServiceManager extends EventDispatcher
	{
		public function RestServiceManager(target:IEventDispatcher=null)
		{
			super(target);
			if(_instance != null)
			{
				throw new Error("不能通过new创建该对象");
			}
		}
		
		//version
		public var version:String;
		//debug mode
		public var debug:Boolean;
		//api list
		private var _apis:Array = [];
		
		/**
		 *获取接口类 
		 * @param serviceName 服务类名称(name)
		 */
		public function getServiceBean(serviceName:String):RestServiceBean
		{
			for(var i:int = 0;i<_apis.length;i++)
			{
				var bean:RestServiceBean = _apis[i] as RestServiceBean;
				if(bean && bean.name == serviceName)
				{
					return bean;
				}
			}
			return null;
		}
		
		private static var _instance:RestServiceManager;
		
		public static function get instance():RestServiceManager
		{
			if(_instance == null)
			{
				_instance = new RestServiceManager();
			}
			return _instance;
		}
		/**
		 *初始化服务接口 
		 * @param url 配置文件路径
		 * @param callBack 回调函数
		 * @param errorHandler 错误请求处理
		 */
		public function init(url:String,callBack:Function,errorHandler:Function = null):void
		{
			_apis = [];
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			//load complete
			urlLoader.addEventListener(Event.COMPLETE,function(event:Event):void{
				try
				{
					var po:Object = JSON.parse(urlLoader.data.toString());
					version = po.version;
					debug = po.debug.toString() == 'true'?true:false;
					var apisList:Array = po.apis as Array;
					for each(var obj:Object in apisList)
					{
						var Clazz:Object = getDefinitionByName(obj.classPath);
						var serviceBean:RestServiceBean = new Clazz();
						serviceBean.baseURI = po.baseURI;
						serviceBean.debug = debug;
						serviceBean.name = obj.name;
						serviceBean.endpoint = obj.endpoint;
						_apis.push(serviceBean);
					}
				}catch(error:Error)
				{
					trace(error.errorID,error.message.toString());
				}
				callBack();
			},false,0,true);
			//load package.json progress
			urlLoader.addEventListener(ProgressEvent.PROGRESS,function(event:ProgressEvent):void{
				trace("loading package.json ...." + ((event.bytesLoaded / event.bytesTotal) * 100).toFixed());
			},false,0,true);
			//ioerror
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{
				if(errorHandler != null) errorHandler();
				trace(event.errorID,event.text);
			},false,0,true);
			urlLoader.load(new URLRequest(url));
		}
	}
}