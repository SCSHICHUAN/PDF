//
//  SCHTTP_block.h
//  AFReach
//
//  Created by stan on 2020/8/28.
//  Copyright © 2020 pd. All rights reserved.
//

#ifndef SCHTTP_block_h
#define SCHTTP_block_h

#define test     0
#define offical  1


#if test

#define host @"http://localhost:8080/travel"

#elif offical

#define host @"https://stanserver.cn/travel"

#endif

//method

#define fileMethod  @"/DaoUserXML/addUser.do"
#define jsonMethod  @"/DaoUserXML/getJsonTest.do"
#define jsonMethod2  @"/DaoUserXML/getJsonTest2.do"
 


typedef void(^WellDone)(NSURLResponse * _Nullable response, id  _Nullable responseObject);
typedef void(^Error)(NSError * _Nullable error);

#endif /* SCHTTP_block_h */
