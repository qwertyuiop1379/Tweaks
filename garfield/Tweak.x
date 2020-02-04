#import <AudioToolbox/AudioServices.h>

void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id arg, NSDictionary *vibratePattern);
void AudioServicesStopSystemSound(SystemSoundID inSystemSoundID);

NSDictionary *pattern;
NSDictionary *morseTranslations;
float intensity;

@interface SpringBoard : NSObject
@property (nonatomic, retain) UIView *blurView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UISlider *intensitySlider;
@property (nonatomic, retain) UISlider *speedSlider;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) BOOL loopEnabled;
@property (nonatomic, assign) BOOL volumePressed;
@end

%hook SpringBoard
%property (nonatomic, retain) UIView *blurView;
%property (nonatomic, retain) UIView *overlayView;
%property (nonatomic, retain) UISlider *intensitySlider;
%property (nonatomic, retain) UISlider *speedSlider;
%property (nonatomic, retain) UITextView *textView;
%property (nonatomic, retain) NSString *message;
%property (nonatomic, assign) BOOL loopEnabled;
%property (nonatomic, assign) BOOL volumePressed;
-(BOOL)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1
{
	UIPress *touch = [arg1.allPresses anyObject];
	if (touch.type == 102)
	{
		if (touch.force == 1)
		{
			self.volumePressed = YES;
			[self performSelector:@selector(checkPressed) withObject:nil afterDelay:0.25f];
		}
		else
		{
			self.volumePressed = NO;
		}
	}

	return %orig;
}

%new
-(void)checkPressed
{
	if (self.volumePressed)
		[self performSelector:@selector(showMenu)];
}

%new
-(void)showMenu
{
	if (self.overlayView)
		[self performSelector:@selector(cancelPressed)];

	CGRect screen = UIScreen.mainScreen.bounds;
	UIView *view = UIApplication.sharedApplication.keyWindow;
	
	self.blurView = [[UIView alloc] initWithFrame:screen];
	self.blurView.backgroundColor = UIColor.blackColor;
	self.blurView.alpha = 0.4f;
	[view addSubview:self.blurView];

	self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, screen.size.height / 3, screen.size.width, screen.size.height * 2 / 3)];
	self.overlayView.backgroundColor = UIColor.whiteColor;
	[view addSubview:self.overlayView];

	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	cancelButton.backgroundColor = [UIColor colorWithRed:0.75f green:0.2f blue:0.2f alpha:1];
	cancelButton.frame = CGRectMake(10, 10, screen.size.width / 2 - 15, 40);
	cancelButton.layer.cornerRadius = 10;
	[self.overlayView addSubview:cancelButton];

	UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendButton addTarget:self action:@selector(sendPressed) forControlEvents:UIControlEventTouchUpInside];
	[sendButton setTitle:@"Start/Stop" forState:UIControlStateNormal];
	[sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	sendButton.backgroundColor = [UIColor colorWithRed:0.2f green:0.75f blue:0.2f alpha:1];
	sendButton.frame = CGRectMake(screen.size.width / 2 + 5, 10, screen.size.width / 2 - 15, 40);
	sendButton.layer.cornerRadius = 10;
	[self.overlayView addSubview:sendButton];

	UILabel *intensityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 90, 40)];
	intensityLabel.text = @"Intensity";
	[self.overlayView addSubview:intensityLabel];

	self.intensitySlider = [[UISlider alloc] initWithFrame:CGRectMake(80, 60, screen.size.width - 100, 40)];
	[self.intensitySlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	self.intensitySlider.tag = 1;
	self.intensitySlider.minimumValue = 0;
	self.intensitySlider.maximumValue = 1;
	self.intensitySlider.value = 0.5f;
	self.intensitySlider.continuous = YES;
	[self.overlayView addSubview:self.intensitySlider];

	UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 90, 40)];
	speedLabel.text = @"Speed";
	[self.overlayView addSubview:speedLabel];

	self.speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, 110, screen.size.width - 100, 40)];
	[self.intensitySlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	self.speedSlider.tag = 2;
	self.speedSlider.minimumValue = 1;
	self.speedSlider.maximumValue = 5;
	self.speedSlider.value = 3;
	self.speedSlider.continuous = YES;
	[self.overlayView addSubview:self.speedSlider];

	UIButton *editMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[editMessageButton addTarget:self action:@selector(editMessage) forControlEvents:UIControlEventTouchUpInside];
	[editMessageButton setTitle:@"Edit message" forState:UIControlStateNormal];
	[editMessageButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	editMessageButton.backgroundColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1];
	editMessageButton.frame = CGRectMake(10, 160, screen.size.width - 20, 40);
	editMessageButton.layer.cornerRadius = 10;
	[self.overlayView addSubview:editMessageButton];

	self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 210, screen.size.width - 20, self.overlayView.frame.size.height - 220)];
	self.textView.text = @"No message.";
	self.textView.font = [UIFont systemFontOfSize:16];
	self.textView.editable = NO;
	[self.overlayView addSubview:self.textView];

	self.loopEnabled = NO;
}

