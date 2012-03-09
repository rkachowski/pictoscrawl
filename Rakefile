require "fileutils"

directory "bin"

desc "make and unzip huru bundle"
task :make_bundle do
    puts "making huru bundle.."
    `cd huru/bundle;rm -fr HuzuRelay*;./make_bundle.py;unzip HuzuRelay.zip`
end

desc "copy relevant huru files from bundle and src files from project to bin"
task :copy_files => [:make_bundle, "bin"] do
    huru_files = Dir.glob "huru/bundle/HuzuRelay/*" 

    #don't want any of the client files or example test files
    huru_files.delete_if {|f| f.include?('client') || f.include?('test')}
    src_files = Dir.glob "src/*"

    puts "copying huru files.."
    FileUtils.cp_r huru_files, "bin"
    puts "copying picto src files.."
    FileUtils.cp_r src_files, "bin"
end

desc "start the picto server"
task :run => :copy_files do
    puts "starting server"
    `cd bin; ./huRUservice start picto`
end 

desc "run picto server directly"
task :run_no_daemon => :copy_files do
    puts "running server"
    sh "cd bin;twistd --nodaemon -y picto.tac"
end

desc "wipe out the bin folder"
task :clean  => "bin" do
    puts "cleaning.."
    `bin/huRUservice stop picto`
    `rm -fr bin`
end
