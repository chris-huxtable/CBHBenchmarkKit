//  CBHBenchmarkSamples.m
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

#import "CBHBenchmarkSamples.h"

#import "CBHBenchmarkSample.h"
#import "CBHBenchmarkDuration.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHBenchmarkSamples ()
{
	NSArray<CBHBenchmarkSample *> *_samples;

	CBHBenchmarkSample *_min;
	CBHBenchmarkSample *_max;
	CBHBenchmarkDuration *_spread;

	CBHBenchmarkDuration *_mean;
	CBHBenchmarkDuration *_median;

	CGFloat _variance;
	CBHBenchmarkDuration *_standardDeviation;
	CBHBenchmarkDuration *_standardError;
}

@end

NS_ASSUME_NONNULL_END


@implementation CBHBenchmarkSamples

#pragma mark - Factories

+ (instancetype)samplesWithSamples:(NSArray<CBHBenchmarkSample *> *)samples
{
	return [[self alloc] initWithSamples:samples];
}


#pragma mark - Initializers

- (instancetype)initWithSamples:(NSArray<CBHBenchmarkSample *> *)samples
{
	if ( [samples count] <= 0 ) { return nil; }
	if ( (self = [super init]) )
	{
		_samples = [samples copy];

		_variance = NAN;
	}

	return self;
}


#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


#pragma mark - Samples

- (NSUInteger)count
{
	return [_samples count];
}

- (NSArray *)samples
{
	return _samples;
}

- (NSArray *)sortedSamples
{
	return [_samples sortedArrayUsingComparator:^(CBHBenchmarkSample *a, CBHBenchmarkSample *b){ return [a compare:b]; }];
}


#pragma mark - Max, Min, and Range

- (CBHBenchmarkSample *)min
{
	if ( _min ) { return _min; }

	// Find min by map-reduce
	CBHBenchmarkSample *min = [_samples firstObject];
	for (CBHBenchmarkSample *sample in _samples)
	{
		if ( [min compare:sample] == NSOrderedDescending ) { min = sample; }
	}

	_min = min;
	return _min;
}

- (CBHBenchmarkSample *)max
{
	if ( _max ) { return _max; }

	// Find max by map-reduce
	CBHBenchmarkSample *max = [_samples firstObject];
	for (CBHBenchmarkSample *sample in _samples)
	{
		if ( [max compare:sample] == NSOrderedAscending ) { max = sample; }
	}

	_max = max;
	return _max;
}

- (CBHBenchmarkDuration *)spread
{
	if ( _spread ) { return _spread; }

	_spread = [CBHBenchmarkDuration durationWithNanoSeconds:[[self max] nanoseconds] - [[self min] nanoseconds]];
	return _spread;
}


#pragma mark - Mean and Median

- (CBHBenchmarkDuration *)mean
{
	if ( _mean ) { return _mean; }

	NSUInteger count = [_samples count];
	if ( count <= 0 ) { return [CBHBenchmarkDuration durationWithNanoSeconds:0]; }

	uint64_t mean = 0;

	for (CBHBenchmarkSample *sample in _samples)
	{
		mean += [sample nanoseconds];
	}

	mean /= count;

	_mean = [CBHBenchmarkDuration durationWithNanoSeconds:mean];
	return _mean;
}

- (CBHBenchmarkDuration *)median
{
	if ( _median ) { return _median; }
	if ( [_samples count] == 1 )
	{
		_median = [_samples firstObject];
		return _median;
	}

	NSArray<CBHBenchmarkSample *> *samples = [_samples sortedArrayUsingSelector:@selector(compare:)];

	NSUInteger mid = (NSUInteger)floor([samples count] / 2.0);
	uint64_t median;

	if ( [samples count] % 2 == 0 )
	{
		median = (uint64_t)(([[samples objectAtIndex:mid] nanoseconds] + [[samples objectAtIndex:mid - 1] nanoseconds]) / 2.0);
	}
	else
	{
		median = [[samples objectAtIndex:mid] nanoseconds];
	}

	_median = [CBHBenchmarkDuration durationWithNanoSeconds:median];
	return _median;
}


#pragma mark - Variance, Standard Deviation, Standard Error

