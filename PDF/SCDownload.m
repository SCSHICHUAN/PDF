//
//  SCDownload.m
//  AFReach
//
//  Created by stan on 2020/8/27.
//  Copyright © 2020 pd. All rights reserved.
//

#import "SCDownload.h"

@interface SCDownload ()
{
    SCProgress _progress;
    WellDone _wellDone;
    Error _error;
}
@end

@implementation SCDownload

+(void)DownloadPath:(NSString * _Nullable)path
       withProgress:(SCProgress _Nullable)progress
        andWellDone:(WellDone _Nullable)wellDone
           andError:(Error _Nullable)error
{
    [[[SCDownload alloc] init] downloadPath:path withProgress:progress andWellDone:wellDone andError:error];
}

-(void)downloadPath:(NSString* _Nullable)path
       withProgress:(SCProgress _Nullable)progress
        andWellDone:(WellDone _Nullable)wellDone
           andError:(Error _Nullable)error
{
    [self downe_go:path];
    _progress = progress;
    _wellDone = wellDone;
    _error    = error;
}

-(void)downe_go:(NSString*)path
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
 
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    //用requst生成DownloadTask
    NSURLSessionDownloadTask *dTask = [session downloadTaskWithRequest:req];
    [dTask setTaskDescription:@"下载文件一"];
    [dTask resume];
}



#pragma NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    id cf_downloadTask = [downloadTask valueForKey:@"downloadFile"];
    id cf_path = [cf_downloadTask valueForKey:@"path"];
    
    NSString *path = (NSString*)cf_path;
    //NSString *tagStr = downloadTask.taskDescription;
    //NSLog(@"\ntaskName=%@\n储存地址:%@",tagStr,path);
    if (_wellDone) {
        _wellDone(nil,path);
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    //NSLog(@"速度:%lld, 已经下载:%lld, 总的数据:%lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    SC_Progress pr;
    pr.item_buffer_size = bytesWritten;
    pr.current_buffer_size = totalBytesWritten;
    pr.total_buffer_size = totalBytesExpectedToWrite;
    
    if (_progress) {
        _progress(pr);
    }
    
}
#pragma mark-NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error;
{
    if (error) {
        if (_error) {
            _error(error);
        }
    }
    
}
@end
