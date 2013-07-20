//
//  INUtility.m
//  PlusTimesPang
//
//  Created by kimpeng on 13-4-10.
//
//

#import "INUtility.h"

@implementation INUtility

+ ( BOOL )isNull:( id )obj {
    if ( obj == nil )
        return YES;
    if ([ obj isEqual:[ NSNull null ]])
        return YES;
    return NO;
}

+(NSString*) getNowString:(NSString*)fmt
{
	NSDate* now = [NSDate date];
	return [INUtility convertString:now format:fmt];
}

+(NSString*) convertString:(NSDate*)date format:(NSString*)fmt {
	if (date == nil) {
		return nil;
	}
    
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	
	[formatter setDateFormat:fmt];
	
	NSString* dateString = [formatter stringFromDate:date];
	
	return dateString;
}

+(NSDate*) convertDate:(NSString*)dateString format:(NSString*)fmt {
	if (dateString == nil) {
		return nil;
	}
    
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:fmt];
	
	NSDate* formatterDate = [formatter dateFromString:dateString];
	
	return formatterDate;
}

+(NSString*) convertString:(const char*)value {
	if (value == nil) {
		return nil;
	}
	return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

+(const char*) convertChar:(NSString*)value {
	if (value == nil) {
		return nil;
	}
	
	return [value UTF8String];
}

+(NSString*)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
@end

