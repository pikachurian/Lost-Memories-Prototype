successTexts = [
	"I remember now!",
	"It's becoming clear.",
];

failureTexts = [
	"It's slipping away.",
	"Almost had it!",
	"I'm a bit foggy on the details."
];

//Result type.
enum RT
{
	success,
	failure
}

resultText = "test.";
textColor = c_green;
result = RT.success;

scale = 1.5;

image_alpha = 2;

function SetText(resultEnum)
{
	var _textArray = successTexts;
	switch(resultEnum)
	{
		case RT.success: 
			_textArray = successTexts; 
			textColor = c_green;
			result = RT.success;
			break;
		case RT.failure: 
			_textArray = failureTexts; 
			textColor = c_red;
			result = RT.failure;
			break;
	}
	
	resultText = _textArray[irandom(array_length(_textArray) - 1)];
}
