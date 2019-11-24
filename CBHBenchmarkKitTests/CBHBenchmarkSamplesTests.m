//  CBHBenchmarkSamplesTests.h
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


static NSArray<CBHBenchmarkSample *> *_kSampleArray;
static NSArray<CBHBenchmarkSample *> *_kSortedSampleArray;
static NSArray<CBHBenchmarkSample *> *_kSingleSampleArray;


@interface CBHBenchmarkSamplesTests : XCTestCase
@end


@implementation CBHBenchmarkSamplesTests

+ (void)initialize
{
	_kSampleArray = @[[CBHBenchmarkSample sampleWithNanoSeconds:100],
					 [CBHBenchmarkSample sampleWithNanoSeconds:150],
					 [CBHBenchmarkSample sampleWithNanoSeconds:170],
					 [CBHBenchmarkSample sampleWithNanoSeconds:150],
					 [CBHBenchmarkSample sampleWithNanoSeconds:100]];

	_kSortedSampleArray = @[[CBHBenchmarkSample sampleWithNanoSeconds:100],
						   [CBHBenchmarkSample sampleWithNanoSeconds:100],
						   [CBHBenchmarkSample sampleWithNanoSeconds:150],
						   [CBHBenchmarkSample sampleWithNanoSeconds:150],
						   [CBHBenchmarkSample sampleWithNanoSeconds:170]];

	_kSingleSampleArray = @[[CBHBenchmarkSample sampleWithNanoSeconds:100]];
}

- (void)test_init
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertNotNil(samples, @"Samples failed to initialize");

	samples = [CBHBenchmarkSamples samplesWithSamples:@[]];
	XCTAssertNil(samples, @"Samples didn't fail to initialize");
}

- (void)test_copy
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	CBHBenchmarkSamples *copy = [samples copy];
	XCTAssertEqual(samples, copy, @"Copy isn't same object");
	XCTAssertEqualObjects(samples, copy, @"Copy isn't equal");
}

- (void)test_count
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([samples count], 5, @"Sample count is wrong");
}

- (void)test_samples
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqualObjects([samples samples], _kSampleArray, @"Sample objects are wrong");
}

- (void)test_sortedSamples
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqualObjects([samples sortedSamples], _kSortedSampleArray, @"Sorted sample objects are wrong");
}

- (void)test_min
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([[samples min] nanoseconds], 100, @"Minimum sample object is wrong");
	XCTAssertEqual([[samples min] nanoseconds], 100, @"Minimum cached sample object is wrong");
}

- (void)test_max
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([[samples max] nanoseconds], 170, @"Maximum sample object is wrong");
	XCTAssertEqual([[samples max] nanoseconds], 170, @"Maximum cached sample object is wrong");
}

- (void)test_spread
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([[samples spread] nanoseconds], 70, @"Spread of samples is wrong");
	XCTAssertEqual([[samples spread] nanoseconds], 70, @"Spread of samples cached value is wrong");
}

- (void)test_mean
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([[samples mean] nanoseconds], 134, @"Mean of samples is wrong");
	XCTAssertEqual([[samples mean] nanoseconds], 134, @"Mean of samples cached value is wrong");
}

- (void)test_median
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([[samples median] nanoseconds], 150, @"Median of samples is wrong");
	XCTAssertEqual([[samples median] nanoseconds], 150, @"Median of samples cached value is wrong");

	/// Test for even number of samples
	NSArray<CBHBenchmarkSample *> *sampleArray = @[[CBHBenchmarkSample sampleWithNanoSeconds:100],
													 [CBHBenchmarkSample sampleWithNanoSeconds:170],
													 [CBHBenchmarkSample sampleWithNanoSeconds:150],
													 [CBHBenchmarkSample sampleWithNanoSeconds:100]];

	samples = [CBHBenchmarkSamples samplesWithSamples:sampleArray];
	XCTAssertEqual([[samples median] nanoseconds], 125, @"Median of samples is wrong");
	XCTAssertEqual([[samples median] nanoseconds], 125, @"Median of samples cached value is wrong");

	/// Test for singular sample
	samples = [CBHBenchmarkSamples samplesWithSamples:_kSingleSampleArray];
	XCTAssertEqual([[samples median] nanoseconds], 100, @"Median of samples is wrong");
	XCTAssertEqual([[samples median] nanoseconds], 100, @"Median of samples cached value is wrong");
}

