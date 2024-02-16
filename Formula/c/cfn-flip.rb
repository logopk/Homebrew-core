class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37653f7ba16c65028c10b82843c3d1ea7e4a3fea47c53a7054f5863fba687bae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89737e5c00443baae9e9f367370d52f27fe9e236a817a74f372ebe05d00db2c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11a008eeffc4213639858877bce6d69ad61de8e0a38a419b4250eb6b7bb682b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7954930392be2b7df263551db02ca0c99a728bdb0e1dafdac66fbfdd4d2a84a"
    sha256 cellar: :any_skip_relocation, ventura:        "f6b900069af123f2ced804365ea70e4b8bb3a7faf34dfade93be1835a199bc1c"
    sha256 cellar: :any_skip_relocation, monterey:       "01d94ff67e1a59cb14b1e96d7c4f2f251a1c9aa2c6755357b7d4d56a7165dfea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc96af186bfe2d9498b7ba8ba5b34f01c7d39169189bfa7cd5563d92e5b952b"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
        "Resources": {
          "Bucket": {
            "Type": "AWS::S3::Bucket",
            "Properties": {
              "BucketName": {
                "Ref": "AWS::StackName"
              }
            }
          }
        }
      }
    EOS

    expected = <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
          Properties:
            BucketName: !Ref 'AWS::StackName'
    EOS

    assert_match expected, shell_output("#{bin}/cfn-flip test.json")
  end
end
