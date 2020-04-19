#define NOTIFICATION_CENTER CFNotificationCenterGetDarwinNotifyCenter()

@interface UIImage (icon)
+(UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)arg1 format:(int)arg2 scale:(double)arg3;
-(UIImage *)_applicationIconImageForFormat:(int)format precomposed:(BOOL)precomposed scale:(double)scale;
-(UIImage *)_applicationIconImageForFormat:(int)format precomposed:(BOOL)precomposed;
@end

@interface WFTemperature : NSObject
-(double)fahrenheit;
-(double)celsius;
@end

@interface WACurrentForecast : NSObject
-(WFTemperature *)temperature;
-(long long)conditionCode;
@end

@interface WAForecastModel : NSObject
-(WACurrentForecast *)currentConditions;
@end

@interface WeatherImageLoader : NSObject
+(UIImage *)conditionImageWithConditionIndex:(long long)arg1;
+(NSString *)conditionImageNameWithConditionIndex:(long long)arg1;
@end

@interface WATodayModel : NSObject
@property (assign,nonatomic) BOOL isLocationTrackingEnabled;
@property (assign,nonatomic) BOOL locationServicesActive;
+(WATodayModel *)autoupdatingLocationModelWithPreferences:(id)arg1 effectiveBundleIdentifier:(id)arg2;
-(WAForecastModel *)forecastModel;
-(BOOL)executeModelUpdateWithCompletion:(id)arg1;
@end

@interface SBIconImageView : NSObject
-(void)updateImageAnimated:(BOOL)arg1;
@end

@interface SBIconView : NSObject
-(SBIconImageView *)_iconImageView;
@end

@interface SBIcon : NSObject
-(NSString *)applicationBundleID;
@end

@interface WeatherPreferences : NSObject
+(WeatherPreferences *)sharedPreferences;
@end

@interface SBIconController : UIViewController
@property (nonatomic, retain) WATodayModel *todayModel;
+(instancetype)sharedInstance;
-(UIImage *)cachedWeatherIconForSize:(CGSize)arg1 format:(int)arg2 scale:(CGFloat)arg3;
-(void)weatherTimerFired;
-(void)updateTodayModel;
@end

@interface SBStatusBarStateAggregator : NSObject
@property (nonatomic, retain) NSString *originalFormat;
+(instancetype)sharedInstance;
-(void)_updateTimeItems;
@end

@interface _UILegibilityImageSet : NSObject
@property (nonatomic, retain) UIImage *image;
@end

@interface MeteoriteServer : NSObject
+(void)load;
@end

@interface UIStatusBarForegroundStyleAttributes : NSObject
@end

@interface _UIStatusBarStringView : UILabel
@property (nonatomic, retain) UIImageView *conditionImageView;
@property (nonatomic, retain) NSString *timeText;
-(void)updateConditionImage;
@end

@interface UIStatusBarTimeItemView : UIView
@property (nonatomic, retain) UIImageView *conditionImageView;
-(UIStatusBarForegroundStyleAttributes *)foregroundStyle;
-(void)updateConditionImage;
@end

@interface SBApplicationIcon : SBIcon
@end

@interface SBWeatherApplicationIcon : SBIcon
@end