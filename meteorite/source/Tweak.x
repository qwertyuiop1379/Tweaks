#include <AppSupport/CPDistributedMessagingCenter.h>
#include <MRYIPCCenter.h>
#include "Tweak.h"

struct SBIconImageInfo {
    CGSize size;
    CGFloat scale;
    CGFloat continuousCornerRadius;
};

static NSDictionary *preferences;
static WFTemperature *temperature;
static long long conditions;

static void LoadPreferences()
{
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.meteorite"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if(keyList)
    {
        preferences = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.meteorite"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (!preferences) preferences = [NSDictionary new];
        CFRelease(keyList);
    }

    if (!preferences)
		preferences = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.qiop1379.meteorite.plist"];
}

static void UpdateFromServer()
{
	MRYIPCCenter *center = [MRYIPCCenter centerNamed:@"com.qiop1379.meteorite"];

	NSDictionary *data = [center callExternalMethod:@selector(getWeatherData) withArguments:nil];
	temperature = [NSKeyedUnarchiver unarchiveObjectWithData:data[@"temperature"]];
	conditions = [data[@"conditions"] longValue];
}

static void UpdateServerData()
{
	MRYIPCCenter *center = [MRYIPCCenter centerNamed:@"com.qiop1379.meteorite"];

	NSDictionary *data = @{@"temperature" : [NSKeyedArchiver archivedDataWithRootObject:temperature], @"conditions" : @(conditions)};
	[center callExternalVoidMethod:@selector(updateWeatherData:) withArguments:data];
}

static void UpdateTodayModel()
{
	[[%c(SBIconController) sharedInstance] updateTodayModel];
	[[%c(SBStatusBarStateAggregator) sharedInstance] _updateTimeItems];
}

UIImage *GetConditionsImage(long long c)
{
	NSString *imagePath = [NSString stringWithFormat:@"/Library/Application Support/Meteorite/%lld.png", c];
	if ([NSFileManager.defaultManager fileExistsAtPath:imagePath isDirectory:NULL])
		return [UIImage imageWithContentsOfFile:imagePath];

	return [UIImage imageWithContentsOfFile:@"/Library/Application Support/Meteorite/unknown.png"];
}

UIImage *InvertImageColors(UIImage *image)
{
    CGSize size = image.size;
    int width = size.width;
    int height = size.height;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = calloc(width*height*4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    for (int y = 0; y < height; y++)
    {
        unsigned char *linePointer = &memoryPool[y * width * 4];
        for (int x = 0; x < width; x++)
        {
            int r, g, b; 
            if(linePointer[3])
            {
                r = linePointer[0] * 255 / linePointer[3];
                g = linePointer[1] * 255 / linePointer[3];
                b = linePointer[2] * 255 / linePointer[3];
            }
            else
                r = g = b = 0;

            r = 255 - r;
            g = 255 - g;
            b = 255 - b;

            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            linePointer += 4;
        }
    }
	
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);

    return returnImage;
}

UIImage *CropImage(UIImage *image, CGFloat zoom)
{
    CGFloat zoomReciprocal = 1.0f / zoom;
    CGPoint offset = CGPointMake(image.size.width * ((1.0f - zoomReciprocal) / 2.0f), image.size.height * ((1.0f - zoomReciprocal) / 2.0f));
    CGRect croppedRect = CGRectMake(offset.x, offset.y, image.size.width * zoomReciprocal, image.size.height * zoomReciprocal);
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], croppedRect);
    UIImage* croppedImage = [[UIImage alloc] initWithCGImage:croppedImageRef scale:[image scale] orientation:[image imageOrientation]];
    CGImageRelease(croppedImageRef);
    return croppedImage;
}

static BOOL BoolForKey(NSString *key, BOOL fallback)
{
	if (!preferences)
		return fallback;

	id object = preferences[key];
	return object ? [object boolValue] : fallback;
}

static double FloatForKey(NSString *key, double fallback)
{
	if (!preferences)
		return fallback;

	id object = preferences[key];
	return object ? [object floatValue] : fallback;
}

%hook SBStatusBarStateAggregator
%property (nonatomic, retain) NSString *originalFormat;
-(void)_updateTimeItems
{
	if (!BoolForKey(@"statusBar", YES))
	{
		%orig;
		return;
	}

	NSDateFormatter *formatter = [self valueForKey:@"_timeItemDateFormatter"];
	self.originalFormat = self.originalFormat ?: formatter.dateFormat;

	BOOL celsius = BoolForKey(@"celsius", NO);
	NSString *temp = temperature ? [NSString stringWithFormat:@"%d°%c", celsius ? (int)temperature.celsius : (int)temperature.fahrenheit, celsius ? 'C' : 'F'] : @"...";
	formatter.dateFormat = [NSString stringWithFormat:@"%@ '| %@      '", self.originalFormat, temp];

	%orig;
}
%end

