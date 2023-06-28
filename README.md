# tinifyme plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-tinifyme)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-tinifyme`, add it to your project by running:

```bash
fastlane add_plugin tinifyme
```

## About tinifyme

Compress assets using [tinypng](https://tinypng.com). This plugin was designed to automate image compression in your project via pre-commit hook or one-off runs.

You'll need a *tinypng* developer API key, which can be freely obtained on their website: [https://tinypng.com/developers](https://tinypng.com/developers).

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. 

### Try it

Clone the repo and run `fastlane install_plugins`.

### Compress one image

```bash
bundle exec fastlane compress_image file_path:"file/to/path" api_key:"YOUR-API-KEY"
```

### Use as pre-commit hook

1. Add your API key as an environment var named `TINYPNG_API_KEY`
2. Add in your `.git/hooks/pre-commit` file the lane call:

>	```sh
> bundle exec fastlane compress_images_hook


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
