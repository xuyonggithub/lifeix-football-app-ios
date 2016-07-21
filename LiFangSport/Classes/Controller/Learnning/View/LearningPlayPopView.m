//
//  LearningPlayPopView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"
#import "SDWebImageCompat.h"
#import "SDWebImageOperation.h"
#import "SDImageCache.h"
#import "LearningPlayPopView.h"
#import "NSString+WPAttributedMarkup.h"
#import "LearningPlayPopDeciModel.h"
#define kScreenRatioBase6IphoneHeight_popplay           (DEVICE_IS_IPAD?1.4:([[UIScreen mainScreen] bounds].size.width / 667.0))

// PNG signature bytes and data (below)
static NSData *kPNGSignatureData = nil;

@interface LearningPlayPopView ()
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIView *baseDecisionView;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *alphaBackView;
@property(nonatomic,strong)UIImage *pimg;

@end

@implementation LearningPlayPopView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    _alphaBackView = [[UIView alloc]initWithFrame:self.bounds];
    _alphaBackView.height = kScreenHeight - 110;
    _alphaBackView.centerY = self.centerY;
    _alphaBackView.backgroundColor = HEXRGBACOLOR(0xffffff,0.2);
    [self addSubview:_alphaBackView];
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 40, 40)];
    _closeBtn.top = 15;
    _closeBtn.right = self.width-30;
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn setImage:UIImageNamed(@"popclose") forState:UIControlStateNormal];
    
    [self addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

-(void)close{
    if (self.closeBc) {
        self.closeBc();
    }
    [self removeFromSuperview];
}

-(void)addSubviewOfDECISIONType:(VideoSingleInfoModel *)model {
    if (model==nil) {
        return;
    }
    if (model.isOffsideHard!=nil) {//越位高级
        [self dealUIWith:model];
    }else{//非越位或者越位普通
    _alphaBackView.hidden = NO;
    if (!_baseDecisionView) {
        _baseDecisionView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-140, kScreenHeight)];
        _baseDecisionView.center = self.center;
        _baseDecisionView.backgroundColor = kclearColor;
        [self addSubview:_baseDecisionView];
    }

    UIFont *kpoplabfont = [UIFont systemFontOfSize:18];
    UILabel *leftOneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 180, 20)];
    UIImageView *leftOnePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

    if (!model.r1) {
        return;
    }
    if (model.r1.count>0) {
    leftOnePic.right = kScreenWidth/2-30-15-20;
    leftOneLab.right = leftOnePic.left - 20;
    leftOneLab.top = (kScreenHeight -((model.r1.count-1)*30+model.r1.count*20))/2;
    leftOnePic.centerY = leftOneLab.centerY;
    leftOneLab.backgroundColor = kclearColor;
    leftOneLab.font = kpoplabfont;
    leftOneLab.textAlignment = NSTextAlignmentRight;
    leftOneLab.textColor = kwhiteColor;
    NSDictionary *oneDic = [[NSDictionary alloc]initWithDictionary:[model.r1 objectAtIndex:0]];
    leftOneLab.text= oneDic[@"text"];
    [_baseDecisionView addSubview:leftOneLab];
        
    leftOnePic.backgroundColor = kclearColor;
    leftOnePic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftOnePic];
}
    UILabel *leftTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 180, 20)];
    UIImageView *leftTwoPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

    if (model.r1.count>1) {
    leftTwoLab.top = leftOneLab.bottom +30;
    leftTwoLab.right = leftOneLab.right;
    leftTwoLab.backgroundColor = kclearColor;
    leftTwoLab.font = kpoplabfont;
    leftTwoLab.textAlignment = NSTextAlignmentRight;
    leftTwoLab.textColor = kwhiteColor;
    NSDictionary *twoDic = [[NSDictionary alloc]initWithDictionary:[model.r1 objectAtIndex:1]];
    leftTwoLab.text= twoDic[@"text"];
    [_baseDecisionView addSubview:leftTwoLab];
        
    leftTwoPic.backgroundColor = kclearColor;
    leftTwoPic.centerY = leftTwoLab.centerY;
    leftTwoPic.left = leftTwoLab.right +20;
    leftTwoPic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftTwoPic];
    }
    UILabel *leftThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 180, 20)];
    UIImageView *leftThreePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

    if (model.r1.count>2) {
        leftThreeLab.top = leftTwoLab.bottom +30;
        leftThreeLab.right = leftTwoLab.right;

        leftThreeLab.backgroundColor = kclearColor;
        leftThreeLab.font = kpoplabfont;
        leftThreeLab.textAlignment = NSTextAlignmentRight;
        leftThreeLab.textColor = kwhiteColor;
        NSDictionary *threeDic = [[NSDictionary alloc]initWithDictionary:[model.r1 objectAtIndex:2]];
        leftThreeLab.text= threeDic[@"text"];
        [_baseDecisionView addSubview:leftThreeLab];
        
        leftThreePic.backgroundColor = kclearColor;
        leftThreePic.centerY = leftThreeLab.centerY;
        leftThreePic.left = leftThreeLab.right +20;
        leftThreePic.image = UIImageNamed(@"lppopunselect");
        [_baseDecisionView addSubview:leftThreePic];
    }
    
    UILabel *leftFourLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 180, 20)];
    UIImageView *leftFourPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

    if (model.r1.count>3) {
    leftFourLab.top = leftThreeLab.bottom +30;
    leftFourLab.right = leftThreeLab.right;
    leftFourLab.backgroundColor = kclearColor;
    leftFourLab.font = kpoplabfont;
    leftFourLab.textAlignment = NSTextAlignmentRight;
    leftFourLab.textColor = kwhiteColor;
    NSDictionary *fourDic = [[NSDictionary alloc]initWithDictionary:[model.r1 objectAtIndex:3]];
    leftFourLab.text= fourDic[@"text"];
    [_baseDecisionView addSubview:leftFourLab];
        
    leftFourPic.backgroundColor = kclearColor;
    leftFourPic.centerY = leftFourLab.centerY;
    leftFourPic.left = leftFourLab.right +20;
    leftFourPic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftFourPic];

    }
    if (model.r1) {
        for (NSDictionary *dic in model.r1) {
            LearningPlayPopDeciModel *popModel = [[LearningPlayPopDeciModel alloc]initWithDictionary:dic error:nil];
            if (popModel.right == 1) {
                switch (popModel.index) {
                    case 1:
                        leftOnePic.image = UIImageNamed(@"lppopselect");
                        break;
                    case 2:
                        leftTwoPic.image = UIImageNamed(@"lppopselect");
                        break;
                    case 3:
                        leftThreePic.image = UIImageNamed(@"lppopselect");
                        break;
                    case 4:
                        leftFourPic.image = UIImageNamed(@"lppopselect");
                        break;
                    default:
                        break;
                }
            }
        }
    }
    if (model.r2==nil) {
        return;
    }
    //右
    UIImageView *rightOnePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightOnePic.backgroundColor = kclearColor;
    rightOnePic.left = leftOnePic.right +30;
    rightOnePic.top = (kScreenHeight -(model.r2.count*30+(model.r1.count-1)*20))/2;
    rightOnePic.image = UIImageNamed(@"lppopunselect");//lppopselect
    [_baseDecisionView addSubview:rightOnePic];
    
    UIImageView *rightTwoPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightTwoPic.backgroundColor = kclearColor;
    rightTwoPic.top = rightOnePic.bottom+20;
    rightTwoPic.left = leftOnePic.right +30;
    rightTwoPic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:rightTwoPic];
    
    UIImageView *rightThreePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightThreePic.backgroundColor = kclearColor;
    rightThreePic.top = rightTwoPic.bottom+20;
    rightThreePic.left = leftOnePic.right +30;
    rightThreePic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:rightThreePic];
    
    UILabel *rightOneLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 20)];
    if (model.r2.count>0) {
        rightOneLab.backgroundColor = kclearColor;
        rightOneLab.centerY = rightOnePic.centerY;
        rightOneLab.left = rightOnePic.right +20;
        rightOneLab.font = kpoplabfont;
        rightOneLab.textAlignment = NSTextAlignmentLeft;
        rightOneLab.textColor = kwhiteColor;
        NSDictionary *oneDic = [[NSDictionary alloc]initWithDictionary:[model.r2 objectAtIndex:0]];
        rightOneLab.text= oneDic[@"text"];
        [_baseDecisionView addSubview:rightOneLab];
    }

    UILabel *rightTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 20)];
    if (model.r2.count>1) {
        rightTwoLab.backgroundColor = kclearColor;
        rightTwoLab.centerY = rightTwoPic.centerY;
        rightTwoLab.left = rightOnePic.right +20;
        rightTwoLab.font = kpoplabfont;
        rightTwoLab.textAlignment = NSTextAlignmentLeft;
        rightTwoLab.textColor = kwhiteColor;
        NSDictionary *twoDic = [[NSDictionary alloc]initWithDictionary:[model.r2 objectAtIndex:1]];
        rightTwoLab.text= twoDic[@"text"];
        [_baseDecisionView addSubview:rightTwoLab];
    }
    
    UILabel *rightThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 20)];
    if (model.r2.count>2) {
        rightThreeLab.backgroundColor = kclearColor;
        rightThreeLab.centerY = rightThreePic.centerY;
        rightThreeLab.left = rightOnePic.right +20;
        rightThreeLab.font = kpoplabfont;
        rightThreeLab.textAlignment = NSTextAlignmentLeft;
        rightThreeLab.textColor = kwhiteColor;
        NSDictionary *threeDic = [[NSDictionary alloc]initWithDictionary:[model.r2 objectAtIndex:2]];
        rightThreeLab.text= threeDic[@"text"];
        [_baseDecisionView addSubview:rightThreeLab];
    }
    
    if (model.r2) {
        for (NSDictionary *dic in model.r2) {
            LearningPlayPopDeciModel *popRightModel = [[LearningPlayPopDeciModel alloc]initWithDictionary:dic error:nil];
            if (popRightModel.right == 1) {
                switch (popRightModel.index) {
                        case 1:
                        rightOnePic.image = UIImageNamed(@"lppopselect");
                        break;
                        case 2:
                        rightTwoPic.image = UIImageNamed(@"lppopselect");
                        break;
                        case 3:
                        rightThreePic.image = UIImageNamed(@"lppopselect");
                        break;
                    default:
                        break;
                }
            }
        }
    }
}
}
-(void)dealUIWith:(VideoSingleInfoModel *)model{//越位高级处理ui
    for (int i=0; i<4; i++) {
        UIView *vi = [self viewWithTag:1000+i];
        UIView *lab = [self viewWithTag:2000+i];
        [vi removeFromSuperview];
        [lab removeFromSuperview];
    }
    
    for (int i=0; i<4; i++) {
        UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 4*130*kScreenRatioBase6IphoneHeight_popplay-3*12)/2 +(130*kScreenRatioBase6IphoneHeight_popplay+12)*i, 0, 130*kScreenRatioBase6IphoneHeight_popplay, 100*kScreenRatioBase6IphoneHeight_popplay)];
        picView.tag = 1000+i;
        picView.centerY = self.centerY;
        [self addSubview:picView];
        NSDictionary *dic =(NSDictionary *) model.r1[i];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,dic[@"image"]]];
        
        if ([dic[@"right"] integerValue] == 0) {//蒙层
            [picView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
                    BOOL result = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
                    NSString* imagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
                    NSData* newData = [NSData dataWithContentsOfFile:imagePath];
                    if (!result || !newData) {
                        BOOL imageIsPng = [self ImageDataHasPNGPreffix:nil];
                        NSData* imageData = nil;
                        if (imageIsPng) {
                            imageData = UIImagePNGRepresentation(image);
                        }
                        else {
                            imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                        }
                        NSFileManager* _fileManager = [NSFileManager defaultManager];
                        if (imageData) {
                            [_fileManager removeItemAtPath:imagePath error:nil];
                            [_fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                        }
                    }
                    newData = [NSData dataWithContentsOfFile:imagePath];
                    UIImage* newImage = [UIImage imageWithData:newData];
                    
                    picView.image = [self darkenFromImage:newImage];
            }];
        }else{
            [picView sd_setImageWithURL:url];
        }
        UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 4*130*kScreenRatioBase6IphoneHeight_popplay-3*12)/2 +(130*kScreenRatioBase6IphoneHeight_popplay+12)*i, 0, 130*kScreenRatioBase6IphoneHeight_popplay, 20)];
        lab.tag = 2000+i;
        lab.top = picView.bottom +10;
        lab.backgroundColor = kclearColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:20];
        lab.text = dic[@"text"];
        [self addSubview:lab];
        lab.textColor = kwhiteColor;
        if ([dic[@"right"] integerValue] == 1) {//正确答案
            lab.textColor = [UIColor redColor];
        }
    }
}
-(void)addSubviewOfOtherType{
    _alphaBackView.hidden = YES;
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(0, 70, kScreenWidth-290, kScreenHeight-125);
        _textView.centerX = self.centerX;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        _textView.editable = NO;
        _textView.selectable = NO;
        [self addSubview:_textView];
    }
    _textView.showsVerticalScrollIndicator = YES;
}

