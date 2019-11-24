//  CBHBenchmarkDuration.h
//  CBHBenchmarkKit
//
//  Created by Christian Huxtable <chris@huxtable.ca>, May 2015.
//  Copyright (c) 2015, Christian Huxtable <chris@huxtable.ca>
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

@import Foundation;


NS_ASSUME_NONNULL_BEGIN

@interface CBHBenchmarkDuration : NSObject <NSCopying>


#pragma mark - Factories

+ (instancetype)durationWithMachTime:(uint64_t)duration;

+ (instancetype)durationWithSeconds:(uint32_t)duration;
+ (instancetype)durationWithMilliSeconds:(uint64_t)duration;
+ (instancetype)durationWithMicroSeconds:(uint64_t)duration;
+ (instancetype)durationWithNanoSeconds:(uint64_t)duration;


#pragma mark - Initializers

- (instancetype)initWithMachTime:(uint64_t)duration;

- (instancetype)initWithSeconds:(uint32_t)duration;
- (instancetype)initWithMilliSeconds:(uint64_t)duration;
- (instancetype)initWithMicroSeconds:(uint64_t)duration;
- (instancetype)initWithNanoSeconds:(uint64_t)duration NS_DESIGNATED_INITIALIZER;


#pragma mark - Equality

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToDuration:(CBHBenchmarkDuration *)other;

- (NSUInteger)hash;


#pragma mark - Comparison

- (NSComparisonResult)compare:(CBHBenchmarkDuration *)other;


#pragma mark - Units

@property (nonatomic, readonly) CGFloat seconds;
@property (nonatomic, readonly) CGFloat milliseconds;
@property (nonatomic, readonly) CGFloat microseconds;
@property (nonatomic, readonly) uint64_t nanoseconds;


#pragma mark - Description

- (NSString *)description;
- (NSString *)debugDescription;


#pragma mark - Unavailable

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
