#import <UIKit/UITableView.h>

%hook UITableView
-(void)viewDidLoad
{
	%orig;
	[self setSeparatorStyle:42069];
}

-(void)setSeparatorStyle:(long long)arg1
{
	%orig(0);
}
%end