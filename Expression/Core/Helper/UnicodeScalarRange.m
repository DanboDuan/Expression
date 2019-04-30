//
//  UnicodeScalarRange.m
//  Expression
//
//  Created by bob on 2019/4/26.
//

#import "UnicodeScalarRange.h"

// large code to keep

@implementation UnicodeScalarRange

+ (BOOL)isInOperatorRange:(UnicodeScalarValue)character {
    if (character >= 0x00A1 && character <= 0x00A7) {
        return YES;
    }

    if (character == 0x00A9
        || character == 0x00AB
        || character == 0x00AC
        || character == 0x00AE) {
        return YES;
    }

    if (character == 0x00B0
        || character == 0x00B1
        || character == 0x00B6
        || character == 0x00BB
        || character == 0x00BF
        || character == 0x00D7
        || character == 0x00F7) {
        return YES;
    }

    if (character == 0x2016
        || character == 0x2017) {
        return YES;
    }

    if (character >= 0x2020 && character <= 0x2027) {
        return YES;
    }

    if (character >= 0x2030 && character <= 0x203E) {
        return YES;
    }
    if (character >= 0x2041 && character <= 0x2053) {
        return YES;
    }

    if (character >= 0x2055 && character <= 0x205E) {
        return YES;
    }

    if (character >= 0x2190 && character <= 0x23FF) {
        return YES;
    }

    if (character >= 0x2500 && character <= 0x2775) {
        return YES;
    }

    if (character >= 0x2794 && character <= 0x2BFF) {
        return YES;
    }

    if (character >= 0x2E00 && character <= 0x2E7F) {
        return YES;
    }

    if (character == 0x3001 ||  character == 0x3002 ||  character == 0x3003) {
        return YES;
    }

    if (character >= 0x3008 && character <= 0x3030) {
        return YES;
    }

    return NO;
}

+ (BOOL)isInIdentifierHeadRange:(UnicodeScalarValue)character {
    // _ # $ @
    if (character == 0x5F
        || character == 0x23
        || character == 0x24
        || character == 0x40) {
        return YES;
    }

    // A-Z
    if (character >= 0x41 && character <= 0x5A) {
        return YES;
    }

    // a-z
    if (character >= 0x61 && character <= 0x7A) {
        return YES;
    }

    if (character == 0x00A8
        || character == 0x00AA
        || character == 0x00AD
        || character == 0x00AF) {
        return YES;
    }

    if (character >= 0x00B2 && character <= 0x00B5) {
        return YES;
    }

    if (character >= 0x00B7 && character <= 0x00BA) {
        return YES;
    }

    if (character >= 0x00BC && character <= 0x00BE) {
        return YES;
    }

    if (character >= 0x00C0 && character <= 0x00D6) {
        return YES;
    }
    if (character >= 0x00D8 && character <= 0x00F6) {
        return YES;
    }
    if (character >= 0x00F8 && character <= 0x00FF) {
        return YES;
    }
    if (character >= 0x0100 && character <= 0x02FF) {
        return YES;
    }
    if (character >= 0x0370 && character <= 0x167F) {
        return YES;
    }
    if (character >= 0x1681 && character <= 0x180D) {
        return YES;
    }
    if (character >= 0x180F && character <= 0x1DBF) {
        return YES;
    }
    if (character >= 0x1E00 && character <= 0x1FFF) {
        return YES;
    }
    if (character >= 0x200B && character <= 0x200D) {
        return YES;
    }
    if (character >= 0x202A && character <= 0x202E) {
        return YES;
    }
    if (character >= 0x203F && character <= 0x2040) {
        return YES;
    }

    if (character == 0x2054) {
        return YES;
    }

    if (character >= 0x2060 && character <= 0x206F){
        return YES;
    }
    if (character >= 0x2070 && character <= 0x20CF){
        return YES;
    }
    if (character >= 0x2100 && character <= 0x218F){
        return YES;
    }
    if (character >= 0x2460 && character <= 0x24FF){
        return YES;
    }
    if (character >= 0x2776 && character <= 0x2793){
        return YES;
    }
    if (character >= 0x2C00 && character <= 0x2DFF){
        return YES;
    }
    if (character >= 0x2E80 && character <= 0x2FFF){
        return YES;
    }
    if (character >= 0x3004 && character <= 0x3007){
        return YES;
    }
    if (character >= 0x3021 && character <= 0x302F){
        return YES;
    }
    if (character >= 0x3031 && character <= 0x303F){
        return YES;
    }
    if (character >= 0x3040 && character <= 0xD7FF){
        return YES;
    }
    if (character >= 0xF900 && character <= 0xFD3D){
        return YES;
    }
    if (character >= 0xFD40 && character <= 0xFDCF){
        return YES;
    }
    if (character >= 0xFDF0 && character <= 0xFE1F){
        return YES;
    }
    if (character >= 0xFE30 && character <= 0xFE44){
        return YES;
    }
    if (character >= 0xFE47 && character <= 0xFFFD){
        return YES;
    }
    if (character >= 0x10000 && character <= 0x1FFFD){
        return YES;
    }
    if (character >= 0x20000 && character <= 0x2FFFD){
        return YES;
    }
    if (character >= 0x30000 && character <= 0x3FFFD){
        return YES;
    }
    if (character >= 0x40000 && character <= 0x4FFFD){
        return YES;
    }
    if (character >= 0x50000 && character <= 0x5FFFD){
        return YES;
    }
    if (character >= 0x60000 && character <= 0x6FFFD){
        return YES;
    }
    if (character >= 0x70000 && character <= 0x7FFFD){
        return YES;
    }
    if (character >= 0x80000 && character <= 0x8FFFD){
        return YES;
    }
    if (character >= 0x90000 && character <= 0x9FFFD){
        return YES;
    }
    if (character >= 0xA0000 && character <= 0xAFFFD){
        return YES;
    }
    if (character >= 0xB0000 && character <= 0xBFFFD){
        return YES;
    }
    if (character >= 0xC0000 && character <= 0xCFFFD){
        return YES;
    }
    if (character >= 0xD0000 && character <= 0xDFFFD){
        return YES;
    }
    if (character >= 0xE0000 && character <= 0xEFFFD){
        return YES;
    }

    return NO;
}

+ (BOOL)isInIdentifierRange:(UnicodeScalarValue)character {
    // 0-9
    if (character >= 0x30 && character <= 0x39){
        return YES;
    }
    if (character >= 0x0300 && character <= 0x036F){
        return YES;
    }
    if (character >= 0x1DC0 && character <= 0x1DFF){
        return YES;
    }
    if (character >= 0x20D0 && character <= 0x20FF){
        return YES;
    }
    if (character >= 0xFE20 && character <= 0xFE2F){
        return YES;
    }

    return [self isInIdentifierHeadRange:character];
}

+ (BOOL)isValidateUnicode:(UnicodeScalarValue)character {
    if (character >= 0x00 && character <= 0xD7FF){
        return YES;
    }
    //U D800到U DFFF范围是surrogate pairs
    if (character >= 0xE000 && character <= 0x10FFFF){
        return YES;
    }

    return NO;
}

@end
