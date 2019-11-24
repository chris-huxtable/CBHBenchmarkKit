# CBHBenchmarkKit

[![release](https://img.shields.io/github/release/chris-huxtable/CBHBenchmarkKit.svg)](https://github.com/chris-huxtable/CBHBenchmarkKit/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHBenchmarkKit.svg)](https://cocoapods.org/pods/CBHBenchmarkKit)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHBenchmarkKit/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHBenchmarkKit)

A simple statistical time-based benchmarking framework with nanosecond precision.


## Example:

Sample the amount of time to create and fill and array with 10000 entries. 

```objective-c
CBHBenchmarkSamples *benchmark = [CBHBenchmark benchmark:^{
	NSMutableArray *array = [NSMutableArray array];
	for (NSUInteger i = 0; i < 10000; ++i)
	{
		[array addObject:[NSString stringWithFormat:@"%lu", i]];
	}
}];


/// Samples
NSUInteger count = [benchmark count];
NSArray<CBHBenchmarkSample *> *samples = [benchmark samples];
NSArray<CBHBenchmarkSample *> *sortedSamples = [benchmark sortedSamples];


/// Max, Min, and Range
CBHBenchmarkSample *min = [benchmark min];
CBHBenchmarkSample *max = [benchmark max];
CBHBenchmarkDuration *spread = [benchmark spread];


/// Mean and Median
CBHBenchmarkDuration *mean = [benchmark spread];
CBHBenchmarkDuration *median = [benchmark spread];


/// Variance, Standard Deviation, Standard Error
CGFloat variance = [benchmark variance];
CBHBenchmarkDuration *standardDeviation = [benchmark standardDeviation];
CBHBenchmarkDuration *standardError = [benchmark standardError];
```


## Licence
CBHBenchmarkKit is available under the [ISC license](https://github.com/chris-huxtable/CBHBenchmarkKit/blob/master/LICENSE).
