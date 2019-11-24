//  CBHBenchmarkDurationTests.h
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


@interface CBHBenchmarkDurationTests : XCTestCase
@end


@implementation CBHBenchmarkDurationTests

- (void)test_init
{
	XCTAssertEqual([[CBHBenchmarkDuration durationWithNanoSeconds:1000000000] nanoseconds], 1000000000, @"Failed to store the correct time from nanoseconds.");
	XCTAssertEqual([[CBHBenchmarkDuration durationWithMicroSeconds:1000000] nanoseconds], 1000000000, @"Failed to store the correct time from microseconds.");
	XCTAssertEqual([[CBHBenchmarkDuration durationWithMilliSeconds:1000] nanoseconds], 1000000000, @"Failed to store the correct time from milliseconds.");
	XCTAssertEqual([[CBHBenchmarkDuration durationWithSeconds:1] nanoseconds], 1000000000, @"Failed to store the correct time from seconds.");
}

- (void)test_init_machTime
{
	mach_timebase_info_data_t machInfo;
	mach_timebase_info(&machInfo);

	uint64_t machTime = mach_absolute_time();
	uint64_t time = machTime;
	time *= machInfo.numer;
	time /= machInfo.denom;

	XCTAssertEqual([[CBHBenchmarkDuration durationWithMachTime:machTime] nanoseconds], time, @"Failed to store the correct time from mach time.");
}

- (void)test_copy
{
	CBHBenchmarkDuration *duration = [CBHBenchmarkDuration durationWithNanoSeconds:1000000000];
	CBHBenchmarkDuration *copy = [duration copy];
	XCTAssertEqual(duration, copy, @"Copy isn't same object");
	XCTAssertEqualObjects(duration, copy, @"Copy isn't equal");
}

- (void)test_equality
{
	CBHBenchmarkDuration *duration = [CBHBenchmarkDuration durationWithNanoSeconds:1000000000];
	CBHBenchmarkDuration *same = [CBHBenchmarkDuration durationWithNanoSeconds:1000000000];
	CBHBenchmarkDuration *copy = [duration copy];
	CBHBenchmarkDuration *different = [CBHBenchmarkDuration durationWithNanoSeconds:1000000];
	NSNumber *differentType = [NSNumber numberWithInteger:1000000];

	XCTAssertTrue([duration isEqual:duration], @"Objects and self are not equal");
	XCTAssertTrue([duration isEqual:same], @"Objects and same are not equal");
	XCTAssertTrue([duration isEqual:copy], @"Objects and copy are not equal");

	XCTAssertFalse([duration isEqual:different], @"Objects and copy are not equal");
	XCTAssertFalse([duration isEqual:differentType], @"Objects and copy are not equal");
}

- (void)test_comparison
{
	CBHBenchmarkDuration *min = [CBHBenchmarkDuration durationWithNanoSeconds:1000000000];
	CBHBenchmarkDuration *max = [CBHBenchmarkDuration durationWithNanoSeconds:1000000001];

	XCTAssertTrue([max compare:min] == NSOrderedDescending, @"Compare descending failed.");
	XCTAssertTrue([min compare:max] == NSOrderedAscending, @"Compare descending failed.");
	XCTAssertTrue([min compare:min] == NSOrderedSame, @"Compare descending failed.");
	XCTAssertTrue([max compare:max] == NSOrderedSame, @"Compare descending failed.");
}

- (void)test_hash
{
	CBHBenchmarkDuration *duration = [CBHBenchmarkDuration durationWithNanoSeconds:1000000000];
	XCTAssertEqual([duration hash], 1000000000, @"Hash isn't nanoseconds.");
}


- (void)test_units
{
	XCTAssertEqual([[CBHBenchmarkDuration durationWithNanoSeconds:1000000000] nanoseconds], 1000000000, @"Failed to get the correct number of nanoseconds.");
	XCTAssertEqual([[CBHBenchmarkDuration durationWithNanoSeconds:1000000000] microseconds], 1000000, @"Failed to get the correct number of microseconds.");
	XCTAssertEqual([[CBHBenchmarkDuration durationWithNanoSeconds:1000000000] milliseconds], 1000, @"Failed to get the correct number of milliseconds.");
	XCTAssertEqual([[CBHBenchmarkDuration durationWithNanoSeconds:1000000000] seconds], 1, @"Failed to get the correct number of seconds.");
}

- (void)test_description
{
	CBHBenchmarkDuration *duration = [CBHBenchmarkDuration durationWithNanoSeconds:1000000000];
	XCTAssertEqualObjects([duration description], @"{\n\tDuration: 1000000000 ns\n}", @"Description fails.");
}

- (void)test_debugDescription
{
	CBHBenchmarkDuration *duration = [CBHBenchmarkDuration durationWithNanoSeconds:1000000000];
	XCTAssertEqualObjects([duration description], @"{\n\tDuration: 1000000000 ns\n}", @"Description fails.");
	NSString *expected = [NSString stringWithFormat:@"<%@: %p, %@>", [duration class], (void *)duration, [duration description]];
	XCTAssertEqualObjects([duration debugDescription], expected, @"Debug Description Failed");
}

@end
