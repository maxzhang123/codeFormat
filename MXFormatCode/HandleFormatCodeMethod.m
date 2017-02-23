//
//  HandleFormatCodeMethod.m
//  FormatCode
//
//  Created by Max on 2016/12/23.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "HandleFormatCodeMethod.h"

@implementation HandleFormatCodeMethod


//处理implementation之后所有的换行
- (void)handlEunnecessaryNewLine
{
    int startNumber = 0;
    int sumNumber = 0;
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *str = [_allLinesCodeMArr objectAtIndex:i];
        if ([str containsString:@"@implementation"]) {
            startNumber = i;
        }
        NSString *noSpaceStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([noSpaceStr isEqualToString:@"\n"] && startNumber > 1) {
            sumNumber++;
        }
    }
    
    BOOL hasLastNewLine = NO;
    while (sumNumber > 0) {
        for (int i = startNumber; i < _allLinesCodeMArr.count; i++) {
            NSString *str = [_allLinesCodeMArr objectAtIndex:i];
            NSString *noSpaceStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([noSpaceStr isEqualToString:@"\n"]) {
                [self mutableArrayRemoveObjectAtIndex:i];
                break;
            }
            if ([noSpaceStr isEqualToString:@"@end\n"]) {
                hasLastNewLine = YES;
            }
        }
        sumNumber--;
    }
    
    if (hasLastNewLine == NO) {
        [self.allLinesCodeMArr addObject:@"\n"];
        [self.invocation.buffer.lines addObject:@"\n"];
    }
}


//处理成第一个#import之前必须有唯一的一个换行
- (void)handleBeforeFirstImportHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *str = [_allLinesCodeMArr objectAtIndex:i];
        if ([str containsString:@"#import"]) {
            NSString *beforeString = [_allLinesCodeMArr objectAtIndex:i-1];
            if (![beforeString isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i];
            }
            else {
                int j = i - 2;
                if (j == 1) {
                    break;
                }
                NSString *beforebeforeStr = _allLinesCodeMArr[j];
                while ([beforebeforeStr isEqualToString:@"\n"]) {
                    [self mutableArrayRemoveObjectAtIndex:j];
                    j--;
                    beforebeforeStr = _allLinesCodeMArr[j];
                }
            }
            break;
        }
    }
}

//处理最后一个#import与下面代码之间仅保留一个换行
- (void)handleBetweenTheLastImportAndNextCodeHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        NSString *laterStr = [_allLinesCodeMArr objectAtIndex:i+1];
        
        if ([currentStr containsString:@"#import"] && ![laterStr containsString:@"#import"]) {
            if (![laterStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i+1];
            }
            else {
                int j = i + 2;
                if (j == _allLinesCodeMArr.count -1) {
                    break;
                }
                NSString *laterlaterStr = _allLinesCodeMArr[j];
                while ([laterlaterStr isEqualToString:@"\n"]) {
                    [self mutableArrayRemoveObjectAtIndex:j];
                    j++;
                    laterlaterStr = _allLinesCodeMArr[j];
                }
            }
            break;
        }
    }
}


//处理interface前后都有一个换行
- (void)handleBefroreInterfaceHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];

        if ([currentStr containsString:@"@interface"]) {
            
            NSString *beforeStr = [_allLinesCodeMArr objectAtIndex:i-1];
            
            if (![beforeStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i];
            }
            
            int j = i - 2;
            NSString *beforebeforeStr = _allLinesCodeMArr[j];
            
            while ([beforebeforeStr isEqualToString:@"\n"]) {
                [self mutableArrayRemoveObjectAtIndex:j];
                j--;
                beforebeforeStr = _allLinesCodeMArr[j];
            }

            
        }
    }
}



//处理interface后只有一个换行
- (void)handleLaterInterfaceHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        
        if ([currentStr containsString:@"@interface"]) {
            
            NSString *laterStr = [_allLinesCodeMArr objectAtIndex:i+1];
            
            if (![laterStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i+1];
            }
            int k = i + 2;
            NSString *laterlaterStr = _allLinesCodeMArr[k];
            
            while ([laterlaterStr isEqualToString:@"\n"]) {
                [self mutableArrayRemoveObjectAtIndex:k];
                k++;
                laterlaterStr = _allLinesCodeMArr[k];
            }
            
        }
    }
}




