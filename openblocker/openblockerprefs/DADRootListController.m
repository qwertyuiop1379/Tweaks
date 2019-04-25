#include "DADRootListController.h"
#include <SparkAppList/SparkAppListTableViewController.h>

@implementation DADRootListController

-(NSArray *)specifiers
{
	if (!_specifiers)
	{
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)showAppList
{
	SparkAppListTableViewController *applist = [[SparkAppListTableViewController alloc] initWithIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts"];
	[self.navigationController pushViewController:applist animated:YES];
	self.navigationItem.hidesBackButton = FALSE;
}

-(void)respring
{
	system("killall -9 SpringBoard");
}
@end
