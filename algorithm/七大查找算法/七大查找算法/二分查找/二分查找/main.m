//
//  main.m
//  二分查找
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinarySearch.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSArray *sortArray = @[@0,@0,@1,@1,@2,@4,@6,@9,@11,@12,@15,@99,@101,@360,@798];
        
        NSLog(@"index of 4 is %@",@([BinarySearch binarySearch:sortArray start:0 end:sortArray.count-1 keyObjetc:@4]));
        NSLog(@"index of 5 is %@",@([BinarySearch binarySearch:sortArray keyObjetc:@99]));
        
        NSLog(@"index of 100 is %@",@([BinarySearch binarySearch:sortArray keyObjetc:@100]));
    }
    return 0;
}
