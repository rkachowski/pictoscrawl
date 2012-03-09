require "fileutils"

directory "bin"

task :make_bundle do
    sh "cd huru/bundle;./make_bundle.py;unzip HuzuRelay.zip"
end

task :copy_files => [:make_bundle, "bin"] do
    huru_files = Dir.glob "huru/bundle/HuzuRelay/*" 

    #don't want any of the client files or example test files
    huru_files.delete_if {|f| f.include?('client') || f.include?('test')}
    src_files = Dir.glob "src/*"

    FileUtils.cp_r huru_files, "bin"
    FileUtils.cp_r src_files, "bin"

end

task :run => :copy_files do
    sh "cd bin; ./huRUservice start picto"
end 

task :clean  => "bin" do
    sh "bin/huRUservice stop picto"
    sh "rm -fr bin"
end
