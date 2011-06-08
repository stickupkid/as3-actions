package org.osflash.actions
{
	import org.osflash.actions.stream.IActionIOStream;
	import org.osflash.actions.stream.IActionOutputStream;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IAction extends IActionTransactions, IActionIOStream
	{
		
		function describe(stream : IActionOutputStream) : void;
		
		function get id() : String;
		function set id(value : String) : void;
		
		function get qname() : String;
	}
}
