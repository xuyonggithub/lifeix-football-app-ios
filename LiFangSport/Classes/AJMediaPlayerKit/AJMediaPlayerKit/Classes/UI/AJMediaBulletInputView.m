//
//  AJMediaBulletInputView.m
//  Pods
//
//  Created by tianzhuo on 2/24/16.
//
//

#import "AJMediaBulletInputView.h"
#import "AJMediaPlayerUtilities.h"

#define kMaxMessageCount (50)  // 最大消息数

@interface AJMediaBulletInputView()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic ,strong) NSMutableArray *constraintsList;
@property (nonatomic, strong) NSDictionary *subViewsDictionary;

@end

@implementation AJMediaBulletInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setImage:[UIImage imageNamed:@"bullet_cancel_ic_"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"bullet_cancel_ic_click"] forState:UIControlStateSelected];
        [_cancelButton setImage:[UIImage imageNamed:@"bullet_cancel_ic_click"] forState:UIControlStateHighlighted];
        [self addSubview:_cancelButton];
        
        _textField = [[UITextField alloc] init];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.textColor = [UIColor colorWithHTMLColorMark:@"#999999"];
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
        NSString *placeholder = @"我的弹幕";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:placeholder];
        NSRange range = NSMakeRange(0, string.length);
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHTMLColorMark:@"#999999" alpha:0.8] range:range];
        _textField.attributedPlaceholder = string;
        [self addSubview:_textField];
        
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.backgroundColor = [UIColor colorWithHTMLColorMark:@"#ffffff" alpha:0.2f];
        _backgroundView.layer.cornerRadius = 2.f;
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithHTMLColorMark:@"#999999"] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_sendButton];
        
        _constraintsList = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithHTMLColorMark:@"#000000" alpha:0.6f];
        _subViewsDictionary = NSDictionaryOfVariableBindings(_cancelButton, _textField, _backgroundView, _sendButton);
    }
    return self;
}

- (void)updateConstraints
{
    [self removeConstraints:_constraintsList];
    [_constraintsList removeAllObjects];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[_cancelButton(22)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cancelButton(22)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_cancelButton
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                              constant:0]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cancelButton]-24-[_backgroundView(==_textField)]-10-[_sendButton]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backgroundView(33)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:_subViewsDictionary]];
    [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_backgroundView
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1
                                                              constant:0]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cancelButton]-32-[_textField]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textField(33)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_textField
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1
                                                              constant:0]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sendButton(66)]-10-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sendButton(33)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:_subViewsDictionary]];
    [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_sendButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1
                                                              constant:0]];
    [self addConstraints:_constraintsList];
    [super updateConstraints];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldInput = NO;
    if ([textField markedTextRange]) {
        shouldInput = YES;
    } else {
        NSUInteger maxCount = range.location + range.length;
        if (kMaxMessageCount < textField.text.length ||
            (kMaxMessageCount == maxCount && string.length) ||
            kMaxMessageCount < maxCount) {
            shouldInput = NO;
        } else {
            shouldInput = YES;
        }
    }
    return shouldInput;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (kMaxMessageCount < textField.text.length) {
        textField.text = [textField.text substringToIndex:kMaxMessageCount];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([_delegate respondsToSelector:@selector(bulletInputView:didReturnMessage:)]) {
        [_delegate bulletInputView:self didReturnMessage:textField.text];
    }
    textField.text = nil;
    return YES;
}

@end
