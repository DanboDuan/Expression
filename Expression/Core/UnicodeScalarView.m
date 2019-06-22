//
//  UnicodeScalarView.m
//  Expression
//
//  Created by bob on 2019/4/12.
//

#import "UnicodeScalarView.h"
#import "NSString+UnicodeScalarView.h"
#import "Expression+Operator.h"
#import "SubExpression.h"
#import "EXError.h"
#import "Symbol.h"
#import "NSString+HexValue.h"
#import "UnicodeScalarRange.h"
#import "Arity.h"

static const UnicodeScalarValue UnicodeScalarsEmpty = '\0';

@interface UnicodeScalarView ()

@property (nonatomic, strong) NSString *internalScalarView; // just to hold the string for characters
@property (nonatomic, assign) UnicodeScalarValue *characters;
@property (nonatomic, assign) NSUInteger startIndex;
@property (nonatomic, assign) NSUInteger endIndex;
@property (nonatomic, assign) NSUInteger internalLength;

@end

@implementation UnicodeScalarView

+ (instancetype)scalarViewWithString:(NSString *)scalarView {
    return [[self alloc] initWithString:scalarView];
}

+ (instancetype)scalarViewWithScalarView:(UnicodeScalarView *)scalarView {
    return [[self alloc] initWithScalarView:scalarView];
}

- (instancetype)initWithString:(NSString *)scalarView {
    self = [super init];
    if (self) {
        NSString *internalScalarView = scalarView.precomposedStringWithCanonicalMapping;
        NSUInteger length = 0;
        self.internalScalarView = internalScalarView;
        self.characters = [internalScalarView UnicodeScalarValues:&length];
        self.startIndex = 0;
        self.endIndex = length;
        self.internalLength = length;
    }
    
    return self;
}

- (instancetype)initWithScalarView:(UnicodeScalarView *)scalarView {
    self = [super init];
    if (self) {
        NSString *internalScalarView = [scalarView.internalScalarView copy];
        NSUInteger length = 0;
        self.internalScalarView = internalScalarView;
        self.characters = [internalScalarView UnicodeScalarValues:&length];
        self.startIndex = scalarView.startIndex;
        self.endIndex = scalarView.endIndex;
        self.internalLength = length;
    }

    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[UnicodeScalarView allocWithZone:zone] initWithScalarView:self];
}

- (BOOL)isEmpty {
    return self.startIndex >= self.endIndex;
}

- (UnicodeScalarValue)first {
    if (self.isEmpty) {
        return UnicodeScalarsEmpty;
    }

    return self.characters[self.startIndex];
}

- (UnicodeScalarValue)last {
    if (self.isEmpty) {
        return UnicodeScalarsEmpty;
    }

    return self.characters[self.endIndex - 1];
}

- (UnicodeScalarValue)popFirst {
    if (self.isEmpty) {
        return UnicodeScalarsEmpty;
    }

    UnicodeScalarValue first = self.characters[self.startIndex];
    self.startIndex++;
    return first;
}

- (UnicodeScalarView *)dropLast {
    UnicodeScalarView *view = [UnicodeScalarView scalarViewWithScalarView:self];
    view.endIndex--;
    return view;
}

- (UnicodeScalarValue)characterAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.endIndex) {
        return UnicodeScalarsEmpty;
    }

    return self.characters[index];
}

- (NSUInteger)length {
    return self.endIndex - self.startIndex;
}

- (UnicodeScalarValue *)unicodeScalars {
    UnicodeScalarValue *scalars = (UnicodeScalarValue *)malloc(sizeof(UnicodeScalarValue) * (self.endIndex - self.startIndex));
    UnicodeScalarValue *temp = scalars;
    for (NSUInteger index = self.startIndex; index < self.endIndex; index++) {
        *temp = self.characters[index];
        temp++;
    }

    return scalars;
}

