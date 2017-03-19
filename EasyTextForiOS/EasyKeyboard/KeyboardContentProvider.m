//
//  KeyboardContentProvider.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "KeyboardContentProvider.h"
#import "TextViewFormatter.h"

#define DELAY_LENGTH 0.04


@interface NSArray (Reverse)
- (NSArray *)reversedArray;
@end

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end


@interface KeyboardContentProvider ()
@property (nonatomic, weak) id <UITextDocumentProxy>            textDocumentProxy;
@property (nonatomic, copy) void (^syncCompleted)();

@end

@implementation KeyboardContentProvider
{
    NSThread*       _dbThread;
}

+ (instancetype)sharedInstance
{
    static KeyboardContentProvider* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [KeyboardContentProvider new];
    });

    return instance;
}

- (void)syncCompleteString:(id <UITextDocumentProxy>)doc complete:(void (^)())completion {
    self.textDocumentProxy = doc;
    _curLocation = 0;
    
    self.syncCompleted = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self syncContent];
    });
}

- (void)syncContent
{
//    NSMutableArray* afterArray = [NSMutableArray arrayWithCapacity:10];
//    while (true) {
//        unsigned long afterLength = [after length];
//        if (afterLength == 0) {
//
//            if (after != nil) { //newline
//                
//                NSString* beforeTry = [proxy documentContextBeforeInput];
//                
//                [NSThread sleepForTimeInterval:DELAY_LENGTH];
//                [proxy adjustTextPositionByCharacterOffset:1];
//                [NSThread sleepForTimeInterval:DELAY_LENGTH];
//                after = [proxy documentContextAfterInput];
//                
//                NSString* tempBefore = [proxy documentContextBeforeInput];
//                if ([beforeTry isEqualToString:tempBefore] && after.length == 0) { //false try
//                    continue;
//                }
//                
//                if (tempBefore.length > 0) {
//                    [afterArray addObject:[tempBefore substringFromIndex:tempBefore.length-1]];
//                }
//                continue;
//            }
//            else
//            {
//                break;
//            }
//        }
//        
//        [afterArray addObject:after];
//        [NSThread sleepForTimeInterval:DELAY_LENGTH];
//        [proxy adjustTextPositionByCharacterOffset:afterLength];
//        [NSThread sleepForTimeInterval:DELAY_LENGTH];
//        after = [proxy documentContextAfterInput];
//        
//
//    }
//    NSString* afterStringDebug = [self getArrayString:afterArray reverse:false];

    
    id<UITextDocumentProxy> proxy = self.textDocumentProxy;
    NSString* before = [proxy documentContextBeforeInput];
    NSString* after = [proxy documentContextAfterInput];
    
    while (after != nil) {
        if (after.length == 0) {
            [proxy adjustTextPositionByCharacterOffset:1];
            [NSThread sleepForTimeInterval:DELAY_LENGTH];
            after = [proxy documentContextAfterInput];
        }
        else
        {
            [proxy adjustTextPositionByCharacterOffset:[after length]];
            [NSThread sleepForTimeInterval:DELAY_LENGTH];
            after = [proxy documentContextAfterInput];
        }
    }
    
    NSMutableArray* beforeArray = [NSMutableArray arrayWithCapacity:10];
    
    [NSThread sleepForTimeInterval:DELAY_LENGTH];
    before = [proxy documentContextBeforeInput];
    
    while (true) {
        unsigned long beforeLength = [before length];
        
        if (beforeLength == 0) {
            
            if (before != nil) { //newline maybe
                
                [proxy adjustTextPositionByCharacterOffset:-1];
                [NSThread sleepForTimeInterval:DELAY_LENGTH];
                before = [proxy documentContextBeforeInput];
                
                NSString* tempAfter = [proxy documentContextAfterInput];

                if (tempAfter.length > 0) {
                    [beforeArray addObject:[tempAfter substringToIndex:1]];
                }
                else
                {
                    [beforeArray addObject:@"\n"];
                }
                after = [proxy documentContextAfterInput];
                
                continue;
            }
            else
            {
                break;
            }
        }
        
        
        [beforeArray addObject:before];
        [proxy adjustTextPositionByCharacterOffset:-beforeLength];
        [NSThread sleepForTimeInterval:DELAY_LENGTH];
        before = [proxy documentContextBeforeInput];
    }
    
    
    NSString* beforeString = [self getArrayString:beforeArray reverse:true];
    _fullContent = [NSString stringWithFormat:@"%@", beforeString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.syncCompleted();
    });
    
    [proxy adjustTextPositionByCharacterOffset:beforeString.length];
}

