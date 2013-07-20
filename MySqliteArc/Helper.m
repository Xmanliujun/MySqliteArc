//
//  Helper.m
//  PlusTimesPang
//
//  Created by kimpeng on 13-4-10.
//
//

#import "Helper.h"

@implementation Helper

+ (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
