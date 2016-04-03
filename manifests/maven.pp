# Copyright 2011 MaestroDev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Class: maven::maven
#
# A puppet recipe to install Apache Maven
#
# Parameters:
#   - $version:
#         Maven version.
#
# Requires:
#   Java package installed.
#
# Sample Usage:
#   class {'maven::maven':
#     version => "3.2.5",
#   }
#
class maven::maven(
  $version = '3.2.5',
  $repo = {
    #url      => 'http://repo1.maven.org/maven2',
    #username => '',
    #password => '',
  } ) {

$dirname = "apache-maven-${version}"
$filename = "apache-maven-${version}-bin.tar.gz"
$install_path = "/opt/${dirname}"

file { $install_path :
  ensure  => directory,
  mode    => '0755',
}

if empty($repo) {
  archive { $filename :
    path         => "/tmp/${filename}",
    source       => "http://archive.apache.org/dist/maven/maven-3/${version}/binaries/${filename}",
    extract      => true,
    extract_path => '/opt',
    creates      => "${install_path}/bin",
    cleanup      => true,
    require      => File[$install_path],
  }
} else {
  archive { $filename :
    path         => "/tmp/${filename}",
    source       => $repo['url'],
    username     => $repo['username'],
    password     => $repo['password'],
    extract      => true,
    extract_path => '/opt',
    creates      => "${install_path}/bin",
    cleanup      => true,
    require      => File[$install_path],
  }
}

file { '/usr/bin/mvn':
  ensure  => link,
  target  => "/opt/apache-maven-${version}/bin/mvn",
  require => Archive[$filename],
}

}