%new
-(void)cancelPressed
{
	[self.overlayView removeFromSuperview];
	[self.blurView removeFromSuperview];
}

%new
-(void)sendPressed
{
	self.loopEnabled = !self.loopEnabled;

	if (self.loopEnabled)
		[self performSelectorInBackground:@selector(messageLoop) withObject:nil];
}

%new
-(void)sliderChanged:(UISlider *)arg1
{
	pattern = @{ @"Intensity" : @(arg1.value + 0.01f), @"OffDuration" : @(1), @"OnDuration" : @(10) };
}

%new
-(void)messageLoop
{
	for (int i = 0; i < self.message.length; i++)
	{
		if (!self.loopEnabled)
			return;

		NSString *letter = [NSString stringWithFormat:@"%c", [self.message characterAtIndex:i]];
		if (morseTranslations[letter])
		{
			NSString *morse = morseTranslations[letter];
			for (int c = 0; c < morse.length; c++)
			{
				if (!self.loopEnabled)
					return;

				AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
				
				char next = [morse characterAtIndex:c];
				if (next == '.')
				{
					AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, pattern);
					[NSThread sleepForTimeInterval:0.2f];
				}
				else if (next == '-')
				{
					AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, pattern);
					[NSThread sleepForTimeInterval:0.6f];
				}
				else
				{
					continue;
				}

				AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
				[NSThread sleepForTimeInterval:0.02f];
			}

			[NSThread sleepForTimeInterval:0.75f];
		}
		else if ([letter isEqual:@" "])
		{
			[NSThread sleepForTimeInterval:1];
		}
	}

	if (self.loopEnabled)
	{
		[NSThread sleepForTimeInterval:2];
		objc_msgSend(self, _cmd);
	}
}

%new
-(void)editMessage
{
	UIAlertController *messagePrompt = [UIAlertController alertControllerWithTitle:@"Message" message:@"Enter your message:" preferredStyle:UIAlertControllerStyleAlert];
	[messagePrompt addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Message";
        textField.textColor = UIColor.blackColor;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.backgroundColor = UIColor.clearColor;
        textField.borderStyle = UITextBorderStyleNone;
    }];
	[messagePrompt addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
	[messagePrompt addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		NSString *_message = messagePrompt.textFields[0].text;
		NSString *message = @"";

		for (int i = 0; i < _message.length; i++)
		{
			char c = [_message characterAtIndex:i];
			if (isalpha(c) || isdigit(c) || c == ' ')
				message = [NSString stringWithFormat:@"%@%c", message, c];
		}

		[self performSelector:@selector(showMenu)];
		
		self.message = message.lowercaseString;
		self.textView.text = self.message;
	}]];

	[self performSelector:@selector(cancelPressed)];
	[UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:messagePrompt animated:YES completion:nil];
}
%end

%ctor
{
	pattern = @{ @"Intensity" : @(0.5f), @"OffDuration" : @(1), @"OnDuration" : @(10) };

	morseTranslations = @
	{
		@"a" : @".-",
		@"b" : @"-...",
		@"c" : @"-.-.",
		@"d" : @"-..",
		@"e" : @".",
		@"f" : @"..-.",
		@"g" : @"--.",
		@"h" : @"....",
		@"i" : @"..",
		@"j" : @".---",
		@"k" : @"-.-",
		@"l" : @".-..",
		@"m" : @"--",
		@"n" : @"-.",
		@"o" : @"---",
		@"p" : @".--.",
		@"q" : @"--.-",
		@"r" : @".-.",
		@"s" : @"...",
		@"t" : @"-",
		@"u" : @"..-",
		@"v" : @"...-",
		@"w" : @".--",
		@"x" : @"-..-",
		@"y" : @"-.--",
		@"z" : @"--..",
		@"1" : @".----",
		@"2" : @"..---",
		@"3" : @"...--",
		@"4" : @"....-",
		@"5" : @".....",
		@"6" : @"-....",
		@"7" : @"--...",
		@"8" : @"---..",
		@"9" : @"----.",
		@"0" : @"-----"
	};
}