- (BOOL)contains:(UnicodeScalarValue)character {
    for (NSUInteger index = 0; index < self.internalLength; index++) {
        if (self.characters[index] == character) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)scalarsString {
    UnicodeScalarValue *unicodeScalars = self.characters + self.startIndex;
    return [NSString stringWithUnicodeScalarValues:unicodeScalars length:self.length];
}

- (NSUInteger)indexAfter:(NSUInteger)index {
    if (index < 0) {
        return 0;
    }

    if (index >= self.endIndex) {
        return self.endIndex;
    }

    return index + 1;
}

- (UnicodeScalarView *)prefix:(NSUInteger)upTo {
    UnicodeScalarView *view = [UnicodeScalarView scalarViewWithScalarView:self];
    view.endIndex = upTo;

    return view;
}

- (UnicodeScalarView *)suffix:(NSUInteger)from {
    UnicodeScalarView *view = [UnicodeScalarView scalarViewWithScalarView:self];
    view.startIndex =from;

    return view;
}

#pragma mark - scan character

- (NSString *)scanCharacters:(BOOL (^)(UnicodeScalarValue character))match {
    NSUInteger index = self.startIndex;
    while (index < self.endIndex) {
        if (!match(self.characters[index])) {
            break;
        }
        index++;
    }

    if (index > self.startIndex) {
        UnicodeScalarView *prefix = [self prefix:index];
        self.startIndex = index;

        return prefix.scalarsString;
    }

    return nil;
}

- (NSString *)scanCharacter:(BOOL (^)(UnicodeScalarValue character))match {
    UnicodeScalarValue c = self.first;

    if (!match || match(c)) {
        self.startIndex++;
        return [NSString stringWithUnicodeScalarValue:c];
    }

    return nil;
}

- (BOOL)scanCharacterWithValue:(UnicodeScalarValue)value {
    return [self scanCharacter:^BOOL(UnicodeScalarValue character) {
        return character == value;
    }] != nil;
}

- (NSString *)scanToEndOfToken {
    return [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        switch (character) {
            case ' ':
            case '\t':
            case '\n':
            case '\r':
                return NO;
            default:
                return YES;
        }
    }];
}

- (BOOL)skipWhitespace {
    return [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        switch (character) {
            case ' ':
            case '\t':
            case '\n':
            case '\r':
                return NO;
            default:
                return YES;
        }
    }] != nil;
}

#pragma mark - parseNumericLiteral

- (NSString *)scanInteger {
    return [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        return character >= '0' && character <= '9';
    }];
}

- (NSString *)scanHex {
    return [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        if (character >= '0' && character <= '9') {
            return YES;
        }
        if (character >= 'A' && character <= 'F') {
            return YES;
        }
        if (character >= 'a' && character <= 'f') {
            return YES;
        }

        return NO;
    }];
}

- (NSString *)scanExponent {
    NSUInteger startIndex = self.startIndex;
    NSString *e = [self scanCharacter:^BOOL(UnicodeScalarValue character) {
        return character == 'e' || character == 'E';
    }];
    if (e) {
        NSString *sign = [self scanCharacter:^BOOL(UnicodeScalarValue character) {
            return character == '-' || character == '+';
        }] ?: @"";
        NSString *exponent = [self scanInteger];
        if (exponent) {
            return [NSString stringWithFormat:@"%@%@%@", e, sign, exponent];
        }
    }
    self.startIndex = startIndex;

    return nil;
}

- (NSString *)scanNumber {
    NSUInteger endOfInt = self.startIndex;
    NSString *number = nil;

    NSString *integer = [self scanInteger];
    if (integer) {
        if (integer.integerValue == 0 && [self scanCharacterWithValue:'x']) {
            NSString *hex = [self scanHex] ?: @"";
            // hex return
            return [@"0x" stringByAppendingString:hex];
        }

        endOfInt = self.startIndex;
        if ([self scanCharacterWithValue:'.']) {
            NSString *fraction = [self scanInteger];
            if (fraction) {
                number = [NSString stringWithFormat:@"%@.%@", integer, fraction];
            } else {
                self.startIndex = endOfInt;
                return integer;
            }
        } else {
            number = integer;
        }
    } else if ([self scanCharacterWithValue:'.']) {
        NSString *fraction = [self scanInteger];
        if (fraction) {
            number = [NSString stringWithFormat:@".%@", fraction];
        } else {
            self.startIndex = endOfInt;
            return nil;
        }
    } else {
        return nil;
    }

    NSString *exponent = [self scanExponent];
    if (exponent) {
        number = [number stringByAppendingString:exponent];
    }

    return number;
}

