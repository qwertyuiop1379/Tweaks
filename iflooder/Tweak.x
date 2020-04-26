@interface CKNavbarCanvasViewController : UIViewController
-(UINavigationController *)proxyNavigationController;
-(id)conversation;
@end

@interface CKNavigationBarCanvasView : UIView
@property (nonatomic, retain) UIView *leftItemView;
@property (nonatomic, retain) UIView *rightItemView;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) BOOL isFlooding;
-(CKNavbarCanvasViewController *)delegate;
-(void)sendString:(NSString *)arg1;
-(void)updateRightItem;
@end

@interface CKMessagesSpammerViewController : UIViewController
@end

@interface CKChatController : UIViewController
-(void)sendCompositionWithoutThrow:(id)arg1 inConversation:(id)arg2;
-(id)conversation;
@end

@interface CKComposition : NSObject
-(id)initWithText:(id)arg1 subject:(id)arg2;
@end

@interface CKConversation : NSObject
@end

@implementation CKMessagesSpammerViewController
{
	NSInteger _mode;

	UILabel *_description;
	UITextView *_textView;
}

-(void)viewDidLoad
{
	[super viewDidLoad];

	self.title = @"iFlooder";

	_mode = 0;

	if ([self respondsToSelector:@selector(traitCollection)])
		self.view.backgroundColor = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) ? UIColor.whiteColor : UIColor.blackColor;
	else
		self.view.backgroundColor = UIColor.blackColor;

	self.navigationItem.leftBarButtonItem.target = self;
	self.navigationItem.leftBarButtonItem.action = @selector(back);

	UILayoutGuide *margins = self.view.layoutMarginsGuide;

	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Fixed", @"Words", @"Count"]];
	[segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
	segment.translatesAutoresizingMaskIntoConstraints = NO;
	segment.selectedSegmentIndex = _mode;
	[self.view addSubview:segment];

	[segment.topAnchor constraintEqualToAnchor:margins.topAnchor constant:self.navigationController.navigationBar.frame.size.height - 10].active = YES;
	[segment.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
	[segment.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;

	_description = [[UILabel alloc] init];
	_description.translatesAutoresizingMaskIntoConstraints = NO;
	_description.font = [UIFont systemFontOfSize:12];
	_description.textColor = UIColor.grayColor;
	[self.view addSubview:_description];

	[_description.topAnchor constraintEqualToAnchor:segment.bottomAnchor constant:10].active = YES;
	[_description.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:10].active = YES;
	[_description.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:10].active = YES;

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self action:@selector(startPressed:) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"Start flooding" forState:UIControlStateNormal];
	[button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[button setTitleColor:UIColor.lightGrayColor forState:UIControlStateHighlighted];
	button.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	button.layer.cornerRadius = 20;
	[self.view addSubview:button];

	[button.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
	[button.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
	[button.bottomAnchor constraintEqualToAnchor:margins.bottomAnchor].active = YES;
	[button.heightAnchor constraintEqualToConstant:100].active = YES;

	_textView = [[UITextView alloc] init];
	_textView.translatesAutoresizingMaskIntoConstraints = NO;
	_textView.layer.borderColor = UIColor.grayColor.CGColor;
	_textView.layer.borderWidth = 1;
	_textView.layer.cornerRadius = 10;
	[self.view addSubview:_textView];

	[_textView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
	[_textView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
	[_textView.topAnchor constraintEqualToAnchor:_description.bottomAnchor constant:10].active = YES;
	[_textView.bottomAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:10].active = YES;

	[self updateView];
}

-(void)updateView
{
	[UIView animateWithDuration:0.3f animations:
	^{
		switch (_mode)
		{
			case 0:
			{
				_description.text = @"Spam a fixed message.";
				_textView.alpha = 1;
				break;
			}

			case 1:
			{
				_description.text = @"Spam each word of a message individually.";
				_textView.alpha = 1;
				break;
			}

			case 2:
			{
				_description.text = @"Spam numbers counting up from 1.";
				_textView.alpha = 0;
				break;
			}
		}
	}];
}

-(void)segmentChanged:(UISegmentedControl *)arg1
{
	_mode = arg1.selectedSegmentIndex;
	[_textView resignFirstResponder];
	[self updateView];
}

-(void)startPressed:(UIButton *)arg1
{
	[self back];

	NSDictionary *info =
	@{
		@"message" : _textView.text ?: @"",
		@"mode" : @(_mode)
	};

	[NSNotificationCenter.defaultCenter postNotificationName:@"iFlooder.startFlooding" object:nil userInfo:info];
}

-(void)back
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;

    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
	[self.navigationController popViewControllerAnimated:NO];
}
@end

static UIImage *UIKitImage(NSString *name)
{
    NSString *artworkPath = @"/System/Library/PrivateFrameworks/UIKitCore.framework/Artwork.bundle";
    NSBundle *artworkBundle = [NSBundle bundleWithPath:artworkPath];
    if (!artworkBundle)
    {
        artworkPath = @"/System/Library/Frameworks/UIKit.framework/Artwork.bundle";
        artworkBundle = [NSBundle bundleWithPath:artworkPath];
    }
    UIImage *img = [UIImage imageNamed:name inBundle:artworkBundle compatibleWithTraitCollection:nil];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%hook CKNavigationBarCanvasView
%property (nonatomic, retain) NSString *message;
%property (nonatomic, assign) BOOL isFlooding;
-(void)didMoveToSuperview
{
	%orig;

	self.isFlooding = NO;
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(startFlooding:) name:@"iFlooder.startFlooding" object:nil];
}

%new
-(void)startFlooding:(NSNotification *)arg1
{
	if (self.isFlooding)
		return;

	self.isFlooding = YES;

	[self updateRightItem];

	self.message = arg1.userInfo[@"message"];
	NSInteger mode = [arg1.userInfo[@"mode"] intValue];

	void (^operation)() = nil;

	switch (mode)
	{
		case 0:
		{
			operation = ^()
			{
				[self sendString:self.message];
			};

			break;
		}

		case 1:
		{
			operation = ^()
			{
				static NSInteger index = 0;
				static NSArray *words;

				if (!words)
					words = [self.message componentsSeparatedByString:@" "];

				[self sendString:words[index]];
				index = (++index == words.count) ? 0 : index;
			};

			break;
		}

		case 2:
		{
			operation = ^()
			{
				static NSUInteger count = 0;
				[self sendString:@(++count).stringValue];
			};

			break;
		}
	}

	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:operation repeats:YES];
}

%new
-(void)timerFired:(NSTimer *)arg1
{
	if (!self.isFlooding)
	{
		[arg1 invalidate];
		return;
	}

	void (^operation)() = arg1.userInfo;
	operation();
}

%new
-(void)stopPressed
{
	self.isFlooding = NO;

	[self updateRightItem];
}

%new
-(void)updateRightItem
{
	CGFloat width = self.leftItemView.frame.size.width;

	if (self.isFlooding)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button addTarget:self action:@selector(stopPressed) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:UIKitImage(@"UIButtonBarPause") forState:UIControlStateNormal];
		button.frame = CGRectMake(0, 0, width, width);
		self.rightItemView = button;
	}
	else
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:UIKitImage(@"UIButtonBarFastForward") forState:UIControlStateNormal];
		button.frame = CGRectMake(0, 0, width, width);
		self.rightItemView = button;
	}
}

-(void)setLeftItemView:(UIView *)arg1
{
	%orig;

	if (!arg1)
	{
		self.rightItemView = nil;
		return;
	}

	[self updateRightItem];
}

%new
-(void)buttonPressed
{
	CKMessagesSpammerViewController *vc = [[CKMessagesSpammerViewController alloc] init];

	CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;

    [self.delegate.proxyNavigationController.view.layer addAnimation:transition forKey:kCATransition];
	[self.delegate.proxyNavigationController pushViewController:vc animated:NO];
}

%new
-(void)sendString:(NSString *)arg1
{	
	static CKChatController *controller;

	if (!controller)
	{
		controller = self.delegate.proxyNavigationController.childViewControllers.firstObject;

		if (![controller isKindOfClass:%c(CKChatController)])
			controller = nil;
	}

	CKComposition *composition = [[%c(CKComposition) alloc] initWithText:[[NSAttributedString alloc] initWithString:arg1] subject:nil];
	[controller sendCompositionWithoutThrow:composition inConversation:self.delegate.conversation];
}
%end