- (NSString*)getArrayString : (NSArray*)array
                   reverse : (BOOL)isReverse{
    NSArray* tar = isReverse ? [array reversedArray] : array;
    NSMutableString* result = [NSMutableString stringWithCapacity:10];
    for (NSString* string in tar) {
        [result appendString:string];
    }
 
    return result;
}

- (void)handleReceivedText:(NSString*)text doc:(id <UITextDocumentProxy>)doc {
	
    self.textDocumentProxy = doc;
//    [self performSelector:@selector(handleText:) onThread:[self getTextThread] withObject:text waitUntilDone:false];
    [self handleText:text];
}

- (void)handleText:(NSString*)text
{
    TextPayload* p = [TextViewFormatter decodeTextPayloadString:text];
    if (p) {
        
//        [self syncTextContentVersion1:p];
        
        [self syncTextContentVersion2:p];
        
        //sync full content
//        _fullContent = [_fullContent stringByReplacingCharactersInRange:NSMakeRange(p.range.location, p.range.length) withString:p.text];
    }
}

- (void)syncTextContentVersion1:(TextPayload*)p
{
    //sync to target position
    NSUInteger targetPos = p.range.location+p.range.length;
    [self syncPosition:(int)targetPos];
    
    
    //delete backward
    [self deleteBackward:(int)p.range.length];
    
    
    //insert new text
    if (p.text.length > 0) {
        [_textDocumentProxy insertText:p.text];
    }
}

- (void)syncTextContentVersion2:(TextPayload*)p
{
    unsigned long newLocation = p.range.location;
    
    if (newLocation < _curLocation) {
        
        //text replacement, delete backword then insert
        //delete backward based on character, while TextPayload is based on length
        NSUInteger numberOfChars = [p.affectedText lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
        if (numberOfChars > 0) {
            [self deleteBackward:(int)numberOfChars];
        }
        else //cursor moved backward
        {
            [_textDocumentProxy adjustTextPositionByCharacterOffset:newLocation-_curLocation];
        }
    }
    else if(newLocation == _curLocation) //normal insert, no cursor movement
    {
        
    }
    else //cursor moved forward
    {
        [_textDocumentProxy adjustTextPositionByCharacterOffset:newLocation-_curLocation];
    }
    
    //insert new text
    if (p.text.length > 0) {
        [_textDocumentProxy insertText:p.text];
    }
    
    _curLocation = (int)(p.range.location + p.text.length);
}



- (void)syncPosition:(int)toPos
{
    if (toPos+1 > _fullContent.length) {
        [self moveToEnd];
        return;
    }
    
    [self moveToEnd];
    
    
    id<UITextDocumentProxy> proxy = self.textDocumentProxy;
    int curPos = (int)_fullContent.length-1;
    while (curPos >= toPos) {
        
        [proxy adjustTextPositionByCharacterOffset:-1];
        
        curPos --;
    }
}

- (void)deleteBackward:(int)count
{
    while (count > 0) {
        [_textDocumentProxy deleteBackward];
        count --;
    }
}

- (void)moveToEnd
{
    id<UITextDocumentProxy> proxy = self.textDocumentProxy;
    NSString* after = [proxy documentContextAfterInput];
    
    while (after != nil) {
        if (after.length == 0) {
            [proxy adjustTextPositionByCharacterOffset:1];
            [NSThread sleepForTimeInterval:DELAY_LENGTH];
            after = [proxy documentContextAfterInput];
        }
        else
        {
            [proxy adjustTextPositionByCharacterOffset:[after length]];
            after = [proxy documentContextAfterInput];
        }
    }
}


- (NSThread*)getTextThread
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dbThread = [[NSThread alloc] initWithTarget:self selector:@selector(dbThreadMain:) object:nil];
        [_dbThread setName:@"###text thread###"];
        [_dbThread start];
    });
    return _dbThread;
}

- (void)dbThreadMain:(id)data {
    @autoreleasepool {
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        
        while (true) {
            [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

@end
