@protocol _UIActionSliderDelegate <NSObject>
@optional
-(void)actionSlider:(id)arg1 didUpdateSlideWithValue:(double)arg2;
-(void)actionSliderDidCompleteSlide:(id)arg1;
-(void)actionSliderDidCancelSlide:(id)arg1;
-(void)actionSliderDidBeginSlide:(id)arg1;
@end