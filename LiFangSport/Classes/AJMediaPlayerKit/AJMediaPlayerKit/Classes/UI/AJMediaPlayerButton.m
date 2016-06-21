//
//  AJMediaPlayerButton.m
//  Pods
//
//  Created by lixiang on 15/9/21.
//
//

#import "AJMediaPlayerButton.h"
#import "AJMediaPlayerUtilities.h"

@implementation AJMediaPlayerButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#29c4c6"].CGColor;
    } else {
        self.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#ffffff"].CGColor;
    }
}

@end
