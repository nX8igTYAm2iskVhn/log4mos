CHANGELOG
=========

0.5.9

- Updating the version of activerecord that log4mos depends on to be compatible with rails 4, so that email_service which requires rails 4 can use log4mos

0.5.8

- Make sure that there is a linebreak after each jsonized line, so that splunk does not concatenate them.

0.5.7

- Upgrading i18n to a version that requires ruby >= 1.9.3 so that pos-service does not have to downgrade to an old version of i18n. Removing support for ruby 1.9.2 since i18n 0.7.0 requires ruby >= 1.9.3

0.5.6

- Catching error thrown by rubygem OJ (Optimized Json) when it is passed an object which is nested more than 1000 layers deep. OJ is used by MultiJson to dump a logged object to json. https://github.com/ohler55/oj/issues/142 https://github.com/intridea/multi_json/blob/1ba3be42600696f676d9cc1f029227b84c3c763b/README.md#L50

0.5.5

- Use MultiJson.dump instead of JSON.generate because of the "NoMethodError: undefined method `key?' for #JSON::Ext::Generator::State:0x000000080d2908" error caused by JSON.generate overrides in JSON API, which is now part of ruby. See https://github.com/intridea/multi_json/issues/86 https://github.com/ohler55/oj/blob/0ae15227a92fe7aae83a7a9d7b20850703476259/ext/oj/hash_test.c#L209

0.5.4

- Use JSON:: in the ruby standardlib instad of to_json as defined in activesupport, which has a circular dependency detection bug.

0.5.3

- Last release before dropping suport for ruby < 2.x
