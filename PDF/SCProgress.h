//
//  SCProgress.h
//  AFReach
//
//  Created by stan on 2020/8/27.
//  Copyright © 2020 pd. All rights reserved.
//

#ifndef SCProgress_h
#define SCProgress_h

typedef struct{
    long long    item_buffer_size;
    long long    current_buffer_size;
    long long    total_buffer_size;
}SC_Progress;
typedef void(^SCProgress)(SC_Progress  progress);

#endif /* SCProgress_h */
