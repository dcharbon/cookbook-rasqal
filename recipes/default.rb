require "tmpdir"

["libpcre3-dev", "libgmp-dev", "libmpfr-dev"].each do |pkg|
  package pkg do
    :install
  end
end

filename = "rasqal-#{node.rasqal.version}"
td = Dir.tmpdir
local_tarball = File.join(td, "#{filename}.tar.gz")
tarball_dir = File.join(td, "#{filename}")

remote_file(local_tarball) do
  source "http://download.librdf.org/source/#{filename}.tar.gz"
  not_if {File.exists?("/usr/local/lib/librasqal.so")}
end

bash "extract, make, and install #{local_tarball}" do
  user "root"
  cwd "/tmp"
  code <<-EOS
    tar xzf #{local_tarball}
    cd #{tarball_dir}
    ./configure
    make
    make install
    rm -rf #{tarball_dir}
    rm #{local_tarball}
    cd ..
    ldconfig
  EOS


  creates "/usr/local/lib/librasqal.so"
end

