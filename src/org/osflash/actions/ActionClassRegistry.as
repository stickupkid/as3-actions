package org.osflash.actions
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionClassRegistry implements IActionClassRegistry
	{
		
		/**
		 * @private
		 */
		private var _classes : Dictionary;
		
		/**
		 * @private
		 */
		private var _actionInterfaceQName : String;
		
		public function ActionClassRegistry()
		{
			_classes = new Dictionary();
			
			// Get this at runtime, incase refactoring in the future breaks this lookup.
			_actionInterfaceQName = getQualifiedClassName(IAction);
		}
		
		/**
		 * @inheritDoc
		 */
		public function create(identifier : String) : IAction
		{
			if(null == identifier) throw new ArgumentError('Given value can not be null');
			
			for(var ident : String in _classes)
			{
				if(ident == identifier)
				{
					const actionClass : Class = _classes[ident];
					const action : IAction = new actionClass();
					if(null == action)
						ActionError.throwError(ActionError.INVALID_ACTION_CLASS);
					
					return action;
				}
			}
			
			ActionError.throwError(ActionError.ACTION_CLASS_DOES_NOT_EXIST);
			
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function add(actionClass : Class) : void
		{
			if(null == actionClass) throw new ArgumentError('Given value can not be null');
			if(contains(actionClass))
				ActionError.throwError(ActionError.ACTION_CLASS_ALREADY_EXISTS);
			
			if(verify(actionClass))
			{
				const identifier : String = getQualifiedClassName(actionClass);
				_classes[identifier] = actionClass;
			}
			else ActionError.throwError(ActionError.INVALID_ACTION_CLASS);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(actionClass : Class) : void
		{
			if(null == actionClass) throw new ArgumentError('Given value can not be null');
			if(contains(actionClass))
			{
				const identifier : String = getQualifiedClassName(actionClass);
				delete _classes[identifier];
			}
			else ActionError.throwError(ActionError.ACTION_CLASS_DOES_NOT_EXIST);
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(actionClass : Class) : Boolean
		{
			return null != _classes[actionClass];
		}
		
		/**
		 * @private
		 */
		private function verify(actionClass : Class) : Boolean
		{
			const description : XML = describeType(actionClass);
			const factory : XMLList = description.child('factory');
			if(null == factory) return false;
			
			const constructors : XMLList = factory.child('constructor');
			if(null != constructors)
			{
				var optional : int = 0;
				
				const parameters : XMLList = constructors.child('parameter');
				for each(var param : XML in parameters)
				{				
					if(param.@optional == "true")
						optional++;
				}
				
				if(parameters.length() != optional)
					ActionError.throwError(ActionError.ACTION_CLASS_CAN_NOT_HAVE_PARAMETERS);
			}
			
			const interfaces : XMLList = factory.child('implementsInterface');
			if(null == interfaces) return false;
			
			for each(var inter : XML in interfaces)
			{
				const type : String = inter.@type;
				if(type == _actionInterfaceQName)
					return true;
			}
			
			return false;
		}
	}
}