#pragma mark - parseIdentifier

- (NSString *)scanIdentifier {
    NSUInteger startIndex = self.startIndex;

    NSString *identifier = @"";

    if ([self scanCharacterWithValue:'.']) {
        identifier = @".";
    } else {
        UnicodeScalarValue head = self.first;
        if ([Expression isIdentifierHead:head]) {
            self.startIndex++;
            startIndex = self.startIndex;
            identifier = [NSString stringWithUnicodeScalarValue:head];
            if ([self scanCharacterWithValue:'.']) {
                [identifier stringByAppendingString:@"."];
            }
        } else {
            return nil;
        }
    }

    NSString *tail = [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        return [Expression isIdentifier:character];
    }];
    while (tail) {
        [identifier stringByAppendingString:tail];
        startIndex = self.startIndex;
        if ([self scanCharacterWithValue:'.']) {
            [identifier stringByAppendingString:@"."];
        }
    }

    if ([identifier hasSuffix:@"."]) {
        self.startIndex = startIndex;
        if ([identifier isEqualToString:@"."]) {
            return nil;
        }
        UnicodeScalarView *identifierScalar = [identifier unicodeScalars];
        identifier = [identifierScalar dropLast].scalarsString;
    } else if ([self scanCharacterWithValue:'\'']){
        [identifier stringByAppendingString:@"\'"];
    }

    return identifier;
}

#pragma mark - parseSubeExpression

- (NSArray<SubExpression *> *)scanArguments:(UnicodeScalarValue)delimiter error:(EXError **)error {
    NSMutableArray<SubExpression *> *args = [NSMutableArray array];
    EXError *errorOut = nil;
    if (self.first != delimiter) {
        NSArray<NSString *> *delimiters = @[@",", [NSString stringWithUnicodeScalarValue:delimiter]];
        do {
            SubExpression *append = [self parseSubExpression:delimiters error:&errorOut];
            if (errorOut) {
                if (errorOut.code == EXErrorCodeUnexpectedToken && errorOut.message.length < 1) {
                    NSString *token = [self scanCharacter:nil];
                    if (token) {
                        errorOut = [EXError unexpectedToken:token];
                    }
                }
                break;
            } else {
                [args addObject:append];
            }
        } while ([self scanCharacterWithValue:',']);
    }

    if (!errorOut) {
        if (![self scanCharacterWithValue:delimiter]) {
            errorOut = [EXError missingDelimiter:[NSString stringWithUnicodeScalarValue:delimiter]];
        }
    }

    if (errorOut) {
        if (error) {
            *error = errorOut;
        }

        return nil;
    }

    return args;
}

