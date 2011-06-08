package org.osflash.actions.types
{
	import org.osflash.actions.Action;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionIntType extends Action
	{
		
		private var _int : int;

		public function ActionIntType()
		{
			super(1);
			
			_int = 0;
		}
		
		/**
		 * Initialiser for the ActionIntType
		 * 
		 * @param value int
		 */
		public function init(value : int) : void
		{
			if(isNaN(value)) throw new ArgumentError('Given value can not be NaN');
				
			_int = value;
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function commit() : void
		{
//			trace(id + " : COMMIT > " + _int);
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function revert() : void
		{
//			trace(id + " : REVERT > " + _int);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function read(stream : IActionInputStream) : void
		{
			super.read(stream);
			
			_int = stream.readInt();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function write(stream : IActionOutputStream) : void
		{
			super.write(stream);
			
			stream.writeInt(_int);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function describe(stream : IActionOutputStream) : void
		{
			super.describe(stream);
			
			stream.writeInt(_int);
		}

	}
}
