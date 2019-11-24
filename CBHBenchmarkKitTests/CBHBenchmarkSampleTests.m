//  CBHBenchmarkSampleTests.h
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


@interface CBHBenchmarkSampleTests : XCTestCase
@end


@implementation CBHBenchmarkSampleTests

- (void)test_init
{
	XCTAssertEqual([[CBHBenchmarkSample sampleWithNanoSeconds:1000000000] nanoseconds], 1000000000, @"Failed to store the correct time from nanoseconds.");
	XCTAssertEqual([[CBHBenchmarkSample sampleWithMicroSeconds:1000000] nanoseconds], 1000000000, @"Failed to store the correct time from microseconds.");
	XCTAssertEqual([[CBHBenchmarkSample sampleWithMilliSeconds:1000] nanoseconds], 1000000000, @"Failed to store the correct time from milliseconds.");
	XCTAssertEqual([[CBHBenchmarkSample sampleWithSeconds:1] nanoseconds], 1000000000, @"Failed to store the correct time from seconds.");
}

- (void)test_init_machTime
{
	mach_timebase_info_data_t machInfo;
	mach_timebase_info(&machInfo);

	uint64_t machTime = mach_absolute_time();
	uint64_t time = machTime;
	time *= machInfo.numer;
	time /= machInfo.denom;

	XCTAssertEqual([[CBHBenchmarkSample sampleWithMachTime:machTime] nanoseconds], time, @"Failed to store the correct time from mach time.");
}

- (void)test_equality
{
	CBHBenchmarkSample *duration = [CBHBenchmarkSample durationWithNanoSeconds:1000000000];
	CBHBenchmarkSample *same = [CBHBenchmarkSample durationWithNanoSeconds:1000000000];
	CBHBenchmarkSample *copy = [duration copy];
	CBHBenchmarkSample *different = [CBHBenchmarkSample durationWithNanoSeconds:1000000];

	XCTAssertTrue([duration isEqualToSample:duration], @"Objects and self are not equal");
	XCTAssertTrue([duration isEqualToSample:same], @"Objects and same are not equal");
	XCTAssertTrue([duration isEqualToSample:copy], @"Objects and copy are not equal");

	XCTAssertFalse([duration isEqualToSample:different], @"Objects and copy are not equal");
}

@end
