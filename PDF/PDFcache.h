//
//  PDFcache.h
//  PDF
//
//  Created by Stan on 2020/9/11.
//  Copyright © 2020 pd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^URLblock)(NSString * _Nullable filurl);

NS_ASSUME_NONNULL_BEGIN

@interface PDFcache : NSObject
+(NSString*) GetFileName:(NSString*)pFile;
-(void)gitPDFpathWithPath:(NSString*)fileUrl welldone:(URLblock)urlBack;
@end

NS_ASSUME_NONNULL_END
