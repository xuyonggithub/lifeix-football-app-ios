//
//  VideoLearningDetCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoLearningDetCell.h"
#import "UIImageView+WebCache.h"
#import "VideoLearningUnitModel.h"
#import "VideoExerciseModel.h"

@interface VideoLearningDetCell (){
    UIImageView *playView;
}
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UIImageView *picView;

@end

@implementation VideoLearningDetCell

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //添加控件
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _picView = [[UIImageView alloc]initWithFrame:self.bounds];
    _picView.height = _picView.height - 20;
    _picView.layer.borderWidth = 1;
    _picView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _nameLab.bottom = self.height;
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = [UIColor whiteColor];
    _nameLab.font = [UIFont systemFontOfSize:12];
    
    _picView.image = [UIImage imageNamed:@"videosingleplacehoder"];
    [self addSubview:_picView];
    [self addSubview:_nameLab];
    
    playView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    playView.image = UIImageNamed(@"videobofang");
    playView.center = _picView.center;
//    playView.centerY = _picView.centerY-8;
    [self addSubview:playView];
}
-(void)layoutSubviews{
    _nameLab.bottom = self.height;
}

- (void)refreshContentWithVideoLearningUnitModel:(VideoLearningUnitModel *)model
{
    NSString *picstr = [NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.video[@"imagePath"]];
    [_picView sd_setImageWithURL:[NSURL URLWithString:picstr] placeholderImage:UIImageNamed(@"videosingleplacehoder")];
    _nameLab.text = model.title;
}

- (void)refreshContentWithVideoExerciseModel:(VideoExerciseModel *)model
{
    NSString *picstr = [NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.image];
    [_picView sd_setImageWithURL:[NSURL URLWithString:picstr] placeholderImage:UIImageNamed(@"videosingleplacehoder")];
    _nameLab.text = model.title;
}

@end
