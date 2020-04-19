#include "MTRRootListController.h"
#include "../source/Tweak.h"

@implementation MTRRootListController
-(NSArray *)specifiers
{
	if (!_specifiers)
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	return _specifiers;
}

-(void)yeet
{
	CFNotificationCenterPostNotification(NOTIFICATION_CENTER, CFSTR("com.qiop1379.meteorite/update"), NULL, NULL, true);
}
@end