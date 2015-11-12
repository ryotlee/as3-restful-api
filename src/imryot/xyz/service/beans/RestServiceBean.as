package imryot.xyz.service.beans
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class RestServiceBean implements IRestServiceBean
	{
		//
		public var endpoint:String;
		//统一资源请求地址
		public var baseURI:String;
		//是否调试模式
		public var debug:Boolean;
		//类名
		public var name:String;
		
		protected var _httpService:HTTPService;
		
		public function get url():String
		{
			return this.baseURI + "/" + this.endpoint;	
		}
		
		public function RestServiceBean()
		{
			
		}
		
		/**
		 * 发送请求
		 * @param reqURL 请求路径
		 * @param params 请求参数
		 * @param responder 异步调用服务
		 * @param method 请求的类型，默认为GET
		 * @param resultFormat 返回结果类型,默认为text
		 */
		protected function sendRequest(reqURL:String,params:Object,responder:IResponder = null,method:String = "GET",resultFormat:String = 'text'):void
		{
			_httpService = new HTTPService();
			_httpService.url = reqURL;
			_httpService.method = method;
			_httpService.resultFormat = resultFormat;
			//			_httpService.contentType = "application/x-www-form-urlencoded; charset=UTF-8";
			var token:AsyncToken = _httpService.send(params);
			token.addResponder(responder);
		}
	}
}