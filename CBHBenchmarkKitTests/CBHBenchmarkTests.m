//  CBHBenchmarkTests.m
//  CBHBenchmarkKitTests
//
//  Created by Christian Huxtable <chris@huxtable.ca>, October 2019.
//  Copyright (c) 2019, Christian Huxtable <chris@huxtable.ca>
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

@import XCTest;
@import CBHBenchmarkKit;


@interface CBHBenchmarkTests : XCTestCase
@end


@implementation CBHBenchmarkTests

- (void)testFactory_sample
{
	CBHBenchmarkSample *sample = [CBHBenchmark sample:^{
		NSMutableArray *array = [NSMutableArray array];
		for (NSUInteger i = 0; i < 10000; ++i)
		{
			[array addObject:[NSString stringWithFormat:@"%lu", i]];
		}
	}];

	XCTAssertNotNil(sample, @"Failed to return a sample.");
}

- (void)testFactory_benchmark
{
	CBHBenchmarkSamples *samples = [CBHBenchmark benchmark:^{
		NSMutableArray *array = [NSMutableArray array];
		for (NSUInteger i = 0; i < 10000; ++i)
		{
			[array addObject:[NSString stringWithFormat:@"%lu", i]];
		}
	}];

	XCTAssertEqual([samples count], 5, @"Incorrect number of samples.");
}

- (void)testFactory_benchmarkWithSampleCount
{
	CBHBenchmarkSamples *samples = [CBHBenchmark benchmarkWithSampleCount:10 andBlock:^{
		NSMutableArray *array = [NSMutableArray array];
		for (NSUInteger i = 0; i < 10000; ++i)
		{
			[array addObject:[NSString stringWithFormat:@"%lu", i]];
		}
	}];

	XCTAssertEqual([samples count], 10, @"Incorrect number of samples.");
}

@end
