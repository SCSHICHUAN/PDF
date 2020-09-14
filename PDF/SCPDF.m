//
//  SCPDF.m
//  PDF
//
//  Created by Stan on 2020/9/10.
//  Copyright © 2020 pd. All rights reserved.
//

#import "SCPDF.h"
#import "PDFitem.h"
#import "PDFtoImage.h"
#import "SCDownload.h"
#import "PDFcache.h"
#define sizeK self.bounds.size


@interface SCPDF()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    int runDraw;
    UICollectionViewFlowLayout *layout;
}
@property (nonatomic,strong)UICollectionView *collectView;
@property (nonatomic,strong)UICollectionView *collectViewBig;
@property (nonatomic,strong)NSMutableArray *pdf_images;
@property (nonatomic,strong)UIViewController *vc;
@end
@implementation SCPDF
-(instancetype)initWithFrame:(CGRect)frame pdfPahth:(NSString*)path
{
    self = [super initWithFrame:frame];
    if (self) {
        [self create:path];
    }
    return self;
}
-(void)create:(NSString*)path
{
    UIView *superView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:superView];
     
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    closeBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [closeBtn setTitle:@"关闭" forState: UIControlStateNormal];
    closeBtn.frame = CGRectMake(sizeK.width-100,10,110, 30);
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = UIColor.grayColor;
    
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(60, 60);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = 1;
    
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, sizeK.height-100, sizeK.width, 100) collectionViewLayout: layout];
    [self addSubview:collectView];
    collectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    collectView.delegate = self;
    collectView.dataSource = self;
    [collectView registerClass:[PDFitem class] forCellWithReuseIdentifier:@"PDFitem"];
    _collectView = collectView;
    _pdf_images = [NSMutableArray array];
    self.hidden = YES;
    
    
    
    UICollectionViewFlowLayout *layoutBig = [[UICollectionViewFlowLayout alloc] init];
       layoutBig.itemSize = CGSizeMake(sizeK.width, sizeK.height-150);
       layoutBig.minimumLineSpacing = 0;
       layoutBig.minimumInteritemSpacing = 0;
       layoutBig.scrollDirection = 1;
    
    UICollectionView *collectViewBig = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, sizeK.width, sizeK.height-150) collectionViewLayout: layoutBig];
       [self addSubview:collectViewBig];
       collectViewBig.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
       collectViewBig.delegate = self;
       collectViewBig.dataSource = self;
       [collectViewBig registerClass:[PDFitem class] forCellWithReuseIdentifier:@"PDFitemBig"];
     collectViewBig.pagingEnabled = YES;
     _collectViewBig = collectViewBig;

    
    PDFcache *cache = [[PDFcache alloc] init];
    __weak typeof(self) weakSelf = self;
    [cache gitPDFpathWithPath:path welldone:^(NSString * _Nullable filurl) {
        [weakSelf getPath:[PDFcache GetFileName:filurl]];
   }];
   
    
}
-(void)getPath:(NSString*)filurl
{
    if (!filurl) {
        return;
    }
    //CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("test.pdf"), NULL, NULL);
//    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self->pdffile, NULL, NULL);
//    //创建CGPDFDocument对象
//    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    
    
    
    NSString *catchPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *pdf_cache_path = [catchPath stringByAppendingPathComponent:@"PDF"];
    pdf_cache_path = [pdf_cache_path stringByAppendingPathComponent:filurl];
    
    
    NSURL * url = [NSURL fileURLWithPath:pdf_cache_path];
    
    
    CFURLRef pdfURL = (__bridge CFURLRef _Nonnull)url;
    
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL(pdfURL);
    
    //获取指定页的pdf文档
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, 1);
    //获取pdf的大小
    CGRect PDF_rect =   CGPDFPageGetBoxRect(page,kCGPDFCropBox);
    
    
    runDraw = 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drowImages:pdfDocument andSize:PDF_rect];
    });
    
    
}

-(void)drowImages:(CGPDFDocumentRef)pdfRef andSize:(CGRect)rect
{
    
    
    int pageCount = (int)CGPDFDocumentGetNumberOfPages(pdfRef);
    if (pageCount == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    PDFtoImage *imagetopdf = [[PDFtoImage alloc] initWithFrame:CGRectMake(0, kscreen.height, rect.size.width, rect.size.height)];
    imagetopdf.backgroundColor = UIColor.whiteColor;
   [self addSubview:imagetopdf];
    
 
    
    [imagetopdf PDF_CGPDFDocumentRef:pdfRef andPDFpageNum:runDraw winth:^(UIImage * _Nullable image) {
        
        CGFloat left = 0;
        CGFloat with = self.collectView.frame.size.width;
        if (60*self->runDraw < with) {
            left = fabs(with/2.0 - 60*self->runDraw/2.0);
        }
        
        self->layout.sectionInset = UIEdgeInsetsMake(0, left, 0, 0);
        
        [self.pdf_images addObject:image];
        [imagetopdf removeFromSuperview];
        [self.collectView reloadData];
        [self.collectViewBig reloadData];
        
        [imagetopdf removeFromSuperview];
        if (self->runDraw<pageCount) {
            self->runDraw++;
            [weakSelf drowImages:pdfRef andSize:rect];
            
        }
    }];
}



-(void)closeClick
{
    [self removeFromSuperview];
}
#pragma mark-UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pdf_images.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDFitem *item = nil;
    if ([collectionView isEqual:self.collectView]) {
         item = [collectionView dequeueReusableCellWithReuseIdentifier:@"PDFitem" forIndexPath:indexPath];
    }else{
        item = [collectionView dequeueReusableCellWithReuseIdentifier:@"PDFitemBig" forIndexPath:indexPath];
                 
    }
     item.pdfImageView.image = self.pdf_images[indexPath.item];
    
    return item;
}

#pragma mark-UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectViewBig scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
}
-(void)showPDF
{
    self.hidden = NO;
}
#pragma mark-UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.collectViewBig]) {
         int page = (int) (scrollView.contentOffset.x /scrollView.bounds.size.width + 0.5);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
        
        [self.collectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
   
    
}
@end
