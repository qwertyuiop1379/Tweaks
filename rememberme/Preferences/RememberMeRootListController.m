#include "RememberMeRootListController.h"
#include "PSSpecifier.h"

extern NSString *PSDeletionActionKey;

@implementation RememberMeRootListController
-(NSArray *)specifiers
{
	_specifiers = [self loadSpecifiersFromPlistName:@"../../../var/mobile/Library/Preferences/com.qiop1379.rememberme" target:self] ?: [[NSMutableArray alloc] init];
	self.navigationItem.title = @"RememberMe";

	for (PSSpecifier *specifier in _specifiers)
	{
		[specifier setProperty:NSStringFromSelector(@selector(removedSpecifier:)) forKey:PSDeletionActionKey];
	}
	
	PSSpecifier *headerGroup = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:NULL get:NULL detail:nil cell:0 edit:nil];
	PSSpecifier *bodyGroup = [PSSpecifier preferenceSpecifierNamed:@"Selections" target:self set:NULL get:NULL detail:nil cell:0 edit:nil];
	
	[headerGroup setProperty:@"To remove selections, enter edit mode and delete them." forKey:@"footerText"];

	[_specifiers insertObject:bodyGroup atIndex:0];
	[_specifiers insertObject:headerGroup atIndex:0];

	return _specifiers;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

-(void)removedSpecifier:(PSSpecifier *)specifier
{
	NSMutableDictionary *preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.rememberme.plist"];
	NSMutableArray *items = [preferences objectForKey:@"items"];

	for (NSDictionary *item in items)
	{
		if ([item[@"label"] isEqual:[specifier propertyForKey:@"label"]] && [item[@"title"] isEqual:[specifier propertyForKey:@"title"]])
		{
			[items removeObject:item];
		}
	}

	[preferences setValue:items forKey:@"items"];

	NSError *error;
	if (![preferences writeToURL:[NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.qiop1379.rememberme.plist"] error:&error])
	{
		[[[UIAlertView alloc] initWithTitle:@"Error" message:[@"Failed to save settings. Error:\n" stringByAppendingString:error.localizedDescription] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
	}

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFNotificationName)@"com.qiop1379.rememberme", NULL, NULL, NO);
}
@end