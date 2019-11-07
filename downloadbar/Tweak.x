@class QSBIconProgressView;

@interface SBIcon : NSObject
+(CGFloat)cornerRadius;
-(double)progressPercent;
-(BOOL)isDownloadingIcon;
-(BOOL)progressIsPaused;
@end

@interface SBIconView : UIView
@property (nonatomic, retain) QSBIconProgressView *progressView;
-(UIView *)_iconImageView;
-(SBIcon *)icon;
@end

@interface SBIconImageView : UIView
+(CGFloat)cornerRadius;
@end

@interface SBIconProgressView : UIView
@end

@interface QSBIconProgressView : UIImageView
@property (nonatomic, retain) UIView *progressBarBackgroundView;
@property (nonatomic, retain) UIView *progressBarView;
@property (nonatomic, retain) SBIconView *iconView;
-(id)initWithIconView:(SBIconView *)arg1;
-(void)updateProgress;
@end

@implementation QSBIconProgressView
-(id)initWithIconView:(SBIconView *)arg1
{
	if ((self = [super initWithFrame:arg1._iconImageView.bounds]))
	{
		self.layer.cornerRadius = [%c(SBIconImageView) cornerRadius];
		self.layer.masksToBounds = YES;
		self.iconView = arg1;

		CGSize size = self.bounds.size;

		if (!self.progressBarBackgroundView)
		{
			self.progressBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, size.height - 20, size.width - 20, 10)];
			self.progressBarBackgroundView.backgroundColor = UIColor.darkGrayColor;
			self.progressBarBackgroundView.layer.cornerRadius = 3;
		}

		if (!self.progressBarView)
		{
			self.progressBarView = [[UIView alloc] initWithFrame:CGRectMake(10, size.height - 18, 0, 8)];
			self.progressBarView.backgroundColor = [UIColor colorWithRed:0.25f green:0.5f blue:1 alpha:1];
			self.progressBarView.layer.cornerRadius = 3;
		}
	}

	return self;
}

-(void)updateProgress
{
	CGSize size = self.bounds.size;
	CALayer *layer = [CALayer layer];
	layer.frame = self.bounds;
	layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f].CGColor;

	UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSaveGState(context);
	[layer renderInContext:context];
	CGContextRestoreGState(context);

	NSMutableParagraphStyle *style = NSParagraphStyle.defaultParagraphStyle.mutableCopy;
	style.alignment = NSTextAlignmentCenter;
	NSDictionary *attributes = @
	{
		NSParagraphStyleAttributeName : style,
		NSFontAttributeName : [UIFont systemFontOfSize:22],
		NSForegroundColorAttributeName : UIColor.whiteColor
	};

	if (self.iconView.icon.progressIsPaused)
	{
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
		CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
		CGContextFillRect(context, CGRectMake(size.width / 2 - 8, 10, 5, 20));
		CGContextFillRect(context, CGRectMake(size.width / 2 + 3, 10, 5, 20));
	}
	else
	{
		[[NSString stringWithFormat:@"%d%%", (int)(self.iconView.icon.progressPercent * 100)] drawInRect:CGRectMake(0, 10, size.width, size.height - 30) withAttributes:attributes];
		[UIView animateWithDuration:0.1f animations:^{ self.progressBarView.frame = CGRectMake(10, size.height - 20, self.iconView.icon.progressPercent * (size.width - 20), 10); }];
	}

	self.image = UIGraphicsGetImageFromCurrentImageContext();
	[self setNeedsDisplay];

	UIGraphicsEndImageContext();
}

-(void)didMoveToSuperview
{
	[super didMoveToSuperview];

	[self addSubview:self.progressBarBackgroundView];
	[self addSubview:self.progressBarView];
}
@end

%hook SBIconProgressView
-(void)setAlpha:(CGFloat)arg1
{
	%orig(0);
}

-(void)didMoveToWindow
{
	%orig;
	self.alpha = [NSString stringWithFormat:@"%p", self].intValue;
}
%end

%hook SBIconView
%property (nonatomic, retain) QSBIconProgressView *progressView;
-(void)_updateProgressAnimated:(BOOL)arg1
{
	%orig;

	if (!self.icon.isDownloadingIcon)
	{
		if (self.progressView.superview)
			[self.progressView removeFromSuperview];

		return;
	}

	if (!self.progressView)
		self.progressView = [[%c(QSBIconProgressView) alloc] initWithIconView:self];

	if (!self.progressView.superview)
		[self addSubview:self.progressView];

	if (self.icon.progressPercent >= 1)
		[UIView animateWithDuration:1 animations:^{ self.progressView.alpha = 0; } completion:^(BOOL arg1){ [self.progressView removeFromSuperview]; }];

	[self.progressView updateProgress];
}
%end