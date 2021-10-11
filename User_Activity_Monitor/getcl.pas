unit getcl;

interface

function SetKeyboardHook: Boolean; stdcall;
function RemoveKeyboardHook: Boolean; stdcall;

implementation

function SetKeyboardHook: Boolean; external 'getcl.dll';
function RemoveKeyboardHook: Boolean; external 'getcl.dll';

end.