// very very complex to read
- (void)collapseStack:(NSMutableArray<SubExpression *> *)stack from:(NSUInteger)i error:(EXError **)error {
    if (i >= stack.count - 1) {
        return;
    }
    EXError *errorOut = nil;
    SubExpression *lhs = stack[i];
    SubExpression *rhs = stack[i + 1];
    if ([lhs isOperand]) {
        if ([rhs isOperand]) {
            if (lhs.type != EXSubExpressionTypeSymbol || lhs.symbol.type != EXSymbolTypePostfix || !lhs.subs.count) {
                errorOut = [EXError unexpectedToken:rhs.description];
                if (error) {
                    *error = errorOut;
                }
                return;
            }
            NSString *op = lhs.symbol.name;
            // todo ? check subs.count?
            stack[i] = lhs.subs[0];
            SubExpression *insert = [SubExpression symbolWithSymbol:[Symbol postfix:op]
                                                               subs:@[]
                                                          evaluator:nil];
            [stack insertObject:insert atIndex:i + 1];
            return [self collapseStack:stack from:i error:error];
        }

        if (rhs.type == EXSubExpressionTypeSymbol) {
            Symbol *symbol = rhs.symbol;
            if (stack.count <= i + 2 || symbol.type == EXSymbolTypePostfix) {
                stack[i]  = [SubExpression symbolWithSymbol:[Symbol postfix:symbol.name] subs:@[lhs] evaluator:nil];
                [stack removeObjectAtIndex:i + 1];
                return [self collapseStack:stack from:0 error:error];
            }
            SubExpression *rrhs = stack[i + 2];
            if ([rrhs isOperand]) {
                if (stack.count > i + 3) {
                    SubExpression *i3 = stack[i + 3];
                    EXSymbolType type = i3.symbol.type;
                    if (type == EXSymbolTypeInfix
                        || type == EXSymbolTypePrefix
                        || type == EXSymbolTypePostfix) {
                        if (![Expression isOperator:symbol.name takesPrecedenceOver:i3.symbol.name]) {
                            return [self collapseStack:stack from:i + 2 error:error];
                        }
                    } else {
                        return [self collapseStack:stack from:i + 2 error:error];
                    }
                }

                if ([symbol.name isEqualToString:@":"]
                    && lhs.type == EXSubExpressionTypeSymbol
                    && lhs.symbol.type == EXSymbolTypeInfix
                    && [lhs.symbol.name isEqualToString:@"?"]
                    && lhs.subs.count > 1) { // ternary
                    stack[i] = [SubExpression symbolWithSymbol:[Symbol postfix:@"?:"]
                                                        subs:@[lhs.subs[0], lhs.subs[1], rrhs]
                                                     evaluator:nil];
                    [stack removeObjectAtIndex:i + 1];
                    [stack removeObjectAtIndex:i + 2];
                } else {
                    stack[i] = [SubExpression symbolWithSymbol:[Symbol postfix:symbol.name]
                                                          subs:@[lhs, rrhs]
                                                     evaluator:nil];
                    [stack removeObjectAtIndex:i + 1];
                    [stack removeObjectAtIndex:i + 2];
                }
                [self collapseStack:stack from:0 error:error];
            } else if (rrhs.type == EXSubExpressionTypeSymbol){
                Symbol *symbol2 = rrhs.symbol;
                if (symbol2.type == EXSymbolTypePrefix) {
                    [self collapseStack:stack from:i + 2 error:error];
                } else if ([@[@"+", @"/", @"*"] containsObject:symbol.name]) {
                    stack[i + 2] = [SubExpression symbolWithSymbol:[Symbol prefix:symbol2.name] subs:@[] evaluator:nil];
                    [self collapseStack:stack from:i + 2 error:error];
                } else {
                    stack[i + 1] = [SubExpression symbolWithSymbol:[Symbol postfix:symbol.name] subs:@[] evaluator:nil];
                    [self collapseStack:stack from:i error:error];
                }
            } else if (rrhs.type == EXSubExpressionTypeError) {
                errorOut = rrhs.error;
                if (error) {
                    *error = errorOut;
                }
                return;
            }
        } else if (rhs.type == EXSubExpressionTypeError) {
            errorOut = rhs.error;
            if (error) {
                *error = errorOut;
            }
            return;
        }

    } else if (lhs.type == EXSubExpressionTypeSymbol)  {
        Symbol *symbol = lhs.symbol;
        if ([rhs isOperand]) {
            stack[i] = [SubExpression symbolWithSymbol:[Symbol postfix:symbol.name] subs:@[rhs] evaluator:nil];
            [stack removeObjectAtIndex:i + 1];
            [self collapseStack:stack from:0 error:error];
        } else if (rhs.type == EXSubExpressionTypeSymbol) {
            // Nested prefix operator?
            [self collapseStack:stack from:i + 1 error:error];
        } else if (rhs.type == EXSubExpressionTypeError) {
            errorOut = rhs.error;
            if (error) {
                *error = errorOut;
            }
        }
    } else if (lhs.type == EXSubExpressionTypeError)  {
        errorOut = rhs.error;
        if (error) {
            *error = errorOut;
        }
    }
}

#pragma mark - parse

