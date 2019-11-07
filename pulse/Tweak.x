@interface SBPasscodeNumberPadButton : NSObject
-(UIView *)circleView;
@end

%hook SBPasscodeNumberPadButton
+(double)highlightedCircleViewAlpha
{
	return 1;
}

+(double)unhighlightedCircleViewAlpha
{
	return 0.05f;
}

-(void)didMoveToWindow
{
	%orig;

	self.circleView.backgroundColor = UIColor.clearColor;

	self.circleView.layer.borderWidth = 1;
	self.circleView.layer.borderColor = UIColor.whiteColor.CGColor;
}
%end