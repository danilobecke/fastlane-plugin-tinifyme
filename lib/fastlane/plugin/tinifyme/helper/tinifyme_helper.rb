require 'fastlane_core/ui/ui'
require 'tinify'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class TinifymeHelper
      def has_connection?
        require 'net/http'
        url = URI('https://www.google.com')
        begin
          http = Net::HTTP.start(url.host, url.port, use_ssl: true)
          http.finish
          return true
        rescue SocketError
          return false
        end
      end

      def validate_credentials(api_key)
        UI.message(self.format!('Checking tinypng credentials...', is_step: true))
        Tinify.key = api_key
        Tinify.validate!
        UI.success(self.format!('Valid credentials!'))
      rescue Tinify::Error => e
        UI.abort_with_message!(e)
      end

      def format!(text, is_step: false)
        return format(' > %<text>s', text:) if is_step

        return format('   %<text>s', text:)
      end

      def get_modified_images(image_extensions)
        added_or_modified = `git diff --name-only --cached --diff-filter=d`
        return added_or_modified.split("\n").select { |file| file.downcase.end_with?(*image_extensions) }
      end

      def compress(images)
        images.each { |image| Tinify.from_file(image).to_file(image) }
      end

      def add_to_commit(images)
        images_text = images.join(" ")
        system(format('git add %<images>s', images: images_text))
      end
    end
  end
end
