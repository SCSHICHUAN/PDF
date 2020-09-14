//
//  SCDownload.h
//  AFReach
//
//  Created by stan on 2020/8/27.
//  Copyright © 2020 pd. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SCProgress.h"
#include "SCHTTP_block.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDownload : NSObject<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

-(void)downloadPath:(NSString* _Nullable)path
       withProgress:(SCProgress _Nullable)progress
        andWellDone:(WellDone _Nullable)wellDone
           andError:(Error _Nullable)error;

+(void)DownloadPath:(NSString* _Nullable)path
       withProgress:(SCProgress _Nullable)progress
        andWellDone:(WellDone _Nullable)wellDone
           andError:(Error _Nullable)error;
@end

NS_ASSUME_NONNULL_END
