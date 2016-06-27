//
//  LearningPlayPopView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningPlayPopView.h"
#import "NSString+WPAttributedMarkup.h"
#import "LearningPlayPopDeciModel.h"

@interface LearningPlayPopView ()
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIView *baseDecisionView;
@property(nonatomic,strong)UITextView *textView;//UITextView *textView = [UITextView new];

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
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 40, 40)];
    _closeBtn.top = 30;
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
}

-(void)addSubviewOfDECISIONType:(VideoSingleInfoModel *)model {
    if (!_baseDecisionView) {
        _baseDecisionView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-140, kScreenHeight-60)];
        _baseDecisionView.backgroundColor = kclearColor;
        [self addSubview:_baseDecisionView];
    }
    UIFont *kpoplabfont = [UIFont systemFontOfSize:20];
    UILabel *leftOneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftOneLab.top = (kScreenHeight -(3*30+4*20))/2;
    leftOneLab.backgroundColor = kclearColor;
    leftOneLab.font = kpoplabfont;
    leftOneLab.textAlignment = NSTextAlignmentRight;
    leftOneLab.textColor = kwhiteColor;
    leftOneLab.text= @"没有犯规";
    [_baseDecisionView addSubview:leftOneLab];
    
    UILabel *leftTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftTwoLab.top = leftOneLab.bottom +30;
    leftTwoLab.backgroundColor = kclearColor;
    leftTwoLab.font = kpoplabfont;
    leftTwoLab.textAlignment = NSTextAlignmentRight;
    leftTwoLab.textColor = kwhiteColor;
    leftTwoLab.text= @"间接任意球";
    [_baseDecisionView addSubview:leftTwoLab];
    
    UILabel *leftThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftThreeLab.top = leftTwoLab.bottom +30;
    leftThreeLab.backgroundColor = kclearColor;
    leftThreeLab.font = kpoplabfont;
    leftThreeLab.textAlignment = NSTextAlignmentRight;
    leftThreeLab.textColor = kwhiteColor;
    leftThreeLab.text= @"直接任意球";
    [_baseDecisionView addSubview:leftThreeLab];
    
    UILabel *leftFourLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftFourLab.top = leftThreeLab.bottom +30;
    leftFourLab.backgroundColor = kclearColor;
    leftFourLab.font = kpoplabfont;
    leftFourLab.textAlignment = NSTextAlignmentRight;
    leftFourLab.textColor = kwhiteColor;
    leftFourLab.text= @"点球";
    [_baseDecisionView addSubview:leftFourLab];
    
    UIImageView *leftOnePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftOnePic.backgroundColor = kclearColor;
    leftOnePic.centerY = leftOneLab.centerY;
    leftOnePic.left = leftOneLab.right +20;
    leftOnePic.image = UIImageNamed(@"lppopunselect");//lppopselect
    [_baseDecisionView addSubview:leftOnePic];
    
    UIImageView *leftTwoPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftTwoPic.backgroundColor = kclearColor;
    leftTwoPic.centerY = leftTwoLab.centerY;
    leftTwoPic.left = leftTwoLab.right +20;
    leftTwoPic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftTwoPic];
    
    UIImageView *leftThreePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftThreePic.backgroundColor = kclearColor;
    leftThreePic.centerY = leftThreeLab.centerY;
    leftThreePic.left = leftThreeLab.right +20;
    leftThreePic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftThreePic];
    
    UIImageView *leftFourPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftFourPic.backgroundColor = kclearColor;
    leftFourPic.centerY = leftFourLab.centerY;
    leftFourPic.left = leftFourLab.right +20;
    leftFourPic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftFourPic];
    //右
    UIImageView *rightOnePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightOnePic.backgroundColor = kclearColor;
    rightOnePic.left = leftOnePic.right +30;
    rightOnePic.top = (kScreenHeight -(3*30+2*20))/2;
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
    
    UILabel *rightOneLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    rightOneLab.backgroundColor = kclearColor;
    rightOneLab.centerY = rightOnePic.centerY;
    rightOneLab.left = rightOnePic.right +20;
    rightOneLab.font = kpoplabfont;
    rightOneLab.textAlignment = NSTextAlignmentLeft;
    rightOneLab.textColor = kwhiteColor;
    rightOneLab.text= @"不给牌";
    [_baseDecisionView addSubview:rightOneLab];

    UILabel *rightTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    rightTwoLab.backgroundColor = kclearColor;
    rightTwoLab.centerY = rightTwoPic.centerY;
    rightTwoLab.left = rightOnePic.right +20;
    rightTwoLab.font = kpoplabfont;
    rightTwoLab.textAlignment = NSTextAlignmentLeft;
    rightTwoLab.textColor = kwhiteColor;
    rightTwoLab.text= @"黄牌";
    [_baseDecisionView addSubview:rightTwoLab];
    
    UILabel *rightThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    rightThreeLab.backgroundColor = kclearColor;
    rightThreeLab.centerY = rightThreePic.centerY;
    rightThreeLab.left = rightOnePic.right +20;
    rightThreeLab.font = kpoplabfont;
    rightThreeLab.textAlignment = NSTextAlignmentLeft;
    rightThreeLab.textColor = kwhiteColor;
    rightThreeLab.text= @"红牌";
    [_baseDecisionView addSubview:rightThreeLab];
    
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

-(void)addSubviewOfOtherType{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(10, 0, kScreenWidth-140, kScreenHeight-60);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
        _textView.selectable = NO;
        [self addSubview:_textView];
    }
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
            NSDictionary *detstyleDic = @{@"bigFont":[UIFont systemFontOfSize:12],@"color":HEXRGBCOLOR(0x787878)};
            
            NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            contentParagraphStyle.lineSpacing = 6;
            contentParagraphStyle.alignment = NSTextAlignmentJustified;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.considerations attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
            
            _textView.attributedText = attributedString;
            if (type == LPPOP_FACTORS){
//                [_baseLab setAttributedText:[model.considerations attributedStringWithStyleBook:detstyleDic]];
//                _textView.attributedText = [model.considerations attributedStringWithStyleBook:detstyleDic];
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.considerations attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
                
                _textView.attributedText = attributedString;
            }else if (type==LPPOP_DETAIL){
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.explanation attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
                
                _textView.attributedText = attributedString;
            }else if (type==LPPOP_RULE){
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.rule attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
                
                _textView.attributedText = attributedString;
            }
        }
    }
}

@end
