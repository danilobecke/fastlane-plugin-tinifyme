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
end
