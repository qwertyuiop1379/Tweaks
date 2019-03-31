#import <UIKit/UIKit.h>
#import "Tweak.h"

#define BundleID "com.qiop1379.rememberme"

NSMutableDictionary *preferences;
NSMutableArray *rememberedAlerts;

@implementation UIAlertController (performThing)
-(BOOL)performThingWithThing:(NSDictionary * __strong *)alertDict
{
	BOOL found = false;

	for (NSDictionary *alert in rememberedAlerts)
	{
		if ([self.title isEqual:alert[@"title"]] && [self.message isEqual:alert[@"label"]])
		{
			found = true;
			*alertDict = alert;
		}
	}

	return found;
}
@end

%hook UIViewController
-(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
	if ([viewController isKindOfClass:UIAlertController.class])
	{
		UIAlertController *controller = (UIAlertController *)viewController;
		NSDictionary *dict = [[NSDictionary alloc] init];

		if ([controller performThingWithThing:&dict])
		{
			int arrayIndex = [dict[@"selected"] intValue];

			if (controller.actions[arrayIndex].handler)
			{
				controller.actions[arrayIndex].handler();
			}

			if (completion)
			{
				completion();
			}

			return;
		}
	}

	%orig;
}
%end

%hook UIAlertAction
%property (nonatomic, copy) id oldHandler;
-(void)setHandler:(void (^)(void))oldHandler
{
	if (!self.oldHandler)
	{
		self.oldHandler = oldHandler;

		void (^newBlock)() = ^void()
		{
			if (self.oldHandler)
			{
				self.oldHandler();
			}
		};

		%orig(newBlock);
	}

	%orig;
}
%end

%hook _UIAlertControllerActionView
-(id)initWithFrame:(CGRect)frame
{
    self = %orig;

    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHold)];
    hold.minimumPressDuration = 2;
    [self addGestureRecognizer:hold];

    return self;
}

%new
-(void)handleHold
{
    UIColor *oldColor = self.backgroundColor;
    self.backgroundColor = [UIColor greenColor];
    UIAlertController *controller = self.action._alertController;
   int selected = [controller.actions indexOfObject:self.action];

    NSDictionary *currentAlert = @{ @"cell" : @"PSStaticTextCell", @"title" : controller.title, @"label" : controller.message, @"selected" : [NSNumber numberWithInt:selected] };

	if (![rememberedAlerts containsObject:currentAlert])
	{
		[rememberedAlerts addObject:currentAlert];
		[preferences setValue:rememberedAlerts forKey:@"items"];

		NSError *error;
		if (![preferences writeToURL:[NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.qiop1379.rememberme.plist"] error:&error])
		{
			[[[UIAlertView alloc] initWithTitle:@"Error" message:[@"Failed to save settings. Error:\n" stringByAppendingString:error.localizedDescription] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
		}
	}

    [UIView animateWithDuration:1 animations:
    ^{
        self.backgroundColor = oldColor;
    }
    completion:nil];
}
%end

static void reloadPreferences()
{
	preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.rememberme.plist"] ?: [[NSMutableDictionary alloc] init];
    rememberedAlerts = [preferences objectForKey:@"items"] ?: [[NSMutableArray alloc] init];
}

%ctor
{
    reloadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, CFSTR("com.qiop1379.rememberme"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
