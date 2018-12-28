#import "DXIAppDelegate.h"
#import "DXIRootViewController.h"

@implementation DXIAppDelegate
-(void)applicationDidFinishLaunching:(UIApplication *)application
{
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DXIRootViewController alloc] init]];
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
}
@end