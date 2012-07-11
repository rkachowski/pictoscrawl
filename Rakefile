require "fileutils"
require "rake/clean"

include FileUtils

directory "bin"
directory "lib"

PICTO_SRC = FileList["src/**/*"]
PICTO_BIN = PICTO_SRC.pathmap("%{^src,bin}p")

HUZU_RELAY_DOWNLOAD = "http://www.huzutech.com/Themes/Huzutech/downloads/HuzuRelay.zip"

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

file "lib/HuzuRelay.zip" => ["lib"] do
    `wget -O lib/HuzuRelay.zip #{HUZU_RELAY_DOWNLOAD}`
    `unzip lib/HuzuRelay.zip -d lib`
end

task :copy_picto_src => PICTO_BIN

task :copy_huru_files => ["lib/HuzuRelay.zip", "bin"] do
    huru_src = FileList["lib/HuzuRelay/**/*"]
    huru_src.exclude {|f| f.include?("client") || f.include?("test") || f.include?("doc") }

    huru_bin = huru_src.pathmap("%{^lib/HuzuRelay,bin}p") 

    huru_bin.zip(huru_src).each do |target, source|
        copy_file_task source, target
    end

    #gonna invoke the file tasks here because these are dynamic and so can't define as dependencies
    huru_bin.each {|f| Rake::Task[f].execute }
end


task :check_for_eggs do
    egg_dir = `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`
end

task :copy_stuff => [:copy_huru_files, :copy_picto_src]

task :default => :copy_stuff
