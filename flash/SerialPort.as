// AS3 version of the SerialPort class
// originally written by Massimo Banzi @ Tinker.it based on
// code by Beltran Berrocal @ Progetto2501.it
//
// Ported to AS3 by Tink (Stephen Downs)
//
// Version 0.3 11.01.2007
//



package
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	public class SerialPort extends EventDispatcher
	{
		
		private var _host		: String;
		private var _socket		: Socket;
		
		//Character that delineates the end of a message received
		//from the Arduino
		private static const EOL_DELIMITER:String = "\n";
		
		public function SerialPort( host:String = null, port:int = 0 )
		{
			super();
			
			_socket = new Socket();
			_socket.addEventListener( Event.CLOSE, onClose );
			_socket.addEventListener( Event.CONNECT, onConnect );
			_socket.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorEvent );
			_socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketData );
		}
		
		
		public function get connected():Boolean
		{
			return _socket.connected;
		}
		
		public function close():void
		{
			_socket.close();
		}
		
		public function connect( host:String = null, port:int = 0 ):void
		{			
			_socket.connect( host, port );
			trace( "connecting" );
		}
		
		public function send( value:String ):void
		{			
			_socket.writeUTFBytes( value );
			_socket.flush();
		}
		
		
		private function onClose( event:Event ):void
		{
			trace( "onClose" );
			dispatchEvent( event );
		}
		
		private function onConnect( event:Event ):void
		{
			trace( "onConnect" );
			dispatchEvent( event );
		}
		
		private function onIOErrorEvent( event:IOErrorEvent ):void
		{
			trace( "onIOErrorEvent" );
			dispatchEvent( event );
		}
		
		private function onSecurityError( event:SecurityErrorEvent ):void
		{
			trace( "onSecurityError" );
			dispatchEvent( event );
		}
		
		//string to hold data as it comes in.
		private var buffer:String = "";
		
		private function onSocketData(event:ProgressEvent):void
		{
			//get the string sent from the Arduino. This could be any binary data
			//but in our case, we are sending strings.
			//In general, it is much easier to just always send strings from 
			//Arduino, and then parse then in ActionScript
			var data:String = _socket.readUTFBytes( _socket.bytesAvailable );
			
			//copy the newly arrived data into the buffer string.
			buffer += data;
			
			//completed message from the server
			var msg:String = "";
			var index:int;
			
			//loop through the buffer until it contains no more
			//end of message delimiter
			while((index = buffer.indexOf(EOL_DELIMITER)) > -1)
			{
				//extract the message from the beginning to where the delimiter is
				//we don't include the delimiter
				msg = buffer.substring(0, index);
				
				//remove the message from the buffer
				buffer = buffer.substring(index + 1);
				
				//trace out the message (or do whatever you want with it)
				trace("Message Received from Arduino : " + msg);
			}

			dispatchEvent( new DataEvent( DataEvent.DATA, false, false, msg ) );
		}
	}
	
	
	
}