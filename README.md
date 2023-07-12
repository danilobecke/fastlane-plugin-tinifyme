# tinifyme plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-tinifyme)
[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-tinifyme.svg)](https://badge.fury.io/rb/fastlane-plugin-tinifyme)
<a href="https://codeclimate.com/github/danilobecke/fastlane-plugin-tinifyme/test_coverage"><img src="https://api.codeclimate.com/v1/badges/feeed02eb3bc51bd7ded/test_coverage" /></a>
<a href="https://github.com/danilobecke/fastlane-plugin-tinifyme/actions/workflows/test.yml"><img src="https://github.com/danilobecke/fastlane-plugin-tinifyme/actions/workflows/test.yml/badge.svg" /></a>
<a href="https://codeclimate.com/github/danilobecke/fastlane-plugin-tinifyme/maintainability"><img src="https://api.codeclimate.com/v1/badges/feeed02eb3bc51bd7ded/maintainability" /></a>

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-tinifyme`, add it to your project by running:

```bash
fastlane add_plugin tinifyme
```

## About tinifyme

Compress assets using [TinyPNG](https://tinypng.com). This plugin was designed to automate image compression in your project via pre-commit hook or one-off runs.

When used as a pre-commit hook, it will search for staged images (added or modified), compress'em, and add them back into the current commit. All you need to do is call your lane invoking the tinifyme action!

You'll need a TinyPNG developer API key, which can be freely obtained on their website: [https://tinypng.com/developers](https://tinypng.com/developers).

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. 

### Try it

Clone the repo and run `fastlane install_plugins`.

### Compress a specific image

```bash
bundle exec fastlane compress_image file_path:"path/to/file" api_key:"YOUR_API_KEY"
```

### Use as pre-commit hook

1. Set your TinyPNG developer API key as the value of the `TINYPNG_API_KEY` env var
2. Call your _fastlane_ lane from your `.git/hooks/pre-commit` file. For instance:

```sh
bundle exec fastlane compress_images_hook
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
