Pod::Spec.new do |spec|
    spec.name         = 'web3swift.cak256.pod'
    spec.version      = 'cak256'
    spec.ios.deployment_target = "8.0"
    spec.osx.deployment_target = "10.10"
    spec.tvos.deployment_target = "9.0"
    spec.watchos.deployment_target = "2.0"
    spec.license      = { :type => 'Apache License 2.0', :file => 'LICENSE.md' }
    spec.summary      = 'Web3 implementation in pure Swift for iOS, macOS, tvOS, watchOS and Linux'
    spec.homepage     = 'https://github.com/TTCOffical/web3swift'
    spec.author       = 'TTCOffical-Super'
    spec.source       = { :git => 'https://github.com/TTCOffical/web3swift', :tag => spec.version }
    spec.source_files = 'Sources/web3swift/**/*.swift'
    spec.swift_version = '4.2'
    spec.module_name = 'web3swift'
    spec.dependency 'PromiseKit', '6.8.4'
    spec.dependency 'BigInt', '~> 3.1'
    spec.dependency 'secp256k1.c', '~> 0.1'
    spec.dependency 'keccak.c', '~> 0.1'
    spec.dependency 'scrypt.c', '~> 0.1'
end