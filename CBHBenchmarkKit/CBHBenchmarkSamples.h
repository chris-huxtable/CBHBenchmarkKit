//  CBHBenchmarkSamples.h
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


@class CBHBenchmarkSample;
@class CBHBenchmarkDuration;


NS_ASSUME_NONNULL_BEGIN

@interface CBHBenchmarkSamples : NSObject <NSCopying>

#pragma mark - Factories

+ (nullable instancetype)samplesWithSamples:(NSArray<CBHBenchmarkSample *> *)samples;


#pragma mark - Initializers

- (nullable instancetype)initWithSamples:(NSArray<CBHBenchmarkSample *> *)samples NS_DESIGNATED_INITIALIZER;


#pragma mark - Samples

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSArray *samples;
@property (readonly, nonatomic) NSArray *sortedSamples;


#pragma mark - Max, Min, and Range

@property (readonly, nonatomic) CBHBenchmarkSample *min;
@property (readonly, nonatomic) CBHBenchmarkSample *max;
@property (readonly, nonatomic) CBHBenchmarkDuration *spread;


#pragma mark - Mean and Median

@property (readonly, nonatomic) CBHBenchmarkDuration *mean;
@property (readonly, nonatomic) CBHBenchmarkDuration *median;


#pragma mark - Variance, Standard Deviation, Standard Error

@property (readonly, nonatomic) CGFloat variance;
@property (readonly, nonatomic, nullable) CBHBenchmarkDuration *standardDeviation;
@property (readonly, nonatomic, nullable) CBHBenchmarkDuration *standardError;


#pragma mark - Description

- (NSString *)description;
- (NSString *)shortDescription;
- (NSString *)debugDescription;


#pragma mark - Unavailable

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
