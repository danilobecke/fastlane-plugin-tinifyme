describe Fastlane::Helper::TinifymeHelper do
  context "when the internet connection is not reachable" do
    it "has_connection? should returna false" do
      expect_any_instance_of(Net::HTTP).to receive(:start).and_raise(SocketError)
      expect(subject.has_connection?).to be false
    end
  end

  context "when the internet connection is reachable" do
    it "has_connection? should return true and close the connection" do
      mock = double(Net::HTTP)
      expect_any_instance_of(Net::HTTP).to receive(:start).and_return(mock)
      expect(mock).to receive(:finish)
      expect(subject.has_connection?).to be true
    end
  end

  context "when credentials are valid" do
    it "validate_credentials should output a success message" do
      require 'securerandom'
      key = SecureRandom.hex
      expect(Tinify).to receive(:validate!).and_return(true)
      expect(FastlaneCore::UI).to receive(:message)
      expect(FastlaneCore::UI).to receive(:success)
      subject.validate_credentials(key)
      expect(Tinify.key).to be key
    end
  end

  context "when credentials are not valid" do
    it "validate_credentials should abort with a message" do
      require 'securerandom'
      key = SecureRandom.hex
      expect(Tinify).to receive(:validate!).and_raise(Tinify::Error.create('message', 'type', 401))
      expect(FastlaneCore::UI).to receive(:abort_with_message!)
      subject.validate_credentials(key)
      expect(Tinify.key).to be key
    end
  end

  context "when formatting the output" do
    it "should add > when is_step" do
      require 'securerandom'
      output = SecureRandom.hex
      expect(subject.format!(output, is_step: true)).to eq(format(' > %<output>s', output: output))
    end

    it "should add identation when is_step = false" do
      require 'securerandom'
      output = SecureRandom.hex
      expect(subject.format!(output)).to eq(format('   %<output>s', output: output))
    end
  end

  context "when compressing images" do
    it "should call Tinify.from_file images.length() times" do
      require 'securerandom'
      images = []
      (1..rand(2..10)).each { images.append(SecureRandom.hex) }
      mock = double(Tinify::Source)
      images.each do |image|
        expect(Tinify).to receive(:from_file).with(image).ordered.and_return(mock)
        expect(mock).to receive(:to_file).with(image).ordered
      end
      subject.compress(images)
    end
  end

  context "when doing git operations" do
    before(:all) do
      require 'fileutils'
      @git_path = 'git_mock'
      Dir.chdir('spec')
      FileUtils.mkdir_p(@git_path)
      Dir.chdir(@git_path)
      system("git init -b main &> /dev/null")
      system("git config user.name \"Test\"")
      system("git config user.email \"test@test.com\"")
      system("cp ../images/* .")
      system("git add image-removed.jpg")
      system("git commit -m \"Add image\" &> /dev/null")
    end

    after(:all) do
      Dir.chdir("..")
      system(format("rm -rf %<path>s", path: @git_path))
      Dir.chdir("..")
    end

    context "when checking for staged images" do
      before do
        system("rm image-removed.jpg")
        system("git add .")
      end

      after do
        system("git reset . &> /dev/null")
        system("git checkout image-removed.jpg &> /dev/null")
      end

      it "should find images with the given extensions and ignore removed images" do
        images = subject.get_modified_images(['.png', '.webp', '.jpg', '.jpeg'])
        expect(images.length).to eq(4)
        expected_images = ["image-1.WEBP", "image-2.jpeg", "image-3.PNG", "image-4.jpg"]
        filtered = images.select { |image| expected_images.include?(image) }
        expect(images).to eq(filtered)
      end
    end

    context "when adding images to the current commit" do
      it "should add the given images" do
        images_to_add = ["image-1.WEBP", "image-2.jpeg"]
        subject.add_to_commit(images_to_add)
        added_images = `git diff --name-only --cached`
        expect(added_images.split("\n")).to eq(images_to_add)
      end
    end
  end
end
