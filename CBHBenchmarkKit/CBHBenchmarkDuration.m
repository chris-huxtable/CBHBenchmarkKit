//  CBHBenchmarkDuration.m
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

#import "CBHBenchmarkDuration.h"

#import <mach/mach_time.h>


NS_ASSUME_NONNULL_BEGIN

static mach_timebase_info_data_t kMachInfo;


@interface CBHBenchmarkDuration ()
{
	uint64_t _duration;
}

@end

NS_ASSUME_NONNULL_END


@implementation CBHBenchmarkDuration


#pragma mark - Class Initialization

+ (void)initialize
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		mach_timebase_info(&kMachInfo);
	});
}


#pragma mark - Factories

+ (instancetype)durationWithMachTime:(uint64_t)duration
{
	return [[self alloc] initWithMachTime:duration];
}


+ (instancetype)durationWithSeconds:(uint32_t)duration
{
	return [[self alloc] initWithSeconds:duration];
}

+ (instancetype)durationWithMilliSeconds:(uint64_t)duration
{
	return [[self alloc] initWithMilliSeconds:duration];
}

+ (instancetype)durationWithMicroSeconds:(uint64_t)duration
{
	return [[self alloc] initWithMicroSeconds:duration];
}

+ (instancetype)durationWithNanoSeconds:(uint64_t)duration
{
	return [[self alloc] initWithNanoSeconds:duration];
}


#pragma mark - Initializers

- (instancetype)initWithMachTime:(uint64_t)duration
{
	if ( kMachInfo.numer != 1 ) { duration *= kMachInfo.numer; }
	if ( kMachInfo.denom != 1 ) { duration /= kMachInfo.denom; }
	return [self initWithNanoSeconds:duration];
}


- (instancetype)initWithSeconds:(uint32_t)duration
{
	return [self initWithNanoSeconds:duration * 1000000000];
}

- (instancetype)initWithMilliSeconds:(uint64_t)duration
{
	return [self initWithNanoSeconds:duration * 1000000];
}

- (instancetype)initWithMicroSeconds:(uint64_t)duration
{
	return [self initWithNanoSeconds:duration * 1000];
}

- (instancetype)initWithNanoSeconds:(uint64_t)duration
{
	if ( (self = [super init]) )
	{
		_duration = duration;
	}

	return self;
}


#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
	if ( self == other ) return YES;
	if ( ![other isKindOfClass:[self class]] ) return NO;

	return [self isEqualToDuration:(CBHBenchmarkDuration *)other];
}

- (BOOL)isEqualToDuration:(CBHBenchmarkDuration *)other
{
	return ( _duration == other->_duration);
}

- (NSUInteger)hash
{
	return (NSUInteger)_duration;
}


#pragma mark - Comparison

- (NSComparisonResult)compare:(CBHBenchmarkDuration *)other
{
	uint64_t a = self->_duration;
	uint64_t b = other->_duration;

	if ( a < b ) return NSOrderedAscending;
	if ( a > b ) return NSOrderedDescending;

	return NSOrderedSame;
}


#pragma mark - Units

- (CGFloat)seconds
{
	return _duration / 1000000000;
}

- (CGFloat)milliseconds
{
	return _duration / 1000000;
}

- (CGFloat)microseconds
{
	return _duration / 1000;
}

- (uint64_t)nanoseconds
{
	return _duration;
}


#pragma mark - Description

- (NSString *)description
{
	NSMutableString *string = [NSMutableString stringWithString:@"{\n"];
	[string appendFormat:@"\tDuration: %llu ns\n", _duration];
	[string appendString:@"}"];

	return string;
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (void *)self, [self description]];
}

@end
