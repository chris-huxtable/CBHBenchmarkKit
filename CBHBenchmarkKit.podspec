Pod::Spec.new do |spec|

  spec.name                   = 'CBHBenchmarkKit'
  spec.version                = '0.1.0'
  spec.module_name            = 'CBHBenchmarkKit'

  spec.summary                = 'A simple statistical time-based benchmarking framework with nanosecond precision.'
  spec.homepage               = 'https://github.com/chris-huxtable/CBHBenchmarkKit'

  spec.license                = { :type => 'ISC', :file => 'LICENSE' }

  spec.author                 = { 'Chris Huxtable' => 'chris@huxtable.ca' }
  spec.social_media_url       = 'https://twitter.com/@Chris_Huxtable'

  spec.osx.deployment_target  = '10.10'

  spec.source                 = { :git => 'https://github.com/chris-huxtable/CBHBenchmarkKit.git', :tag => "v#{spec.version}" }

  spec.requires_arc           = true

  spec.public_header_files    = 'CBHBenchmarkKit/*.h'
  spec.private_header_files   = 'CBHBenchmarkKit/_*.h'
  spec.source_files           = 'CBHBenchmarkKit/*.{h,m}'

end
