//
//  PDFtoImage.h
//  PDF
//
//  Created by Stan on 2020/9/10.
//  Copyright © 2020 pd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kscreen [UIScreen mainScreen].bounds.size



typedef void(^ImageBlock)(UIImage * _Nullable image);

NS_ASSUME_NONNULL_BEGIN

@interface PDFtoImage : UIView
-(void)PDF_CGPDFDocumentRef:(CGPDFDocumentRef)pdfDocument andPDFpageNum:(int)num winth:(ImageBlock)back;
@end

NS_ASSUME_NONNULL_END
