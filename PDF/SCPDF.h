//
//  SCPDF.h
//  PDF
//
//  Created by Stan on 2020/9/10.
//  Copyright © 2020 pd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPDF : UIView
-(instancetype)initWithFrame:(CGRect)frame pdfPahth:(NSString*)path;
-(void)showPDF;
@end

NS_ASSUME_NONNULL_END