-(void)setModel:(VideoSingleInfoModel *)model WithType:(LearningPlayPopViewType)type{
    if (model) {
        if (type==LPPOP_DECISION) {//判罚
            [self addSubviewOfDECISIONType:model];
            _baseDecisionView.hidden = NO;
            _textView.hidden = YES;
        }else{//其他
            [self addSubviewOfOtherType];
            _textView.hidden = NO;
            _baseDecisionView.hidden = YES;
            NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            contentParagraphStyle.lineSpacing = 6;
            contentParagraphStyle.alignment = NSTextAlignmentJustified;

            if (type == LPPOP_FACTORS){
                if (model.considerations!=nil) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self replaceXFrom:model.considerations] attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
                    
                    _textView.attributedText = attributedString;
                }
            }else if (type==LPPOP_DETAIL){
                if (model.explanation) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self replaceXFrom:model.explanation] attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
                    
                    _textView.attributedText = attributedString;
                }
                
            }else if (type==LPPOP_RULE){
                if (model.rule) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self replaceXFrom:model.rule] attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
                    
                    _textView.attributedText = attributedString;

                }
            }
        }
    }
}

-(NSString *)replaceXFrom:(NSString *)string{
    if (string) {
    NSMutableString *ms = [[NSMutableString alloc]initWithString:string];
    [ms replaceOccurrencesOfString:@"<p>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"</p>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
    return ms;
    }
    return nil;
}

-(UIImage *)darkenFromImage:(UIImage *)image{//蒙层效果
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)
            blendMode:kCGBlendModeDarken
                alpha:0.6];
    UIImage *highlighted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return highlighted;
}

-(BOOL)ImageDataHasPNGPreffix:(NSData *)data{
        NSUInteger pngSignatureLength = [kPNGSignatureData length];
        if ([data length] >= pngSignatureLength) {
            if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:kPNGSignatureData]) {
                return YES;
            }
        }
        return NO;
}

@end
