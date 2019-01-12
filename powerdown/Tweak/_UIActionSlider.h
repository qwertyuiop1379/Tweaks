@protocol _UIActionSliderLabel, _UIActionSliderDelegate;
@class UIView, _UIBackdropView, _UIActionSliderKnob, UIImageView, UIPanGestureRecognizer, NSString, UIFont, _UIVibrantSettings, UIImage, UIColor, UILabel, UIBezierPath;
@interface _UIActionSlider : UIControl <UIGestureRecognizerDelegate>
@property (assign,nonatomic) double trackWidthProportion;                                    //@synthesize trackWidthProportion=_trackWidthProportion - In the implementation block
@property (assign,getter=isShowingTrackLabel,nonatomic) BOOL showingTrackLabel;              //@synthesize showingTrackLabel=_showingTrackLabel - In the implementation block
@property (assign,getter=isAnimating,nonatomic) BOOL animating;                              //@synthesize animating=_animating - In the implementation block
@property (assign,nonatomic) double cachedTrackMaskWidth;                                    //@synthesize cachedTrackMaskWidth=_cachedTrackMaskWidth - In the implementation block
@property (getter=_knobView,nonatomic,readonly) UIView * knobView;                           //@synthesize knobView=_knobView - In the implementation block
@property (nonatomic,retain) _UIVibrantSettings * vibrantSettings;                           //@synthesize vibrantSettings=_vibrantSettings - In the implementation block
@property (assign,nonatomic) long long style;                                                //@synthesize style=_style - In the implementation block
@property (assign,nonatomic) long long textStyle;                                            //@synthesize textStyle=_textStyle - In the implementation block
@property (nonatomic,retain) UIImage * knobImage; 
@property (nonatomic,retain) UIColor * knobColor; 
@property (assign,nonatomic) CGSize knobImageOffset;                                         //@synthesize knobImageOffset=_knobImageOffset - In the implementation block
@property (nonatomic,copy) NSString * trackText;                                             //@synthesize trackText=_trackText - In the implementation block
@property (nonatomic,retain) UIFont * trackFont;                                             //@synthesize trackFont=_trackFont - In the implementation block
@property (assign,nonatomic) CGSize trackSize;                                               //@synthesize trackSize=_trackSize - In the implementation block
@property (assign,nonatomic) double trackTextBaselineFromBottom;                             //@synthesize trackTextBaselineFromBottom=_trackTextBaselineFromBottom - In the implementation block
@property (nonatomic,readonly) CGRect trackTextRect; 
@property (nonatomic,retain,readonly) UILabel * trackLabel; 
@property (nonatomic,readonly) UIPanGestureRecognizer * slideGestureRecognizer;              //@synthesize slideGestureRecognizer=_slideGestureRecognizer - In the implementation block
@property (assign,nonatomic) id delegate;                    //@synthesize delegate=_delegate - In the implementation block
@property (assign,nonatomic) double knobPosition;                                            //@synthesize knobPosition=_knobPosition - In the implementation block
@property (assign,nonatomic) double knobWidth;                                               //@synthesize knobWidth=_knobWidth - In the implementation block
@property (assign,nonatomic) UIEdgeInsets knobInsets;                                        //@synthesize knobInsets=_knobInsets - In the implementation block
@property (nonatomic,readonly) CGRect knobRect; 
@property (nonatomic,readonly) UIBezierPath * knobMaskPath; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(id)delegate;
-(void)setBackgroundColor:(id)arg1 ;
-(id)initWithCoder:(id)arg1 ;
-(id)backgroundColor;
-(void)setDelegate:(id)arg1 ;
-(void)didMoveToWindow;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(BOOL)gestureRecognizerShouldBegin:(id)arg1 ;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(void)didMoveToSuperview;
-(BOOL)isAnimating;
-(void)setAnimating:(BOOL)arg1 ;
-(_UIVibrantSettings *)vibrantSettings;
-(void)setVibrantSettings:(_UIVibrantSettings *)arg1 ;
-(long long)textStyle;
-(id)_knobView;
-(UIColor *)knobColor;
-(void)setKnobColor:(UIColor *)arg1 ;
-(void)_knobPanGesture:(id)arg1 ;
-(id)initWithFrame:(CGRect)arg1 vibrantSettings:(id)arg2 ;
-(void)setCachedTrackMaskWidth:(double)arg1 ;
-(CGRect)knobRect;
-(void)_makeTrackLabel;
-(double)_knobWidth;
-(double)_knobHorizontalPosition;
-(double)_knobVerticalInset;
-(CGRect)_trackFrame;
-(double)_knobMinXInset;
-(NSString *)trackText;
-(double)trackTextBaselineFromBottom;
-(CGSize)trackSize;
-(void)_hideTrackLabel:(BOOL)arg1 ;
-(void)setTrackWidthProportion:(double)arg1 ;
-(void)_showTrackLabel;
-(void)updateAllTrackMasks;
-(double)knobWidth;
-(UIEdgeInsets)knobInsets;
-(double)_knobAvailableX;
-(double)_knobMinX;
-(double)_knobLeftMostX;
-(double)_knobRightMostX;
-(double)_knobMaxXInset;
-(double)_knobMaxX;
-(double)trackWidthProportion;
-(UIFont *)trackFont;
-(double)cachedTrackMaskWidth;
-(CGRect)trackTextRect;
-(id)trackMaskPath;
-(void)setMaskPath:(CGPathRef)arg1 onView:(id)arg2 ;
-(id)trackMaskImage;
-(void)setMaskFromImage:(id)arg1 onView:(id)arg2 ;
-(BOOL)isShowingTrackLabel;
-(void)setShowingTrackLabel:(BOOL)arg1 ;
-(void)setKnobPosition:(double)arg1 ;
-(BOOL)shouldHideTrackLabelForXPoint:(double)arg1 ;
-(BOOL)xPointIsWithinTrack:(double)arg1 ;
-(void)_slideCompleted:(BOOL)arg1 ;
-(UIBezierPath *)knobMaskPath;
-(UIImage *)knobImage;
-(void)setKnobImage:(UIImage *)arg1 ;
-(void)setKnobImageOffset:(CGSize)arg1 ;
-(void)setTrackText:(NSString *)arg1 ;
-(void)setTrackFont:(UIFont *)arg1 ;
-(void)setTrackSize:(CGSize)arg1 ;
-(UILabel *)trackLabel;
-(void)setKnobWidth:(double)arg1 ;
-(void)setKnobInsets:(UIEdgeInsets)arg1 ;
-(void)openTrackAnimated:(BOOL)arg1 ;
-(void)closeTrackAnimated:(BOOL)arg1 ;
-(void)setTextStyle:(long long)arg1 ;
-(CGSize)knobImageOffset;
-(void)setTrackTextBaselineFromBottom:(double)arg1 ;
-(UIPanGestureRecognizer *)slideGestureRecognizer;
-(double)knobPosition;
@end