- (void)test_variance
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([samples variance], 1030.0, @"Variance of samples is wrong");
	XCTAssertEqual([samples variance], 1030.0, @"Variance of samples cached value is wrong");

	/// Test for singular sample
	samples = [CBHBenchmarkSamples samplesWithSamples:_kSingleSampleArray];
	XCTAssertTrue(isnan([samples variance]), @"Variance of single sample is wrong");
	XCTAssertTrue(isnan([samples variance]), @"Variance of single sample cached value is wrong");
}

- (void)test_standardDeviation
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([[samples standardDeviation] nanoseconds], 32, @"Standard Deviation of samples is wrong");
	XCTAssertEqual([[samples standardDeviation] nanoseconds], 32, @"Standard Deviation of samples cached value is wrong");

	/// Test for singular sample
	samples = [CBHBenchmarkSamples samplesWithSamples:_kSingleSampleArray];
	XCTAssertEqual([samples standardDeviation], nil, @"Standard Deviation of single sample is wrong");
	XCTAssertEqual([samples standardDeviation], nil, @"Standard Deviation of single sample cached value is wrong");
}

- (void)test_standardError
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];
	XCTAssertEqual([[samples standardError] nanoseconds], 14, @"Standard Error of samples is wrong");
	XCTAssertEqual([[samples standardError] nanoseconds], 14, @"Standard Error of samples cached value is wrong");

	/// Test for singular sample
	samples = [CBHBenchmarkSamples samplesWithSamples:_kSingleSampleArray];
	XCTAssertEqual([samples standardError], nil, @"Standard Error of single sample is wrong");
	XCTAssertEqual([samples standardError], nil, @"Standard Error of single sample cached value is wrong");
}

- (void)test_description
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];

	NSString *actual = [[samples description] copy];
	NSString *expected = @"{\n\tSamples:                    [100 ns, 150 ns, 170 ns, \n\
\t                             150 ns, 100 ns],\n\
\tNumber of Samples Taken:    5,\n\
\tMin:                        100 ns,\n\
\tMax:                        170 ns,\n\
\tSpread:                     70 ns,\n\
\tMean:                       134 ns,\n\
\tMedian:                     150 ns,\n\
\tVariance:                   1030.00 ns^2,\n\
\tStandard Deviation:         32 ns,\n\
\tStandard Error:             14 ns\n\
}";

	XCTAssertEqualObjects(actual, expected, @"Description is wrong");
}

- (void)test_shortDescription
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];

	NSString *actual = [[samples shortDescription] copy];
	NSString *expected = @"{\n\
\tNumber of Samples Taken:    5,\n\
\tMin:                        100 ns,\n\
\tMax:                        170 ns,\n\
\tSpread:                     70 ns,\n\
\tMean:                       134 ns,\n\
\tMedian:                     150 ns,\n\
\tVariance:                   1030.00 ns^2,\n\
\tStandard Deviation:         32 ns,\n\
\tStandard Error:             14 ns\n\
}";

	XCTAssertEqualObjects(actual, expected, @"Description is wrong");
}

- (void)test_debugDescription
{
	CBHBenchmarkSamples *samples = [CBHBenchmarkSamples samplesWithSamples:_kSampleArray];

	NSString *description = [NSString stringWithFormat:@"<CBHBenchmarkSamples: %p, %@>", (void *)samples, [samples description]];
	XCTAssertEqualObjects([samples debugDescription], description, @"Description is wrong.");

}

@end