// chech whether contain any delimiter
- (BOOL)parseDelimiter:(NSArray<NSString *> *)delimiters {
    for (NSUInteger index = 0; index < delimiters.count; index++) {
        NSString *delimiter = delimiters[index];
        NSUInteger length = 0;
        UnicodeScalarValue *characters = [delimiter UnicodeScalarValues:&length];
        BOOL failedThis = NO;
        for (NSUInteger cIndex = 0; cIndex < length; cIndex++) {
            UnicodeScalarValue character =  characters[cIndex];
            UnicodeScalarValue target = self.characters[self.startIndex + cIndex];
            if (character == target) {
                continue;
            } else {
                failedThis = YES;
                break;
            }
        }
        if (failedThis) {
            // check next delimiter
            continue;
        } else {
            return YES;
        }
    }

    return NO;
}

- (SubExpression *)parseNumericLiteral {
    NSString *number = [self scanNumber];
    if (!number) {
        return nil;
    }

    NSNumberFormatter * formatter = [NSNumberFormatter new];
    NSNumber *value = nil;
    NSRange numberR = NSMakeRange(0, number.length);
    NSError *error = nil;
    BOOL success = [formatter getObjectValue:&value forString:number range:&numberR error:&error];
    if (!success || error || numberR.length != number.length) {
        return [SubExpression errorWithError:[EXError unexpectedToken:number] express:number];
    }

    return [SubExpression literalWithValue:value];
}

- (SubExpression *)parseOperator {
    NSString *op = [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        return character == '.';
    }] ?: [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        return character == '-';
    }];

    if (op) {
        NSString *tail = [self scanCharacters:^BOOL(UnicodeScalarValue character) {
            return [Expression isOperator:character];
        }];
        if (tail) {
            op = [op stringByAppendingString:tail];
        }

        return [SubExpression symbolWithSymbol:[Symbol infix:op] subs:@[] evaluator:nil];
    }

    op = [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        return [Expression isOperator:character];
    }] ?: [self scanCharacter:^BOOL(UnicodeScalarValue character) {
        return [@"([,".unicodeScalars contains:character];
    }];
    if (op) {
         return [SubExpression symbolWithSymbol:[Symbol infix:op] subs:@[] evaluator:nil];
    }

    return nil;
}

- (SubExpression *)parseIdentifier {
    NSString *identifier = [self scanIdentifier];

    if (identifier) {
        return [SubExpression symbolWithSymbol:[Symbol variable:identifier] subs:@[] evaluator:nil];
    }

    return nil;
}

- (SubExpression *)parseEscapedIdentifier {
    UnicodeScalarValue delimiter = self.first;
    NSString *s = [self scanCharacter:^BOOL(UnicodeScalarValue character) {
        return [@"`'\"".unicodeScalars contains:character];
    }];

    if (!delimiter || !s) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithString:s];

    NSString *part = [self scanCharacters:^BOOL(UnicodeScalarValue character) {
        return character != delimiter && character != '\\';
    }];

    while (part) {
        [string appendString:part];
        if ([self scanCharacterWithValue:'\\']) {
            UnicodeScalarValue c = [self popFirst];
            switch (c) {
                case '0':
                    [string appendString:@"\0"];
                    break;
                case 't':
                    [string appendString:@"\t"];
                    break;
                case 'n':
                    [string appendString:@"\n"];
                    break;
                case 'r':
                    [string appendString:@"\r"];
                    break;
                case 'u': {
                    // swift is "\\u{%X}"
                    // Objective-c is "\\u%04X"
                    NSString *hex = [self scanCharacters:^BOOL(UnicodeScalarValue character) {
                        if ((character >= '0' && character <= '9')
                            || (character >= 'A' && character <= 'F')
                            || (character >= 'a' && character <= 'f')) {
                            return YES;
                        }
                        
                        return NO;
                    }];

                    if (hex.length < 1) {
                        return [SubExpression errorWithError:[EXError unexpectedToken:@"\\u"] express:string];
                    }

                    UnicodeScalarValue codepoint = hex.hexValue;
                    if (![UnicodeScalarRange isValidateUnicode:codepoint]) {
                        // TODO: better error for invalid codepoint?
                        return [SubExpression errorWithError:[EXError unexpectedToken:hex] express:string];
                    }

                    [string appendFormat:@"%C",(unichar)codepoint];
                    break;
                }
                default:
                    [string appendFormat:@"%C",(unichar)c];
                    break;
            }
        }
        // if end
    }
    // while end
    if (![self scanCharacterWithValue:delimiter]) {
        NSString *delimiterStr = [NSString stringWithUnicodeScalarValue:delimiter];
        EXError *error = [string isEqualToString:delimiterStr] ? [EXError unexpectedToken:string] : [EXError missingDelimiter:delimiterStr];
        return [SubExpression errorWithError:error express:string];
    }
    [string appendFormat:@"%C",(unichar)delimiter];

    return [SubExpression symbolWithSymbol:[Symbol variable:string] subs:@[] evaluator:nil];;
}