- (CGFloat)variance
{
	if ( !isnan(_variance) ) { return _variance; }
	if ( [_samples count] <= 1 ) return NAN;

	CGFloat variance = 0.0;
	CGFloat current = 0.0;

	CGFloat mean = [[self mean] nanoseconds];

	for (CBHBenchmarkSample *sample in _samples)
	{
		current = fabs((CGFloat)[sample nanoseconds] - mean);
		current *= current;
		variance += current;
	}

	variance /= (CGFloat)([_samples count] - 1);
	_variance = variance;
	return _variance;
}

- (CBHBenchmarkDuration *)standardDeviation
{
	if ( _standardDeviation ) { return _standardDeviation; }

	CGFloat variance = [self variance];
	if ( isnan(variance) ) { return nil; }

	_standardDeviation = [CBHBenchmarkDuration durationWithNanoSeconds:(uint64_t)sqrt(variance)];
	return _standardDeviation;
}

- (CBHBenchmarkDuration *)standardError
{
	if ( _standardError ) { return _standardError; }
	if ( ![self standardDeviation] ) { return nil; }

	_standardError = [CBHBenchmarkDuration durationWithNanoSeconds:(uint64_t)([_standardDeviation nanoseconds] / sqrt([_samples count]))];
	return _standardError;
}


#pragma mark - Description

- (NSString *)description
{
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"{"];

	[string appendString:@"\n\tSamples:                    ["];

	NSUInteger count = [_samples count];
	NSUInteger columns = (NSUInteger)ceilf(sqrtf(count));
	NSUInteger lastIndex = count - 1;

	[_samples enumerateObjectsUsingBlock:^(CBHBenchmarkSample *sample, NSUInteger idx, BOOL *stop)
	{
		if ( idx == lastIndex ) [string appendFormat:@"%lld ns", [sample nanoseconds]];
		else
		{
			[string appendFormat:@"%lld ns, ", [sample nanoseconds]];

			if ( idx % columns == columns - 1 ) [string appendString:@"\n\t                             "];
		}
	}];

	[string appendString:@"],\n"];

	[string appendFormat:@"\tNumber of Samples Taken:    %lu,\n", count];

	[string appendFormat:@"\tMin:                        %llu ns,\n", [[self min] nanoseconds]];
	[string appendFormat:@"\tMax:                        %llu ns,\n", [[self max] nanoseconds]];
	[string appendFormat:@"\tSpread:                     %llu ns,\n", [[self spread] nanoseconds]];

	[string appendFormat:@"\tMean:                       %llu ns,\n", [[self mean] nanoseconds]];
	[string appendFormat:@"\tMedian:                     %llu ns,\n", [[self median] nanoseconds]];

	[string appendFormat:@"\tVariance:                   %.2f ns^2,\n", [self variance]];
	[string appendFormat:@"\tStandard Deviation:         %llu ns,\n", [[self standardDeviation] nanoseconds]];
	[string appendFormat:@"\tStandard Error:             %llu ns\n", [[self standardError] nanoseconds]];

	[string appendString:@"}"];

	return string;
}

- (NSString *)shortDescription
{
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"{\n"];

	[string appendFormat:@"\tNumber of Samples Taken:    %lu,\n", [_samples count]];

	[string appendFormat:@"\tMin:                        %llu ns,\n", [[self min] nanoseconds]];
	[string appendFormat:@"\tMax:                        %llu ns,\n", [[self max] nanoseconds]];
	[string appendFormat:@"\tSpread:                     %llu ns,\n", [[self spread] nanoseconds]];

	[string appendFormat:@"\tMean:                       %llu ns,\n", [[self mean] nanoseconds]];
	[string appendFormat:@"\tMedian:                     %llu ns,\n", [[self median] nanoseconds]];

	[string appendFormat:@"\tVariance:                   %.2f ns^2,\n", [self variance]];
	[string appendFormat:@"\tStandard Deviation:         %llu ns,\n", [[self standardDeviation] nanoseconds]];
	[string appendFormat:@"\tStandard Error:             %llu ns\n", [[self standardError] nanoseconds]];

	[string appendString:@"}"];

	return string;
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (void *)self, [self description]];
}

@end
