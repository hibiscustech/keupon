/**
 * jQuery resetDefaultValue plugin
 * @version 0.9.1
 * @author Leandro Vieira Pinho 
 */
jQuery.fn.resetDefaultValue = function() {
	function _clearDefaultValue() {
		var _$ = $(this);
		if ( _$.val() == this.defaultValue ) { _$.val(''); }
	};
	function _resetDefaultValue() {
		var _$ = $(this);
		if ( _$.val() == '' ) { _$.val(this.defaultValue); }
	};
	return this.click(_clearDefaultValue).focus(_clearDefaultValue).blur(_resetDefaultValue);
}
