//
//  TextViewFormatter.h
//  EasyText
//
//  Created by gao feng on 2016/10/22.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextPayload : NSObject
@property (nonatomic, strong) NSString*                 centralID;
@property (nonatomic, strong) NSString*                 text;
@property (nonatomic, assign) NSRange                   range;
@property (nonatomic, strong) NSString*                 affectedText;


@end

@interface TextViewFormatter : NSObject

+ (NSString*)encodeTextPayload:(TextPayload*)payload;
+ (TextPayload*)decodeTextPayloadString:(NSString*)str;

@end
