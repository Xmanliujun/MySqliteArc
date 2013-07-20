//
//  INUtility.h
//  PlusTimesPang
//
//  Created by kimpeng on 13-4-10.
//
//

#import <Foundation/Foundation.h>

#define IS_REQUEST_OK(result) ( ![ INUtility isNull:result ] && result.integerValue == RESULT_OK )

@interface INUtility : NSObject {
    
}


+ ( BOOL )isNull:( id )obj;

+(NSString*) getNowString:(NSString*)fmt;

+(NSString*) convertString:(NSDate*)date format:(NSString*)fmt;

+(NSDate*) convertDate:(NSString*)dateString format:(NSString*)fmt;

+(NSString*) convertString:(const char*)value;

+(const char*) convertChar:(NSString*)value;

+(NSString*)getDocumentPath;

@end

