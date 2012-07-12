require "fileutils"
require 'webrick'
require "rake/clean"

include WEBrick
include FileUtils

directory "bin"
directory "lib"

PICTO_SRC = FileList["src/**/*"]

PICTO_SRC.exclude("src/client/**/*")
PICTO_BIN = PICTO_SRC.pathmap("%{^src,bin}p")

CLIENT_SRC = FileList["src/client/**/*"]
CLIENT_BIN = CLIENT_SRC.pathmap("%{^src,bin}p")

HUZU_RELAY_DOWNLOAD = "http://www.huzutech.com/Themes/Huzutech/downloads/HuzuRelay.zip"

EGGS = ["Twisted", "PyYAML", "txWS"]

CLEAN.include(PICTO_BIN)
CLOBBER.include("bin","lib")

def copy_file_task(source, target, dependency=nil)
    deps = [source, "bin"]
    deps.push dependency if dependency

    file target => deps  do
        containing_dir = target.pathmap "%d"
        directory containing_dir

        if File.directory?(source)
            directory target
        else
            cp source, target
        end
    end
end

PICTO_BIN.zip(PICTO_SRC).each do |target, source|
    copy_file_task source, target
end

CLIENT_BIN.zip(CLIENT_SRC).each do |target, source|
    copy_file_task source, target
end

#desc "download and unpack the required huru bundle for the picto server"
file "lib/HuzuRelay.zip" => ["lib"] do
    `wget -O lib/HuzuRelay.zip #{HUZU_RELAY_DOWNLOAD}`
    `unzip lib/HuzuRelay.zip -d lib`
end

desc "copy the picto src files to bin"
task :copy_picto_src => PICTO_BIN

desc "copy the huru files to bin and generate file tasks"
task :get_huru => ["lib/HuzuRelay.zip", "bin"] do
    huru_src = FileList["lib/HuzuRelay/**/*"]
    huru_src.exclude {|f| f.include?("client") || f.include?("test") || f.include?("doc") }

    huru_bin = huru_src.pathmap("%{^lib/HuzuRelay,bin}p") 

    huru_bin.zip(huru_src).each do |target, source|
        copy_file_task source, target
    end

    #gonna invoke the file tasks here because these are dynamic and so can't define as dependencies
    huru_bin.each {|f| Rake::Task[f].invoke }
end


desc "check for and install (using easy_install) the required python eggs for huru"
task :check_for_eggs do
    egg_dir = `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`
    eggs = Dir.entries(egg_dir.strip)

    EGGS.each do |required_egg|
        unless eggs.any? { |installed_egg| installed_egg.include? required_egg }
            puts "### installing #{required_egg}"
            sh "easy_install #{required_egg}"
        end
    end
end

desc "copy client files"
task :copy_client_src => CLIENT_BIN

desc "download all dependencies and assemble the bin folder"
task :build => [:get_huru, :get_local_ip, :copy_picto_src, :check_for_eggs, :copy_client_src]

task :default => :build

task :get_local_ip => PICTO_BIN do
    ip = nil
    UDPSocket.open {|s| s.connect('64.233.187.99', 1); ip = s.addr.last }

    ip = "'    wsUri: \"ws://#{ip}:8280\"'"

    `echo #{ip} >> src/client/src/app/constants.coffee`
end


desc "run the pictoscrawl server and client"
task :run => :build do
    `cd bin; ./huRUservice start picto`
    Dir.chdir "bin/client"
    
    pid = fork do
        #shutup webrick
        s = HTTPServer.new :Port => 8000, :DocumentRoot => Dir.pwd, :AccessLog => [], :Logger => Log::new("/dev/null", 7)
        s.start
    end

    Process.detach pid

    `echo #{pid} > picto-client.pid`

    Dir.chdir "../.."
end

desc "stop running everything"
task :stop => :build do
    `cd bin; ./huRUservice stop`

    if File.exists? "bin/client/picto-client.pid" then
        `cat bin/client/picto-client.pid | xargs kill -9 `
        rm "bin/client/picto-client.pid" 
    end
end
