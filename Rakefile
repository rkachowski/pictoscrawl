require "fileutils"
include FileUtils

directory "bin"
directory "lib"

PICTO_SRC = FileList["src/**/*"]
PICTO_BIN = PICTO_SRC.pathmap("%{^src,bin}p")

HUZU_RELAY_DOWNLOAD = "http://www.huzutech.com/Themes/Huzutech/downloads/HuzuRelay.zip"
HURU_SRC = FileList["lib/HuzuRelay/**/*"]

PICTO_BIN.zip(PICTO_SRC).each do |target, source|
    copy_file_task source, target
end

def copy_file_task(source, target)
    file target => [source, "bin"] do
        containing_dir = target.pathmap "%d"
        directory containing_dir

        if File.directory?(source)
            directory target
        else
            cp source, target
        end
    end
end

file "lib/HuzuRelay.zip" => ["lib"] do
    `wget -O lib/HuzuRelay.zip #{HUZU_RELAY_DOWNLOAD}`
    `unzip lib/HuzuRelay.zip -d lib`
end

file HURU_SRC => ["lib/HuzuRelay.zip"]

task :check_for_eggs do
    egg_dir = `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`

end

task :default => PICTO_BIN