//处理implementation前只有一个换行
- (void)handleBefroreImplementationHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        if ([currentStr containsString:@"@implementation"]) {
            NSString *beforeStr = [_allLinesCodeMArr objectAtIndex:i-1];
            if (![beforeStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i];
            }
            int j = i - 2;
            NSString *beforebeforeStr = _allLinesCodeMArr[j];
            while ([beforebeforeStr isEqualToString:@"\n"]) {
                [self mutableArrayRemoveObjectAtIndex:j];
                j--;
                beforebeforeStr = _allLinesCodeMArr[j];
            }
        }
    }
}


//处理implementation后只有一个换行
- (void)handleLaterImplementationHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        if ([currentStr containsString:@"@implementation"]) {
            NSString *laterStr = [_allLinesCodeMArr objectAtIndex:i+1];
            if (![laterStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i+1];
            }
            int k = i + 2;
            NSString *laterlaterStr = _allLinesCodeMArr[k];
            while ([laterlaterStr isEqualToString:@"\n"]) {
                [self mutableArrayRemoveObjectAtIndex:k];
                k++;
                laterlaterStr = _allLinesCodeMArr[k];
            }
        }
    }
}




//处理end前后都有一个换行
- (void)handleBefroreEndHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        
        if ([currentStr containsString:@"@end"]) {
            
            NSString *beforeStr = [_allLinesCodeMArr objectAtIndex:i-1];
            if (![beforeStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i];
            }
            
            int j = i - 2;
            NSString *beforebeforeStr = _allLinesCodeMArr[j];
            while ([beforebeforeStr isEqualToString:@"\n"]) {
                [self mutableArrayRemoveObjectAtIndex:j];
                j--;
                beforebeforeStr = _allLinesCodeMArr[j];
            }
        }
    }
}


//处理end后只有一个换行
- (void)handleLaterEndHasOnlyOneNewLine
{
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        if ([currentStr containsString:@"@end"]) {
            if (_allLinesCodeMArr.count -1 >= i + 2) {
                NSString *laterStr = [_allLinesCodeMArr objectAtIndex:i+1];
                if (![laterStr isEqualToString:@"\n"]) {
                    [self mutableArrayInsertObject:@"\n" atIndex:i+1];
                }
                int k = i + 2;
                NSString *laterlaterStr = _allLinesCodeMArr[k];
                while ([laterlaterStr isEqualToString:@"\n"]) {
                    [self mutableArrayRemoveObjectAtIndex:k];
                    k++;
                    laterlaterStr = _allLinesCodeMArr[k];
                }
            }
        }
    }
}



//处理每个方法前仅有2个换行  处理每个方法后仅有2个换行
- (void)handleBeforeEveryMethodAndLaterEveryMethodHasOnlyTwoNewLine
{
    int methodCount = 0;
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        NSString *newStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([newStr hasPrefix:@"-("] || [newStr hasPrefix:@"+("]) {
            methodCount++;
        }
    }
    
    for (NSInteger number = 0; number < methodCount; number++) {
        [self controlBeforeEveryMethodNewLine];
    }
}


- (void)controlBeforeEveryMethodNewLine
{
    for (int i = 1; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        NSString *newStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *beforebeforeStr = nil;
        if ([newStr hasPrefix:@"-("] || [newStr hasPrefix:@"+("]) {
            
            NSLog(@"%@", newStr);
            
            NSString *beforeStr = [_allLinesCodeMArr objectAtIndex:i-1];
            beforebeforeStr = [_allLinesCodeMArr objectAtIndex:i-2];
            if (![beforeStr isEqualToString:@"\n"] && ![beforeStr hasPrefix:@"//"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i];
            }
            if (![beforebeforeStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:i];
            }
        }
    }
    
    //处理过多的换行
    for (int j = 0; j < _allLinesCodeMArr.count; j++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:j];
        NSString *newStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([newStr hasPrefix:@"-("] || [newStr hasPrefix:@"+("]) {
            int k = j - 3;
            if (k >= 1) {
                NSString *beforebeforeStr = _allLinesCodeMArr[k];
                while ([beforebeforeStr isEqualToString:@"\n"]) {
                    [self mutableArrayRemoveObjectAtIndex:k];
                    k--;
                    beforebeforeStr = _allLinesCodeMArr[k];
                }
            }
            return;
        }
    }
}


