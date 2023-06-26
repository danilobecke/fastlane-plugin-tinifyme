require 'securerandom'

describe Fastlane::Actions::TinifymeAction do
  let(:key) { SecureRandom.hex }

  before do
    @params = {}
    @params[:api_key] = key
  end

  context "when file_path is set" do
    context "when the internet connection is not reachable" do
      it "should finish with a important message" do
        file_path = SecureRandom.hex
        @params[:file_path] = file_path
        expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:has_connection?).and_return(false)
        expect(FastlaneCore::UI).to receive(:important)
        Fastlane::Actions::TinifymeAction.run(@params)
      end
    end

    context "when the internet connection is reachable" do
      it "should validate the credentials, compress, and output a success message" do
        file_path = SecureRandom.hex
        @params[:file_path] = file_path
        expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:has_connection?).and_return(true)
        expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:validate_credentials).with(key)
        expect(FastlaneCore::UI).to receive(:message)
        expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:compress).with([file_path])
        expect(FastlaneCore::UI).to receive(:success)
        Fastlane::Actions::TinifymeAction.run(@params)
      end
    end
  end

  context "when the file_path is not set" do
    context "when there are no modified images staged on git" do
      it "should output a success message" do
        image_formats = [SecureRandom.hex]
        @params[:image_formats] = image_formats
        expect(FastlaneCore::UI).to receive(:message)
        expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:get_modified_images).with(image_formats).and_return([])
        expect(FastlaneCore::UI).to receive(:success)
        Fastlane::Actions::TinifymeAction.run(@params)
      end
    end

    context "when there are modified images staged on git" do
      context "when the internet connection is not reachable" do
        context "when the abort_commit_without_internet_connection parameter is true" do
          it "should abort with a message" do
            image_formats = [SecureRandom.hex, SecureRandom.hex]
            @params[:image_formats] = image_formats
            images_found = [SecureRandom.hex]
            expect(FastlaneCore::UI).to receive(:message)
            expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:get_modified_images).with(image_formats).and_return(images_found)
            expect(FastlaneCore::UI).to receive(:success)
            expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:has_connection?).and_return(false)
            expect(FastlaneCore::UI).to receive(:important)
            expect(FastlaneCore::UI).to receive(:abort_with_message!)
            Fastlane::Actions::TinifymeAction.run(@params)
          end
        end

        context "when the abort_commit_without_internet_connection parameter is false" do
          it "should add images to the current commit" do
            images_found = [SecureRandom.hex, SecureRandom.hex]
            @params[:abort_commit_without_internet_connection] = false
            expect(FastlaneCore::UI).to receive(:message)
            expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:get_modified_images).and_return(images_found)
            expect(FastlaneCore::UI).to receive(:success)
            expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:has_connection?).and_return(false)
            expect(FastlaneCore::UI).to receive(:important)
            expect(FastlaneCore::UI).to receive(:message)
            expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:add_to_commit).with(images_found)
            expect(FastlaneCore::UI).to receive(:success)
            Fastlane::Actions::TinifymeAction.run(@params)
          end
        end
      end

      context "when the internet connection reachable" do
        it "should compress and add images to the current commit" do
          images_found = [SecureRandom.hex, SecureRandom.hex]
          expect(FastlaneCore::UI).to receive(:message)
          expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:get_modified_images).and_return(images_found)
          expect(FastlaneCore::UI).to receive(:success)
          expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:has_connection?).and_return(true)
          expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:validate_credentials).with(key)
          expect(FastlaneCore::UI).to receive(:message)
          expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:compress).with(images_found)
          expect(FastlaneCore::UI).to receive(:success)
          expect(FastlaneCore::UI).to receive(:message)
          expect_any_instance_of(Fastlane::Helper::TinifymeHelper).to receive(:add_to_commit).with(images_found)
          expect(FastlaneCore::UI).to receive(:success)
          Fastlane::Actions::TinifymeAction.run(@params)
        end
      end
    end
  end
end
