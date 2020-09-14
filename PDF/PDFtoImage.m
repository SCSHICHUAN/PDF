//
//  PDFtoImage.m
//  PDF
//
//  Created by Stan on 2020/9/10.
//  Copyright © 2020 pd. All rights reserved.
//

#import "PDFtoImage.h"
#define sizeK self.bounds.size

@interface PDFtoImage()
{
    ImageBlock imageBlock;
    int num;
    CGPDFDocumentRef pdfDocument;
    CGRect PDFrect;
    int oldNum;
}

@end
@implementation PDFtoImage


-(void)PDF_CGPDFDocumentRef:(CGPDFDocumentRef)pdfDocument andPDFpageNum:(int)num winth:(ImageBlock)back
{
    
    self->pdfDocument = pdfDocument;
    self->num = num;
    self->imageBlock = back;
}

-(void)drawRect:(CGRect)rect
{
    
    //获取指定页的pdf文档
    CGPDFPageRef page = CGPDFDocumentGetPage(self->pdfDocument, self->num);
    //获取pdf的大小
    CGRect PDF_rect =   CGPDFPageGetBoxRect(page,kCGPDFCropBox);
    //创建一个仿射变换，该变换基于将PDF页的BOX映射到指定的矩形中。
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, PDF_rect, 0, true);
   
    
    //获取当前的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Quartz坐标系和UIView坐标系不一样所致，调整坐标系，使pdf正立
    CGContextTranslateCTM(context, 0.0,PDF_rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextConcatCTM(context, pdfTransform);
    //将pdf绘制到上下文中
    CGContextDrawPDFPage(context, page);
//    CGPDFPageRelease(page);
    
    
    [self performSelector:@selector(creatImage) withObject:nil afterDelay:0];
    self->PDFrect = PDF_rect;
}

- (void)creatImage
{
   
    CGSize boundsSize =CGSizeMake(self->PDFrect.size.width, self->PDFrect.size.height);
    
    UIGraphicsBeginImageContext(boundsSize);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(self->imageBlock)
    {
        self->imageBlock(image);
    }
    
}




@end