%group iOS12
%hook UIStatusBarTimeItemView
%property (nonatomic, retain) UIImageView *conditionImageView;
-(void)didMoveToSuperview
{
	%orig;

	UIImage *conditionsImage = GetConditionsImage(conditions);

	float scale = self.frame.size.height / conditionsImage.size.height * 1.1f;
	float width = conditionsImage.size.width * scale;
	float height = conditionsImage.size.height * scale;

	self.conditionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - width, (self.frame.size.height - height) / 2, width, height)];	
	if (!self.conditionImageView.superview)
		[self addSubview:self.conditionImageView];

	[self updateConditionImage];
}

-(void)updateForNewStyle:(id)arg1
{
	%orig;
	[self updateConditionImage];
}

%new
-(void)updateConditionImage
{
	UIImage *conditionsImage = GetConditionsImage(conditions);

	if ([[self.foregroundStyle valueForKey:@"_isTintColorBlack"] boolValue])
		conditionsImage = InvertImageColors(conditionsImage);

	self.conditionImageView.image = conditionsImage;
	[self.conditionImageView setNeedsDisplay];
}
%end

%hook SBIcon
-(NSString *)displayNameForLocation:(int)arg1
{
	if ([self.applicationBundleID isEqual:@"com.apple.weather"])
	{
		if (!BoolForKey(@"tweakActive", YES) || !BoolForKey(@"iconLabel", YES))
			return %orig;

		if (%c(WeatherImageLoader))
		{
			NSString *string = [%c(WeatherImageLoader) conditionImageNameWithConditionIndex:conditions];
			
			string = [string stringByReplacingOccurrencesOfString:@"-" withString:@" "];
			string = [string stringByReplacingOccurrencesOfString:@"day" withString:@""];
			string = [string stringByReplacingOccurrencesOfString:@"night" withString:@""];
			string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[string substringToIndex:1].uppercaseString];

			return string;
		}
	}

	return %orig;
}

-(UIImage *)getIconImage:(int)arg1
{
	if ([self.applicationBundleID isEqual:@"com.apple.weather"])
		return [UIImage _applicationIconImageForBundleIdentifier:@"com.apple.weather" format:arg1 scale:UIScreen.mainScreen.scale];

	return %orig;
}
%end
%end

%group iOS13
%hook _UIStatusBarStringView
%property (nonatomic, retain) UIImageView *conditionImageView;
%property (nonatomic, retain) NSString *timeText;
-(void)setFont:(UIFont *)arg1
{
	%orig([UIFont boldSystemFontOfSize:13]);
}

-(void)setText:(NSString *)arg1
{
	self.numberOfLines = 2;
	self.textAlignment = 1;

	if (![arg1 containsString:@"\n"])
		self.timeText = arg1;
	
	if ([arg1 containsString:@":"])
		[self updateConditionImage];
	else
		%orig;
}

%new
-(void)updateConditionImage
{
	BOOL celsius = BoolForKey(@"celsius", NO);
	NSString *yeet = [NSString stringWithFormat:@"%@\n%d°%c", self.timeText, celsius ? (int)temperature.celsius : (int)temperature.fahrenheit, celsius ? 'C' : 'F'];

	UIImage *conditionsImage = GetConditionsImage(conditions);

	NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
	imageAttachment.image = CropImage(conditionsImage, 1.25);
	imageAttachment.bounds = CGRectMake(0, (self.font.capHeight - self.font.lineHeight) / 2, self.font.lineHeight, self.font.lineHeight);
	
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:yeet];
	[text appendAttributedString:[NSAttributedString attributedStringWithAttachment:imageAttachment]];

	self.attributedText = text;
}
%end

%hook SBWeatherApplicationIcon
-(id)initWithApplication:(id)arg1
{
	self = %orig;
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(reloadIconImage) userInfo:nil repeats:YES];
	return self;
}

-(id)generateIconImageWithInfo:(struct SBIconImageInfo)arg1
{
	return BoolForKey(@"appIcon", YES) ? [[%c(SBIconController) sharedInstance] cachedWeatherIconForSize:arg1.size format:2 scale:arg1.scale] : %orig;
}

-(id)iconImageWithInfo:(struct SBIconImageInfo)arg1
{
	return BoolForKey(@"appIcon", YES) ? [[%c(SBIconController) sharedInstance] cachedWeatherIconForSize:arg1.size format:2 scale:arg1.scale] : %orig;
}
%end

%hook SBApplicationIcon
-(id)initWithApplication:(id)arg1
{
	self = %orig;

	if ([self.applicationBundleID isEqual:@"com.apple.weather"])
		[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(reloadIconImage) userInfo:nil repeats:YES];

	return self;
}

-(id)generateIconImageWithInfo:(struct SBIconImageInfo)arg1
{
	if ([self.applicationBundleID isEqual:@"com.apple.weather"] && BoolForKey(@"appIcon", YES))
		return [[%c(SBIconController) sharedInstance] cachedWeatherIconForSize:arg1.size format:2 scale:arg1.scale];

	return %orig;
}

