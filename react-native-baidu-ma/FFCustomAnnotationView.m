//
//  FFCustomAnnotationView.m
//  feifanyouwo
//
//  Created by 韩志峰 on 2017/7/17.
//  Copyright © 2017年 zhuang chaoxiao. All rights reserved.
//

#import "FFCustomAnnotationView.h"
#import "FFLoactionAnotation.h"



#define kCalloutWidth       200.0
#define kCalloutHeight      30.0


@interface FFCustomAnnotationView ()
@property (nonatomic, strong) UITapGestureRecognizer  *tapGesture;

@end


@implementation FFCustomAnnotationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customAnntionViewDidClick)];
        self.bounds = CGRectMake(0, 0, 200, 38);
        [self addChildViews];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)addChildViews{
//    [self addGestureRecognizer:self.tapGesture];
    /*
    [self addSubview:self.callOutView];
    [self.callOutView addSubview:self.titleLabel];
     */
    
    [self addSubview:self.imageView];
    self.imageView.frame = CGRectMake(0, 0, 100, 38);
    [self.imageView addSubview:self.titleLabel];
    
    self.clipsToBounds = 0;
    self.imageView.clipsToBounds = 0;
}
/*
 self.callOutView = [[CallOutView alloc] initWithFrame:CGRectMake(10, 10, 200, 34)];
 */
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}
- (CallOutView *)callOutView{
    if (!_callOutView) {
        _callOutView = [[CallOutView alloc] init];
        _callOutView.userInteractionEnabled = YES;
        _callOutView.backgroundColor = [UIColor clearColor];
    }
    return _callOutView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"blue" ofType:@"png"];
//        _imageView.image = [self fixImage:[UIImage imageNamed:@"red"] oriImageSize:CGSizeMake(71, 33) targetSize:self.bounds.size];//[UIImage imageWithContentsOfFile:path];
//        _imageView.image = [UIImage imageNamed:@"red"];
    }
    return _imageView;
}
- (void)customAnntionViewDidClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customViewDidSelected:annotationView:)]) {
        [self.delegate customViewDidSelected:self.annotation annotationView:self];
    }
}
- (void)updateCustomAnnotationView:(FFLoactionAnotation *)annotation{
    self.annotation = annotation;
    self.titleLabel.text = annotation.title;
    self.callOutView.click = annotation.selected ? YES : NO;
    [self.titleLabel sizeToFit];
    
    CGFloat h = self.titleLabel.bounds.size.height + 3 + 7;
    if (h < 38) {
        h = 38;
    }
    self.bounds = CGRectMake(0, 0, self.titleLabel.bounds.size.width + 30, h);
    /*
    self.callOutView.frame = CGRectMake(0, 0, width + 20, 34);
    self.titleLabel.frame = CGRectMake(3, -2, width + 20, 34);
    [self setNeedsDisplay];
    */
//    if (annotation.selected) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"];
//        self.imageView.image = [self fixImage:[UIImage imageNamed:@"red"] oriImageSize:CGSizeMake(71, 33) targetSize:self.bounds.size];//[UIImage imageWithContentsOfFile:path];
//    }else{
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"]; // blue
//        self.imageView.image = [self fixImage:[UIImage imageNamed:@"blue"] oriImageSize:CGSizeMake(71, 33) targetSize:self.bounds.size];//[UIImage imageWithContentsOfFile:path];
//    }
    
    self.imageView.frame = CGRectMake(15, 0, self.bounds.size.width - 30, self.bounds.size.height);
    
    CGSize size = self.titleLabel.bounds.size;
    self.titleLabel.frame = CGRectMake(0, 6, size.width, size.height);
}

- (void)upDateWithSelectState:(BOOL)isSelect{
    return;
    if (isSelect) {
//        self.imageView.image = [self fixImage:[UIImage imageNamed:@"red"] oriImageSize:CGSizeMake(71, 33) targetSize:self.bounds.size];
        self.imageView.image = [UIImage imageNamed:@"red"];
    }else{
//        self.imageView.image = [self fixImage:[UIImage imageNamed:@"red"] oriImageSize:CGSizeMake(71, 33) targetSize:self.bounds.size]; // blue
        self.imageView.image = [UIImage imageNamed:@"my_location"];
    }
}

- (UIImage *)fixImage:(UIImage *)image oriImageSize:(CGSize)oriSize targetSize:(CGSize)targetSize{
    UIImage *temp = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, oriSize.width - 11) resizingMode:UIImageResizingModeStretch];
    
    CGFloat tempWidth = targetSize.width/2+oriSize.width/2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, targetSize.height), NO, 1);
    [temp drawInRect:CGRectMake(0, 0, tempWidth, targetSize.height)];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [newImg resizableImageWithCapInsets:UIEdgeInsetsMake(10, tempWidth - 11, 20, 10) resizingMode:UIImageResizingModeStretch];
}


#define leftPading 15
#define topPading 0
- (void)drawRect:(CGRect)rect
{

    NSLog(@"绘画的区域 = %@",NSStringFromCGRect(rect));


    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, leftPading, topPading);
    CGContextAddLineToPoint(context, self.frame.size.width - leftPading, topPading);
    CGContextAddArc(context, self.frame.size.width - leftPading, leftPading, leftPading, -M_PI_2, M_PI_2, NO);
    CGContextAddLineToPoint(context, self.frame.size.width * 0.5 + 5, 2 *leftPading);
    CGContextAddLineToPoint(context, self.frame.size.width * 0.5, 2 * leftPading + 8);
    CGContextAddLineToPoint(context, self.frame.size.width * 0.5 - 5, 2 *leftPading);
    CGContextAddLineToPoint(context, leftPading, 2 *leftPading);
    CGContextAddArc(context, leftPading, leftPading, leftPading, M_PI_2, -M_PI_2, NO);
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
//    if (self.click) {
        UIColor *notSelectColor =  [UIColor redColor];//[UIColor colorWithHexString:@"00b06f"];
        [notSelectColor set];
//    }else{
//        UIColor *notSelectColor =  [UIColor greenColor];//[UIColor colorWithHexString:@"fd784c"];
//        [notSelectColor set];
//    }
    CGContextFillPath(context);




}


@end