//处理每个方法开始的第一个花括号另起一行
- (void)handleMethodStartLocationTheFirstBraceNewLine
{
    int sumMethodCount = 0;
    for (int i = 0; i < _allLinesCodeMArr.count; i++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
        NSString *newCurrentStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([newCurrentStr hasPrefix:@"-("] || [newCurrentStr hasPrefix:@"+("]) {
            sumMethodCount ++;
        }
    }
    
    int methodStartIndex = 0;
    for (int number = 0; number < sumMethodCount; number++) {
        
        int k = 0;
        for (int i = methodStartIndex; i < _allLinesCodeMArr.count; i++) {
            NSString *currentStr = [_allLinesCodeMArr objectAtIndex:i];
            NSString *newCurrentStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([newCurrentStr hasPrefix:@"-("] || [newCurrentStr hasPrefix:@"+("]) {
                k = i;
            }
            
            BOOL isNeedBreak = NO;
            while ([newCurrentStr containsString:@"{"] && k > 0) {
                if ([newCurrentStr isEqualToString:@"{\n"]) { //此时{已经另起一行
                    methodStartIndex = i + 1;
                    isNeedBreak = YES;
                    break;
                }
                else if ([newCurrentStr hasSuffix:@"{\n"]) { //此时{未另起一行，但是已经在末尾
                    NSString *endNewLineStr = @"{\n";
                    NSString *exceptBraceStr = [NSString stringWithFormat:@"%@\n",[currentStr substringToIndex:currentStr.length - endNewLineStr.length]];
                    [_invocation.buffer.lines replaceObjectAtIndex:i withObject:exceptBraceStr];
                    [self mutableArrayInsertObject:@"{\n" atIndex:i+1];
                    methodStartIndex = i + 1;
                    isNeedBreak = YES;
                    break;
                }
                else if (newCurrentStr.length - @"\n".length> [newCurrentStr rangeOfString:@"{"].location) { //此时{在中间
                    NSString *beforeBraceStr = [currentStr substringToIndex:[currentStr rangeOfString:@"{"].location];
                    NSString *braceStr = @"{";
                    NSString *laterBraceStr = [currentStr substringFromIndex:[currentStr rangeOfString:@"{"].location + 1];
                    [_invocation.buffer.lines replaceObjectAtIndex:i withObject:beforeBraceStr];
                    [self mutableArrayInsertObject:braceStr atIndex:i+1];
                    [self mutableArrayInsertObject:laterBraceStr atIndex:i+2];
                    methodStartIndex = i + 3;
                    isNeedBreak = YES;
                    break;
                }
            }
            if (isNeedBreak == YES) {
                break;
            }
        }
    }
}




