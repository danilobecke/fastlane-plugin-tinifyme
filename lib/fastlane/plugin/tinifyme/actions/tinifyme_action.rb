require 'fastlane/action'
require_relative '../helper/tinifyme_helper'

module Fastlane
  module Actions
    class TinifymeAction < Action
      def self.run(params)
        key = params[:api_key]
        file_path = params[:file_path]
        @helper = Helper::TinifymeHelper
        if file_path
          compress([file_path], key)
        else
          UI.message(@helper.format!('Checking staged files...', is_step: true))
          modified_images = @helper.get_modified_images(params[:image_formats])
          length = modified_images.length()
          return UI.success(@helper.format!('No images found!')) unless length > 0

          UI.success(@helper.format!(format('Found %<count>d %<text>s.', count: length, text: length > 1 ? 'images' : 'image')))
          compress(modified_images, key)
          UI.message(@helper.format!('Adding to commit...', is_step: true))
          @helper.add_to_commit(modified_images)
          UI.success(@helper.format!('Compressed images added to the current commit.'))
        end
      end

      def self.description
        "Compress assets using tinypng."
      end

      def self.authors
        ["Danilo Becke"]
      end

      def self.return_value
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_key,
            description: "Required tinypng API key (https://tinypng.com/developers)",
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
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end

      private_class_method def self.compress(images, key)
        @helper.validate_credentials(key)
        UI.message(@helper.format!('Compressing...', is_step: true))
        @helper.compress(images)
        length = images.length()
        UI.success(@helper.format!(format('Compressed %<count>d %<text>s.', count: length, text: length > 1 ? 'images' : 'image')))
      end
    end
  end
end
