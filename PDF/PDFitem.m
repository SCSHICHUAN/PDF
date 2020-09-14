//
//  PDFitem.m
//  PDF
//
//  Created by Stan on 2020/9/10.
//  Copyright © 2020 pd. All rights reserved.
//

#import "PDFitem.h"

@implementation PDFitem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self create];
    }
    return self;
}
-(void)create
{
    self.backgroundColor = UIColor.clearColor;
    self.pdfImageView = [[UIImageView alloc] init];
    self.pdfImageView.frame = CGRectMake(10,5, self.bounds.size.width-20, self.bounds.size.height-10);
    self.pdfImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.pdfImageView.layer.borderWidth = 0.5;
    self.pdfImageView.layer.borderColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1].CGColor;
    [self addSubview:self.pdfImageView];
    
    

}
@end
