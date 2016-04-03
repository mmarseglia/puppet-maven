require 'spec_helper'

describe 'maven::maven' do
  let(:title) { 'maven' }
  let(:facts) {{ :http_proxy => '', :maven_version => '' }}

  context "when downloading maven", :compile do
    it do should contain_archive('apache-maven-3.2.5-bin.tar.gz').with(
        'source' => 'http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz',
    ) end
  end

  context "when downloading maven from another repo", :compile do
    let(:params) { { :repo => {
        'url'      => 'http://repo1.maven.org/maven2',
        'username' => 'u',
        'password' => 'p'
      }
    } }

    it 'should fetch maven with username and password' do
      should contain_archive('apache-maven-3.2.5-bin.tar.gz').with(
        'source'      => 'http://repo1.maven.org/maven2',
        'username'    => 'u',
        'password'    => 'p')
    end
  end

  context "when maven was already installed" do

    context "in a different version", :compile do
      let(:facts) {super().merge({ :maven_version => '3.0.4' })}
      it { should contain_archive('apache-maven-3.2.5-bin.tar.gz') }
    end
  end

end
