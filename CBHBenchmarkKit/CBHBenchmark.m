//  CBHBenchmark.m
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

#import "CBHBenchmark.h"

#import "CBHBenchmarkSample.h"
#import "CBHBenchmarkSamples.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHBenchmark ()
{
	void (^_block)(void);
	NSUInteger _sampleCount;
	BOOL _shouldPreSample;
}


#pragma mark - Benchmarking

- (void)_preSample;

@end

NS_ASSUME_NONNULL_END


@implementation CBHBenchmark

#pragma mark - Factories

+ (CBHBenchmarkSample *)sample:(void(^)(void))block
{
	return [[[self alloc] initWithSampleCount:1 andBlock:block] sample];
}

+ (CBHBenchmarkSamples *)benchmark:(void(^)(void))block
{
	return [[[self alloc] initWithBlock:block] benchmark];
}

+ (CBHBenchmarkSamples *)benchmarkWithSampleCount:(NSUInteger)samples andBlock:(void(^)(void))block
{
	return [[[self alloc] initWithSampleCount:samples andBlock:block] benchmark];
}


#pragma mark - Initializers

- (instancetype)initWithBlock:(void(^)(void))block
{
	return [self initWithSampleCount:5 andBlock:block];
}

- (instancetype)initWithSampleCount:(NSUInteger)samples andBlock:(void(^)(void))block
{
	if ( (self = [super init]) )
	{
		_block = block;
		_sampleCount = samples;
		_shouldPreSample = YES;
	}

	return self;
}


#pragma mark - Properties

@synthesize sampleCount = _sampleCount;
@synthesize shouldPreSample = _shouldPreSample;


#pragma mark - Benchmarking

- (CBHBenchmarkSamples *)benchmark
{
	NSMutableArray *samples = [NSMutableArray arrayWithCapacity:_sampleCount];

	[self _preSample];

	for (NSUInteger n = 0; n < _sampleCount; ++n)
	{
		@autoreleasepool
		{
			[samples addObject:[self sample]];
		}
	}

	return [CBHBenchmarkSamples samplesWithSamples:samples];
}

- (CBHBenchmarkSample *)sample
{
	uint64_t duration = mach_absolute_time();

	_block();

	duration = mach_absolute_time() - duration;
	return [CBHBenchmarkSample sampleWithMachTime:duration];
}

- (void)_preSample
{
	if ( _shouldPreSample ) { _block(); }
}

@end
