require 'fastlane_core'
require 'fastlane/action'
require_relative '../helper/tinifyme_helper'

module Fastlane
  module Actions
    class TinifymeAction < Action
      def self.run(params)
        key = params[:api_key]
        file_path = params[:file_path]
        helper = Helper::TinifymeHelper.new
        if file_path
          compress([file_path], key)
        else
          UI.message(helper.format_output('Checking staged files...', is_step: true))
          modified_images = helper.get_modified_images(params[:image_formats])
          length = modified_images.length
          return UI.success(helper.format_output('No images found!')) unless length > 0

          UI.success(helper.format_output("Found #{length} #{length > 1 ? 'images' : 'image'}."))
          compressed = compress(modified_images, key)
          return UI.abort_with_message!("The commit was aborted.") unless compressed || params[:abort_commit_without_internet_connection] == false

          UI.message(helper.format_output('Adding to commit...', is_step: true))
          helper.add_to_commit(modified_images)
          UI.success(helper.format_output("#{compressed ? 'Compressed images' : 'Images'} added to the current commit."))
        end
      end

      def self.description
        "Compress assets using TinyPNG."
      end

      def self.authors
        ["Danilo Becke"]
      end

      def self.return_value
      end

      def self.details
        "fastlane plugin to automate image compression in your project via precommit hook or one-off runs."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_key,
            description: "Required TinyPNG API key (https://tinypng.com/developers)",
            env_name: "TINYPNG_API_KEY",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :file_path,
            description: "If present, the action will compress the given image. If not, the action will act as a pre-commit hook and look for staged added or modified images",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :image_formats,
            description: "Allowed image extensions to be compressed",
            default_value: [".jpg", ".png", ".webp", ".jpeg"],
            optional: false,
            type: Array
          ),
          FastlaneCore::ConfigItem.new(
            key: :abort_commit_without_internet_connection,
            description: "Decide whether the commit should be aborted when there are images to be compressed and the internet connection is not reachable (thus, the compression won't be possible)",
            default_value: true,
            optional: false,
            type: Boolean
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end

      class << self
        private

        def helper
          @helper ||= Helper::TinifymeHelper.new
        end

        def compress(images, key)
          unless helper.has_connection?
            UI.important('No internet connection.')
            return false
          end

          helper.validate_credentials!(key)
          UI.message(helper.format_output('Compressing...', is_step: true))
          helper.compress!(images)
          length = images.length
          UI.success(helper.format_output("Compressed #{length} #{length > 1 ? 'images' : 'image'}."))
          true
        end
      end
    end
  end
end
