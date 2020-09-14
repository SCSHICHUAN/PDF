//
//  PDFcache.m
//  PDF
//
//  Created by Stan on 2020/9/11.
//  Copyright © 2020 pd. All rights reserved.
//

#import "PDFcache.h"
#import "SCDownload.h"

@interface PDFcache()
{
    URLblock urlBack;
    NSString *pdf_cache_path_data;
    NSData *dataDict;
}
@end
@implementation PDFcache
-(void)gitPDFpathWithPath:(NSString*)fileUrl welldone:(nonnull URLblock)urlBack
{
    
    self->urlBack = urlBack;
    
    NSString *key = [PDFcache GetFileName:fileUrl];
    
    NSString *catchPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSString *pdf_cache_path = [catchPath stringByAppendingPathComponent:@"PDF"];
    [fileManager createDirectoryAtPath:pdf_cache_path withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    
    pdf_cache_path_data = [pdf_cache_path stringByAppendingPathComponent:@"dict.da"];
    
    NSLog(@"pdf_cache_path_data=%@",pdf_cache_path_data);
    
    NSData *catch_data = [NSData dataWithContentsOfFile:pdf_cache_path_data];
    NSMutableDictionary *catch_dict = [NSMutableDictionary dictionary];
    /*
     NSJSONReadingMutableContainers  返回可变容器，NSMutableDictionary或NSMutableArray
     */
    if (catch_data.length>0) {
        catch_dict = [NSJSONSerialization JSONObjectWithData:catch_data options:NSJSONReadingMutableContainers error:nil];
    }
    
    NSString *cache_file_path = nil;
    @try {
        cache_file_path = catch_dict[key];
    } @catch (NSException *exception) {
        NSLog(@"开始下载pdf");
    };
    
    if (cache_file_path) {
        
        if (urlBack) {
            urlBack(cache_file_path);
        }
        
        
    }else{
        
        NSString *value = [pdf_cache_path stringByAppendingPathComponent:key];
        [catch_dict setObject:value forKey:key];
        dataDict = [NSJSONSerialization dataWithJSONObject:catch_dict options:NSJSONWritingPrettyPrinted error:nil];
        
        [self downlodPath:fileUrl catchPath:value];
        
    }
    
    
}


+(NSString*) GetFileName:(NSString*)pFile
{
    NSRange range = [pFile rangeOfString:@"/"options:NSBackwardsSearch];
    return [pFile substringFromIndex:range.location + 1];
}

-(void)downlodPath:(NSString*)downlodPath catchPath:(NSString*)catchPath
{
    
    [SCDownload DownloadPath:downlodPath withProgress:^(SC_Progress progress) {
        
        NSString *textLog = [NSString stringWithFormat:
                             @"速度:%lld, 已经下载:%lld, 总的下载数据:%lld",
                             progress.item_buffer_size,
                             progress.current_buffer_size,
                             progress.total_buffer_size];
        NSLog(@"%@",textLog);
        
    } andWellDone:^(NSURLResponse * _Nullable response, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSError *error;
        
        [manager moveItemAtPath:responseObject toPath:catchPath error:&error];
        
        if (!error) {
             [self->dataDict writeToFile:self->pdf_cache_path_data atomically:NO];
            if (self->urlBack) {
                self->urlBack(catchPath);
            }
        }
        
    } andError:^(NSError * _Nullable error) {
        
    }];
}


@end
