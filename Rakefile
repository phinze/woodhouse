desc 'run tests for woodhouse'
task :test do
  sh "ocrunner -s macosx10.7 -t WoodhouseTests"
end

desc 'automatically run tests when files change'
task :autotest do
  sh "ocrunner -a -g -s macosx10.7 -t WoodhouseTests"
end

desc 'build release target of woodhouse'
task :build do
  sh "xcodebuild -scheme Woodhouse -config Release -target Woodhouse"
end

desc 'build, sign, and package a Woodhouse dmg'
task :package => :build do
  require 'rubygems'
  require 'plist'
  info_plist = Plist::parse_xml('./build/Release/Woodhouse.app/Contents/Info.plist')
  version = info_plist["CFBundleVersion"]
  dmg_filename = "build/Woodhouse-#{version}.dmg"
  sh %Q{
    hdiutil create -ov -fs HFS+ -volname "Woodhouse" -srcfolder "build/Release/Woodhouse.app" "#{dmg_filename}"
  }
  sh %Q{
    ruby tools/sign_update.rb #{dmg_filename} ~/.keys/woodhouse-private.pem
  }
end


task :default => :test