//处理@property属性申明时候的间距
- (void)handlePropertyLineSpaceMargin
{
    for (int number = 0; number < _allLinesCodeMArr.count; number++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:number];
        NSString *noSpaceCurrentStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([noSpaceCurrentStr hasPrefix:@"@property"]) {
            NSArray *firstComponentsArray = [noSpaceCurrentStr componentsSeparatedByString:@"("];
            NSString *exceptPropertyStr = firstComponentsArray.lastObject;
            NSString * noContainRightParenthesesStr = [exceptPropertyStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
            
            NSArray *thirdComponentsArray = [noContainRightParenthesesStr componentsSeparatedByString:@")"];
            NSString *thirdComponentsStr = thirdComponentsArray.lastObject;
            //左右小括号中间的字符串
            NSString *noContainParenthesesStr = [noContainRightParenthesesStr stringByReplacingOccurrencesOfString:thirdComponentsStr withString:@""];
            NSString *noContainParenthesesResultStr = [noContainParenthesesStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            //左右小括号中间的字符串数组
            NSArray *secondComponentsArray = [noContainParenthesesResultStr componentsSeparatedByString:@","];
            
            
            NSArray *lastComponentsArr = [currentStr componentsSeparatedByString:@")"];
            NSString *lastComponentStr = lastComponentsArr.lastObject;
            NSString *noPrefixAndSufixSpaceStr = [lastComponentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//除去首尾的空格
            NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
            [noPrefixAndSufixSpaceStr enumerateSubstringsInRange:NSMakeRange(0, noPrefixAndSufixSpaceStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) { // 遍历字符串，按字符来遍历。每个字符将通过block参数中的substring传出
                [arr addObject:substring];
            }];
            
            //属性类型字符串
            NSMutableString *typeStr = [[NSMutableString alloc] init];
            for (int i = 0; i < arr.count; i++) {
                NSString *itemStr = arr[i];
                if (![itemStr isEqualToString:@" "] && ![itemStr isEqualToString:@"*"]) {
                    [typeStr appendString:itemStr];
                }
                else {
                    break;
                }
            }
            NSString *lastlastStr = [noPrefixAndSufixSpaceStr stringByReplacingOccurrencesOfString:typeStr withString:@""];
            //属性名称字符串
            NSString *propertyNameStr = [lastlastStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            
            //处理最后拼接的字符串
            NSMutableString *resultMutableStr = [[NSMutableString alloc] initWithString:@"@property ("];
            for (int j = 0; j < secondComponentsArray.count; j++) {
                NSString *itemStr = [secondComponentsArray objectAtIndex:j];
                if (j == secondComponentsArray.count -1) {
                    [resultMutableStr appendString:[NSString stringWithFormat:@"%@) ",itemStr]];
                }
                else {
                    [resultMutableStr appendString:[NSString stringWithFormat:@"%@, ",itemStr]];
                }
            }
            [resultMutableStr appendString:[NSString stringWithFormat:@"%@ ",typeStr]];
            [resultMutableStr appendString:propertyNameStr];
            
            [self.invocation.buffer.lines replaceObjectAtIndex:number withObject:resultMutableStr.copy];
        }
        
    }
}


//处理#pragma 或者 #warning前后各空一行
- (void)handleBeforeAndLaterPragmaOrWarningHasNewLine
{
    for (int number = 0; number < _allLinesCodeMArr.count; number++) {
        NSString *currentStr = [_allLinesCodeMArr objectAtIndex:number];
        NSString *noSpaceCurrentStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([noSpaceCurrentStr hasPrefix:@"#pragma"] || [noSpaceCurrentStr hasPrefix:@"#warning"]) {
            NSString *beforeStr = [_allLinesCodeMArr objectAtIndex:number-1];
            NSString *laterStr = [_allLinesCodeMArr objectAtIndex:number+1];
            
            NSString *beforeNoSpaceStr = [beforeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *laterNoSpaceStr = [laterStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (![beforeNoSpaceStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:number];
            }

            if (![laterNoSpaceStr isEqualToString:@"\n"]) {
                [self mutableArrayInsertObject:@"\n" atIndex:number+1];
            }
        }
    }
}


#pragma mark - 增加和删除元素时候实现 allLinesCodeMArr 和 invocation.buffer.lines同步

- (void)mutableArrayInsertObject:(id)obj atIndex:(NSInteger)index
{
    [_allLinesCodeMArr insertObject:obj atIndex:index];
    [_invocation.buffer.lines insertObject:obj atIndex:index];
}


- (void)mutableArrayRemoveObjectAtIndex:(NSInteger)index
{
    [_allLinesCodeMArr removeObjectAtIndex:index];
    [_invocation.buffer.lines removeObjectAtIndex:index];
}



@end
