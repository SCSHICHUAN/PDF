//
//  ViewController.m
//  PDF
//
//  Created by Stan on 2020/9/10.
//  Copyright © 2020 pd. All rights reserved.
//

#import "ViewController.h"
#import "SCPDF.h"
#import "PDFcache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    SCPDF *scpd = [[SCPDF alloc] initWithFrame:CGRectMake(10, 44, 800, [UIScreen mainScreen].bounds.size.height-100) pdfPahth: @"https://stanserver.cn/image/schttpdome/sc2.pdf"];
    scpd.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [scpd showPDF];
    [self.view addSubview:scpd];

    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
       SCPDF *scpd = [[SCPDF alloc] initWithFrame:CGRectMake(10, 44, 800, [UIScreen mainScreen].bounds.size.height-100) pdfPahth: @"https://stanserver.cn/image/schttpdome/sc.pdf"];
       scpd.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
       [scpd showPDF];
       [self.view addSubview:scpd];
}

@end
