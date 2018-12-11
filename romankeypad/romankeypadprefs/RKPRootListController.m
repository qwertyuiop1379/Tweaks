#include "RKPRootListController.h"
#import <spawn.h>

@implementation RKPRootListController
- (NSArray *)specifiers
{
    if (!_specifiers)
    {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

-(void)respring
{
    pid_t pid;
    const char *args[] = { "killall", "-9", "SpringBoard" };
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
-(void)reddit
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.reddit.com/user/qwertyuiop1379"]];
}

-(void)paypal
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.paypal.me/qwertyuiop1379"]];
}

-(void)github
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/qwertyuiop1379/qwertyuiop1379.github.io/tree/master/source"]];
}
@end
