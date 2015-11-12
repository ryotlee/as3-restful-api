package com.test
{
	import imryot.xyz.service.beans.RestServiceBean;
	
	import mx.rpc.IResponder;
	
	public class TestService extends RestServiceBean
	{
		public function TestService()
		{
			
		}
		
		public function sayHello(userName:String,responder:IResponder = null):void
		{
			this.sendRequest(url,{
				userName:userName
			},responder);	
		}
	}
}