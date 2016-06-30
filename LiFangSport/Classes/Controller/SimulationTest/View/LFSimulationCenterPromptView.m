//
//  LFSimulationCenterPromptView.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationCenterPromptView.h"

@interface LFSimulationCenterPromptView ()
{
    UIImageView *_loadImageView;
}

@end

@implementation LFSimulationCenterPromptView
#pragma mark - init
- (instancetype)initWithModel:(LFSimulationCategoryModel *)model
{
    self = [super init];
    if (self) {

        __weak typeof(self) weakSelf = self;
        
        UIImageView *bgImageView = [UIImageView new];
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kQiNiuHeaderPathPrifx,@"mobile/",model.image]]];
        [self addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        UIView *bgView= [UIImageView new];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"popclose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(ALDFullScreenVertical(20));
            make.right.equalTo(self.mas_right).offset(ALDFullScreenHorizontal(-30));
        }];
        
        _loadImageView = [UIImageView new];
        _loadImageView.animationImages = @[UIImageNamed(@"loading_00000"),
                                           UIImageNamed(@"loading_00001"),
                                           UIImageNamed(@"loading_00002"),
                                           UIImageNamed(@"loading_00003"),
                                           UIImageNamed(@"loading_00004"),
                                           UIImageNamed(@"loading_00005"),
                                           UIImageNamed(@"loading_00006"),
                                           UIImageNamed(@"loading_00007"),
                                           UIImageNamed(@"loading_00008")];
        _loadImageView.animationDuration = 1;
        _loadImageView.animationRepeatCount = 0;
        [self addSubview:_loadImageView];
        [_loadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(ALDFullScreenVertical(-20));
        }];

        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        startBtn.layer.cornerRadius = 5;
        startBtn.layer.masksToBounds = YES;
        startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        startBtn.layer.borderWidth = 1;
        [startBtn addTarget:self action:@selector(startBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        
        NSString *string = nil;
        
        if (model.subArray.count > 0) {
            startBtn.tag = 201;
            string = [model.subArray[0] text];
            
            [startBtn setTitle:[model.subArray[0] name] forState:UIControlStateNormal];
            [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.mas_centerX).offset(-90);
                make.bottom.equalTo(_loadImageView.mas_top).offset(ALDFullScreenVertical(-15));
                make.width.equalTo(@130);
                make.height.equalTo(@45);
            }];
            
            for (NSInteger i = 1; i < model.subArray.count; i++) {
                LFSimulationCategoryModel *subModel = model.subArray[i];
                UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                otherBtn.tag = 201 + i;
                otherBtn.layer.cornerRadius = 5;
                otherBtn.layer.masksToBounds = YES;
                otherBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                otherBtn.layer.borderWidth = 1;
                [otherBtn setTitle:subModel.name forState:UIControlStateNormal];
                [otherBtn addTarget:self action:@selector(startBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:otherBtn];
                
                [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(weakSelf.mas_centerX).offset(90);
                    make.bottom.equalTo(startBtn);
                    make.width.equalTo(@130);
                    make.height.equalTo(@45);
                }];
            }
        }else {
            startBtn.tag = 200;
            string = model.text;
            [startBtn setTitle:@"开始测试" forState:UIControlStateNormal];
            [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf);
                make.bottom.equalTo(_loadImageView.mas_top).offset(ALDFullScreenVertical(-15));
                make.width.equalTo(@130);
                make.height.equalTo(@45);
            }];
        }
        
        UITextView *textView = [UITextView new];
        textView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        textView.font = [UIFont systemFontOfSize:17];
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.selectable = NO;
        [self addSubview:textView];
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).offset(ALDFullScreenVertical(50));
            make.left.equalTo(weakSelf.mas_left).offset(ALDFullScreenHorizontal(140));
            make.right.equalTo(weakSelf.mas_right).offset(ALDFullScreenHorizontal(-140));
            make.bottom.equalTo(startBtn.mas_top).offset(ALDFullScreenVertical(-20));
        }];
        NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        contentParagraphStyle.lineSpacing = 6;
        contentParagraphStyle.alignment = NSTextAlignmentJustified;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
        textView.attributedText = attributedString;
    }
    return self;
}

#pragma mark - Public Methods
- (void)hiddenLoadingView
{
    [_loadImageView stopAnimating];
}

#pragma mark - Responder Methods
- (void)startBtnTouched:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_loadImageView startAnimating];
    if (self.delegate && [self.delegate respondsToSelector:@selector(promptViewStartTesting:)]) {
        [self.delegate promptViewStartTesting:btn.tag - 200];
    }
}

- (void)closeBtnTouched:(id)sender
{
    [_loadImageView stopAnimating];
    if (self.delegate && [self.delegate respondsToSelector:@selector(promptViewQuitTesting)]) {
        [self.delegate promptViewQuitTesting];
    }
}

@end