- (SubExpression *)parseSubExpression:(NSArray<NSString *> *)delimiters error:(NSError **)error {
    NSMutableArray<SubExpression *> *stack = [NSMutableArray array];
    EXError *errorOut = nil;

    [self skipWhitespace];
    BOOL operandPosition = YES;
    BOOL precededByWhitespace = YES;
    while (![self parseDelimiter:delimiters]) {
        SubExpression *expression = [self parseNumericLiteral] ?: [self parseIdentifier] ?: [self parseOperator] ?: [self parseEscapedIdentifier];
        if (!expression) {
            break;
        }
        BOOL followedByWhitespace = [self skipWhitespace] || [self isEmpty];
        Symbol *symbol = expression.symbol;
        if (expression.type == EXSubExpressionTypeSymbol && symbol.type == EXSymbolTypeInfix) {
            NSString *name = symbol.name;
            SubExpression *last = stack.lastObject;
            Symbol *lastSymbol = last.symbol;

            if ([name isEqualToString:@"("]) {
                if (last.type == EXSubExpressionTypeSymbol && lastSymbol.type == EXSymbolTypeVariable) {
                    NSArray<SubExpression *> *args = [self scanArguments:')' error:&errorOut];
                    if (errorOut) {
                        break;
                    }
                    stack[stack.count - 1] = [SubExpression symbolWithSymbol:[Symbol function:lastSymbol.name arity:[Arity exactly:args.count]] subs:args evaluator:nil];
                } else if ([last isOperand]) {
                    NSArray<SubExpression *> *args = [self scanArguments:')' error:&errorOut];
                    if (errorOut) {
                        break;
                    }
                    NSMutableArray *subs = [NSMutableArray arrayWithObject:last];
                    [subs addObjectsFromArray:args];
                    stack[stack.count - 1] = [SubExpression symbolWithSymbol:[Symbol infix:@"()"] subs:subs evaluator:nil];
                } else {
                    // TODO: if we make `,` a multifix operator, we can use `scanArguments()` here instead
                    // Alternatively: add .function("()", arity: .any), as with []
                    SubExpression *add = [self parseSubExpression:@[@")"] error:&errorOut];
                    if (errorOut) {
                        break;
                    }
                    [stack addObject:add];
                    if (![self scanCharacterWithValue:')']) {
                        errorOut = [EXError missingDelimiter:@")"];
                        break;
                    }
                }

                operandPosition = NO;
                followedByWhitespace = [self skipWhitespace];
            } else if ([name isEqualToString:@","])  {
                operandPosition = YES;
                if (![last isOperand] && last.type == EXSubExpressionTypeSymbol && lastSymbol.type == EXSymbolTypeInfix) {
                    // If previous token was an infix operator, convert it to postfix
                    stack[stack.count - 1] = [SubExpression symbolWithSymbol:[Symbol postfix:lastSymbol.name] subs:@[] evaluator:nil];
                }

                operandPosition = NO;
                followedByWhitespace = [self skipWhitespace];
            } else if ([name isEqualToString:@"["])  {
                NSArray<SubExpression *> *args = [self scanArguments:']' error:&errorOut];
                if (errorOut) {
                    break;
                }

                if (last.type == EXSubExpressionTypeSymbol && lastSymbol.type == EXSymbolTypeVariable) {
                    if (args.count != 1) {
                        errorOut = [EXError arityMismatch:[Symbol array:lastSymbol.name]];
                        break;
                    }
                    stack[stack.count - 1] = [SubExpression symbolWithSymbol:[Symbol array:lastSymbol.name] subs:args evaluator:nil];
                } else if ([last isOperand]) {
                    if (args.count != 1) {
                        errorOut = [EXError arityMismatch:[Symbol infix:@"[]"]];
                        break;
                    }
                    stack[stack.count - 1] = [SubExpression symbolWithSymbol:[Symbol infix:@"[]"] subs:@[last, args[0]] evaluator:nil];
                } else {
                    SubExpression *add = [SubExpression symbolWithSymbol:[Symbol function:@"[]" arity:[Arity exactly:args.count]]
                                                                    subs:args
                                                               evaluator:nil];
                    [stack addObject:add];
                }

                operandPosition = NO;
                followedByWhitespace = [self skipWhitespace];
            } else {
                if (precededByWhitespace == followedByWhitespace) { // (true, true), (false, false
                    [stack addObject:expression];
                } else if (precededByWhitespace) { // (true, false)
                    SubExpression *add = [SubExpression symbolWithSymbol:[Symbol prefix:name] subs:@[] evaluator:nil];
                    [stack addObject:add];
                } else { // (false, true)
                    SubExpression *add = [SubExpression symbolWithSymbol:[Symbol postfix:name] subs:@[] evaluator:nil];
                    [stack addObject:add];
                }
                operandPosition = YES;
            }
        } else if (expression.type == EXSubExpressionTypeSymbol && symbol.type == EXSymbolTypeVariable && !operandPosition) {
            operandPosition = YES;
            [stack addObject:expression];
        } else {
            operandPosition = NO;
            [stack addObject:expression];
        }

        // Next iteration
        precededByWhitespace = followedByWhitespace;
    }
    // error handle
    if (errorOut) {
        if (error) {
            *error = errorOut;
        }
        return nil;
    }

    // Check for trailing junk
    NSUInteger startIndex = self.startIndex;
    if (![self parseDelimiter:delimiters]) {
        NSString *junk = [self scanToEndOfToken];
        if (junk) {
            self.startIndex = startIndex;
            errorOut = [EXError unexpectedToken:junk];
            return nil;
        }
    }
    [self collapseStack:stack from:0 error:&errorOut];
    if (errorOut) {
        if (error) {
            *error = errorOut;
        }
        return nil;
    }
    SubExpression *first = stack.firstObject;
    if (!first) {
        errorOut = [EXError emptyExpression];
    } else if (first.type == EXSubExpressionTypeError) {
        errorOut = first.error;
    } else {
        if ([first isOperand]) {
            return first;
        }
        errorOut = [EXError unexpectedToken:first.description];
    }
    if (error) {
        *error = errorOut;
    }

    return nil;
}