-(id)iconImageWithInfo:(struct SBIconImageInfo)arg1
{
	if ([self.applicationBundleID isEqual:@"com.apple.weather"] && BoolForKey(@"appIcon", YES))
		return [[%c(SBIconController) sharedInstance] cachedWeatherIconForSize:arg1.size format:2 scale:arg1.scale];

	return %orig;
}
%end
%end

%hook SBHomeScreenViewController
-(void)viewDidAppear:(BOOL)arg1
{
	%orig;
	UpdateTodayModel();
}
%end

%hook SBIconController
%property (nonatomic, retain) WATodayModel *todayModel;
%property (nonatomic, retain) NSTimer *weatherTimer;
-(void)init
{
	%orig;

	[MeteoriteServer load];

	if (!self.todayModel)
		[self updateTodayModel];

	self.weatherTimer = [NSTimer scheduledTimerWithTimeInterval:(FloatForKey(@"refreshTimer", 5) * 60) target:self selector:@selector(weatherTimerFired) userInfo:nil repeats:YES];
	[self weatherTimerFired];
}

%new
-(void)updateTodayModel
{
	self.todayModel = [%c(WATodayModel) autoupdatingLocationModelWithPreferences:[%c(WeatherPreferences) sharedPreferences] effectiveBundleIdentifier:@"com.apple.weather"];
	self.todayModel.isLocationTrackingEnabled = YES;
	self.todayModel.locationServicesActive = YES;

	WACurrentForecast *forecast = self.todayModel.forecastModel.currentConditions;
	temperature = forecast.temperature;
	conditions = forecast.conditionCode;
}

%new
-(void)weatherTimerFired
{
	if (!BoolForKey(@"tweakActive", YES))
		return;
	
	UpdateTodayModel();
	UpdateServerData();
}

%new
-(UIImage *)cachedWeatherIconForSize:(CGSize)size format:(int)arg2 scale:(CGFloat)arg3
{
	UIImage *icon = [UIImage imageWithContentsOfFile:@"/Library/Application Support/Meteorite/meteorite.png"];
	UIImage *conditionsImage = GetConditionsImage(conditions);

	BOOL celsius = BoolForKey(@"celsius", NO);

	NSString *temp = temperature ? [NSString stringWithFormat:@"%d°%c", celsius ? (int)temperature.celsius : (int)temperature.fahrenheit, celsius ? 'C' : 'F'] : @"...";
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	style.alignment = NSTextAlignmentCenter;
	NSDictionary *attributes = @{ NSParagraphStyleAttributeName : style, NSFontAttributeName : [UIFont boldSystemFontOfSize:size.height / 5], NSForegroundColorAttributeName : UIColor.whiteColor };
	
	UIGraphicsBeginImageContextWithOptions(size, false, arg3);
	[icon drawInRect:CGRectMake(0, 0, size.width, size.height)];
	[temp drawInRect:CGRectIntegral(CGRectMake(0, size.height - size.height / 3, size.width, size.height)) withAttributes:attributes];
	[conditionsImage drawInRect:CGRectIntegral(CGRectMake(0, size.height / -6, size.width, size.height))];

	icon = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return [icon _applicationIconImageForFormat:arg2 precomposed:YES scale:arg3];
}
%end

%hook UIImage
+(UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)arg1 format:(int)arg2 scale:(double)arg3
{
	UIImage *orig = %orig;
	if (![arg1 isEqual:@"com.apple.weather"] || !BoolForKey(@"tweakActive", YES) || !BoolForKey(@"appIcon", YES))
		return orig;

	return [[%c(SBIconController) sharedInstance] cachedWeatherIconForSize:orig.size format:arg2 scale:arg3];
}
%end

%ctor
{
	NSString *argv0 = NSProcessInfo.processInfo.arguments[0];
	if (![argv0 containsString:@"/Application"] && ![argv0 containsString:@"SpringBoard"])
		return;

	if (!%c(WeatherPreferences) || %c(WATodayModel))
		dlopen("/System/Library/PrivateFrameworks/Weather.framework/Weather", RTLD_LAZY);

	if (kCFCoreFoundationVersionNumber >= 1665.15)
	{
		%init(iOS13);
	}
	else
	{
		%init(iOS12);
	}

	%init(_ungrouped);

	if ([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"])
	{
		CFNotificationCenterAddObserver(NOTIFICATION_CENTER, NULL, UpdateTodayModel, CFSTR("com.qiop1379.meteorite/update"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
	else
	{
		UpdateFromServer();
		CFNotificationCenterAddObserver(NOTIFICATION_CENTER, NULL, UpdateFromServer, CFSTR("com.qiop1379.meteorite/set"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}

	LoadPreferences();
	CFNotificationCenterAddObserver(NOTIFICATION_CENTER, NULL, LoadPreferences, CFSTR("com.qiop1379.meteorite"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}