#pragma mark - escapedIdentifier

// Note: this is not actually part of the parser, but is colocated
// with `parseEscapedIdentifier()` because they should be updated together
- (NSString *)escapedIdentifier {
    UnicodeScalarValue delimiter = [self first];

    if (![@"`'\"".unicodeScalars contains:delimiter]) {
        return [NSString stringWithUnicodeScalarValues:[self unicodeScalars] length:self.length];
    }

    NSMutableString *result = [NSMutableString string];
    [result appendString:[NSString stringWithUnicodeScalarValue:delimiter]];
    NSUInteger index = [self indexAfter:self.startIndex];
    while (index != self.endIndex) {
        UnicodeScalarValue character = [self characterAtIndex:index];
        switch (character) {
            case 0:
                [result appendString:@"\\0"];
                break;
            case 9:
                [result appendString:@"\\t"];
                break;
            case 10:
                [result appendString:@"\\n"];
                break;
            case 13:
                [result appendString:@"\\r"];
                break;
            default:
                if (character >= 0x20 && character <= 0x7F) {
                    if ([Expression isOperator:character] || [Expression isIdentifier:character]) {
                        [result appendFormat:@"%C", (unichar)character];
                    }
                } else {
                    // swift is "\\u{%X}"
                    // Objective-c is "\\u%04X"
                    [result appendFormat:@"\\u%04X", character];
                }
                break;
        }
        index = [self indexAfter:index];
    }

    return result;
}


@end
